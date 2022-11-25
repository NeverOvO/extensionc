import 'dart:convert';
import 'package:coinstart_wallet_extension/api/sui_api.dart';
import 'package:coinstart_wallet_extension/base/MyBotTextToast.dart';
import 'package:coinstart_wallet_extension/controller/safe_storage.dart';
import 'package:coinstart_wallet_extension/main.dart';
import 'package:dart_ipify/dart_ipify.dart';
import 'package:cryptography/cryptography.dart';
import 'package:flutter/widgets.dart' as widget;
import 'package:coinstart_wallet_extension/controller/format.dart';
import 'package:coinstart_wallet_extension/controller/mnemonic.dart';
import 'package:get/get.dart';
import 'package:coinstart_wallet_extension/controller/json.dart';
import 'package:coinstart_wallet_extension/controller/sui_sdk.dart';
import 'package:encrypt/encrypt.dart';
import 'package:neveruseless/never/neverLocalStorage.dart';

class SuiWalletController extends GetxController {
  var safeStorage = SafeStorage();
  List<SuiWallet> wallets = [];
  var currentWalletAddress = ''.obs;
  var transactions = [].obs;
  var ownedObjectBatch = [].obs;
  var suiGasDefault = 100;
  int currentWalletIndex = 0;
  var primaryCoinBalance = (0.0).obs;
  var publicAddress = ''.obs;
  var publicAddressFuzzyed = ''.obs;
  var NFTs = [].obs;
  var gasDefault = 0.obs;
  final currentBalance = 0.obs;

  final localPwd = "".obs;

  String _pwd = '';
  String _mnemonic = '';
  bool _isWalletInitialized = false;

  set mnemonic(String value) => _mnemonic = value;
  set pwd(String value) => _pwd = value;

  SuiWallet? get currentWallet {
    if (hasWallet) {
      if (wallets.length > currentWalletIndex) {
        currentWalletAddress.value =
            wallets[currentWalletIndex].address.toString();
        return wallets[currentWalletIndex];
      } else {
        currentWalletAddress.value = wallets[0].address.toString();
        return wallets[0];
      }
    }
    return null;
  }

  //index is 0,1,2...
  selectWallet(String key) async{
    neverLocalStorageWrite("NowAddressKey", key);
  }

  initWallet() async {
    if (!_isWalletInitialized) {
      final p = _pwd;
      final m = _mnemonic;
      _pwd = '';
      _mnemonic = '';
      await addWallet(m, p);
    }
  }

  encryptMnemonic(String mnemonic, String pwd) {
    String ss = pwd + pwd + pwd + pwd;
    final key = Key.fromUtf8(ss.substring(0, 32));
    final iv = IV.fromUtf8(ss.substring(0, 16));

    final encrypter = Encrypter(AES(key));

    final encrypted = encrypter.encrypt(mnemonic, iv: iv);
    // print("en iv = " + iv.toString());
    // print("encrypted = " + encrypted.base64);

    return encrypted.base64;
  }

  decryptMnemonic(encmnemonic, String pwd) {
    if(encmnemonic.toString() == "display"){
      encmnemonic = currentWallet?._mnemonic;
    }
    String ss = pwd + pwd + pwd + pwd;
    final key = Key.fromUtf8(ss.substring(0, 32));
    final iv = IV.fromUtf8(ss.substring(0, 16));
    final encrypter = Encrypter(AES(key));

    final decrypted = encrypter.decrypt(Encrypted.from64(encmnemonic), iv: iv);
    return decrypted;
  }

  getPrivateKey(String pwd){
    return currentWallet?._mnemonic;
  }


  bool get hasWallet {
    return wallets.isNotEmpty;
  }

  get suiBalance => getSuiBalance();

  getSuiBalance() {
    final balance = currentWalletBalance[coinSuiType] ?? 0;
    // widget.WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   currentBalance.value = balance;
    // });
    currentBalance.value = balance;
    return balance;
  }

  userlogin(String pwd) async {
    final ipv4 = await Ipify.ipv4();
    var sig = "none sig";
    if (pwd == "") {
      final ipv4 = await Ipify.ipv4();
    } else {
      var bytes = utf8.encode(ipv4); // data being hashed
      sig = await signMsg(bytes, pwd);
    }
    // print(sig);
    await currentWallet?._suiApi?.userLogin(
        UserData(account: currentWalletAddress.string, memo: ipv4, sign: sig));
  }

  get currentWalletAddressFuzzyed {
    return addressFuzzy(currentWalletAddress.value);
  }

  get currentWalletAddressStandard {
    return addressStandard(currentWalletAddress.value);
  }

  get currentWalletBalance {
    final Map<String, num> acc = {};
    ownedObjectBatch
        .where((element) => isCoin((element as SuiObject).type))
        .forEach((element) {
      final coinType = coinTypeArgRegExp.firstMatch(element.type)?[1];

      if (coinType is String) {
        if (acc[coinType] is num) {
          acc[coinType] = acc[coinType]! + (element.fields['balance'] ?? 0);
        } else {
          acc[coinType] = (element.fields['balance'] ?? 0);
        }
      }
    });

    return acc;
  }


  List<SuiObject> get currentWalletNFTs {
    final List<SuiObject> nfts = [];
    ownedObjectBatch
        .where((element) => !isCoin((element as SuiObject).type))
        .where((element) =>
            (element as SuiObject).dataType == 'moveObject' &&
            (element).hasPublicTransfer)
        .forEach((element) {
      nfts.add(element);
    });
    return nfts;
  }

  get transactionsSend {
    return transactions.takeWhile((element) => element.isSender);
  }

  get transactionsReceive {
    return transactions.takeWhile((element) => !element.isSender);
  }

  updateCallback(
      {primaryCoinBalance,
      publicAddress,
      publicAddressFuzzyed,
      transactions,
      NFTs,
      gasDefault}) {
    this.primaryCoinBalance.value = primaryCoinBalance;
    this.publicAddress.value = publicAddress;
    this.publicAddressFuzzyed.value = publicAddressFuzzyed;
    this.transactions.value = transactions;
    this.NFTs.value = NFTs;
    this.gasDefault.value = gasDefault;
  }

  addWallet(String mnemonic, String pwd) async {
    var enc = encryptMnemonic(mnemonic, pwd);
    wallets.insert(0,SuiWallet(mnemonic: enc, suiApi: SuiApi()));
    var address = await getSuiAddress(await getKeypairFromMnemonics(mnemonic));
    var storedata = "$enc   *   $address";
    currentWalletIndex = wallets.length - 1;
    String key = address.toString().substring(address.length - 6);
    safeStorage.write(key, storedata);
    await neverLocalStorageWrite("NowAddressKey", key);
    currentWalletAddress.value = address;
    currentWallet?.address = currentWalletAddress.value;
    userlogin(pwd);
    if (hasWallet) {
      initCurrentWallet(pwd);
    }
  }

  loadStorageWallet({bool clean = false}) async {
    final all = await safeStorage.readAll();
    wallets.clear();
    all.forEach((key, value) {
      if (value.contains('*')) {
        var mnemonic = value.split("   ").first;
        var addr = value.split("   ").last;
        SuiWallet xx = SuiWallet(mnemonic: mnemonic, suiApi: SuiApi());
        xx.address = addr;
        xx.name = key;
        wallets.add(xx);
      }
    });


    if (hasWallet) {

      var NowAddressKey = await neverLocalStorageRead("NowAddressKey");
      if(NowAddressKey.toString() !=  "null"){
        int number = wallets.indexWhere((element) => element.name == NowAddressKey);
        currentWalletAddress.value = wallets[number].address!;
        currentWallet?.address = wallets[number].address!;
        currentWallet?.name  = wallets[number].name!;
      }else{
        currentWalletAddress.value = wallets.first.address!;
        currentWallet?.address = wallets.first.address!;
        currentWallet?.name  = wallets.first.name!;
      }
      initCurrentWallet("");
      userlogin("");
    }
  }

  loadStorageWalletSelect({bool clean = false}) async {
    final all = await safeStorage.readAll();
    wallets.clear();
    all.forEach((key, value) {
      if (value.contains('*')) {
        var mnemonic = value.split("   ").first;
        var addr = value.split("   ").last;
        SuiWallet xx = SuiWallet(mnemonic: mnemonic, suiApi: SuiApi());
        xx.address = addr;
        xx.name = key;
        wallets.add(xx);
      }
    });
  }

  initCurrentWallet(String pwd) async {
    if (hasWallet) {
      if (pwd != "") {
        // String demnemonic =
        //     decryptMnemonic(currentWallet?._mnemonic ?? '', pwd);
        // currentWalletAddress.value =
        //     await getSuiAddress(await getKeypairFromMnemonics(demnemonic));
        // currentWallet?.address = currentWalletAddress.value;
        // print("currentWalletAddress.value=" + currentWalletAddress.value);
      }
    }
  }

  getOwnedObjectBatch() async {
    if (hasWallet) {
      if (currentWallet == null) {
        var suiapi = SuiApi();
        final objectIds =
            await suiapi.getObjectsOwnedByAddress(currentWalletAddress.string);
        return await suiapi.getObjectBatch(objectIds);
      }
      final objectIds = await currentWallet?._suiApi
          ?.getObjectsOwnedByAddress(currentWalletAddress.string);
      return await currentWallet?._suiApi?.getObjectBatch(objectIds);
    }

    return [];
  }

  getFaucet() async {
    await currentWallet?._suiApi?.getSuiFaucet(currentWalletAddress.string);
  }

  getBalance() async {
    ownedObjectBatch.value = await getOwnedObjectBatch();
  }

  getNFTs() async {
    ownedObjectBatch.value = await getOwnedObjectBatch();
  }

  getTransactionsForAddress() async {
    if (hasWallet) {
      transactions.value = await currentWallet?._suiApi
              ?.getTransactionsForAddress(currentWalletAddress.string) ??
          [];
    }
  }

  deleteWallet(String index) async {
    safeStorage.deleteSecureData(index);
    // if (hasWallet) {
    //   safeStorage.deleteAll();
    // }
  }

  //根据手续费大小选择用于支付手续费的Object 返回其Id
  getGasPayObjId(num amount) {
    final coins = ownedObjectBatch
        .where((element) =>
            isCoin((element as SuiObject).type) && isSuiCoin(element.type))
        .toList();

    if (coins.isEmpty) {
      // print("coins.isEmpty !!!!!");
      return null;
    }

    final coin = prepareCoinWithEnoughBalance(coins as List<SuiObject>, amount)
        as SuiObject;
    return getCoinId(coin);
  }

 //transferSuiObject
  Future<SuiTansaction?> transferNFT(
      SuiObject nft, String recipient, String pwd) async {
    final transferSuiObjTransaction = [
      '0x${suiWallet.currentWalletAddress.value}',
      getCoinId(nft),
      null,
      defaultGasBudgetForMoveCall,
      recipient
    ];

    final response = await currentWallet?._suiApi
        ?.transferSuiObject(transferSuiObjTransaction);

    final txByte = JSON.resolve(
        json: response.data, path: 'result.txBytes', defaultValue: '');

    final executeSuiTransaction = await signTx(txByte, pwd);

    return await currentWallet?._suiApi?.suiExecuteTransaction(
        suiWallet.currentWalletAddress.value, executeSuiTransaction);
  }

  /*
  Params
signer : <SuiAddress> - the transaction signer's Sui address
package_object_id : <ObjectID> - the Move package ID, e.g. `0x2`
module : <string> - the Move module name, e.g. `devnet_nft`
function : <string> - the move function name, e.g. `mint`
type_arguments : <[TypeTag]> - the type arguments of the Move function
arguments : <[SuiJsonValue]> - the arguments to be passed into the Move function, in <a href="https://docs.sui.io/build/sui-json">SuiJson</a> format
gas : <ObjectID> - gas object to be used in this transaction, the gateway will pick one from the signer's possession if not provided
gas_budget : <uint64> - the gas budget, the transaction will fail if the gas cost exceed the budget
*/

  Future<SuiTansaction?> suiMoveCall(
      MoveCallTransaction transaction, String pwd) async {
    //try {
      final response = await currentWallet?._suiApi?.suiMoveCall([
        '0x${suiWallet.currentWalletAddress.value}',
        transaction.packageObjectId,
        transaction.module,
        transaction.function,
        transaction.typeArguments,
        transaction.arguments,
        transaction.gasPayment,
        transaction.gasBudget
      ]);
      // print("response:  "+response.toString());
      final txByte = JSON.resolve(json: response.data, path: 'result.txBytes', defaultValue: '');

      final executeSuiTransaction = await signTx(txByte, pwd);

      return await currentWallet?._suiApi?.suiExecuteTransaction(
          '0x${suiWallet.currentWalletAddress.value}', executeSuiTransaction);
    // } catch (e) {
    //   showError('executeMoveCall Error', e.toString());
    //   return null;
    // }
  }

  Future<SuiTansaction?> transferSui(
      String recipient, int amount, String pwd) async {
    try {
      print("start transferSui !!!!!");
      // sui coins
      final coins = ownedObjectBatch
          .where((element) =>
              isCoin((element as SuiObject).type) && isSuiCoin(element.type))
          .toList();

      if (coins.isEmpty) {
        // print("coins.isEmpty !!!!!");
        return null;
      }

      final coin = prepareCoinWithEnoughBalance(
              coins as List<SuiObject>, amount + defaultGasBudgetForMerge)
          as SuiObject;

      final transferSuiTransaction = [
        '0x${suiWallet.currentWalletAddress.value}',
        getCoinId(coin),
        defaultGasBudgetForTransferSUI,
        recipient,
        amount
      ];

      final response =
          await currentWallet?._suiApi?.suiTransferSui(transferSuiTransaction);
      final txByte = JSON.resolve(
          json: response.data, path: 'result.txBytes', defaultValue: '');

      final executeSuiTransaction = await signTx(txByte, pwd);



      return await currentWallet?._suiApi?.suiExecuteTransaction(suiWallet.currentWalletAddress.value, executeSuiTransaction);
    } catch (e) {
      // print(e.toString());
      showError('transferSui', e.toString());
      return null;
    }
  }

  //split
  splitSui(String coinobjectid, String feeobjectid, List<int> splitamounts,
      String pwd) async {
    try {
      // print("start splitSui !!!!!");

      final transferSuiTransaction = [
        '0x${suiWallet.currentWalletAddress.value}',
        coinobjectid,
        splitamounts,
        feeobjectid,
        defaultGasBudgetForSplit
      ];

      final response =
          await currentWallet?._suiApi?.splitSui(transferSuiTransaction);
      final txByte = JSON.resolve(
          json: response.data, path: 'result.txBytes', defaultValue: '');
      
      final executeSuiTransaction = await signTx(txByte, pwd);

      await currentWallet?._suiApi?.suiExecuteTransaction(
          suiWallet.currentWalletAddress.value, executeSuiTransaction);
    } catch (e) {
      showError('splitSui', e.toString());
      // return null;
    }
  }

  /*
  tx_bytes : <Base64> - transaction data bytes, as base-64 encoded string
  sig_scheme : <SignatureScheme> - Flag of the signature scheme that is used.
  signature : <Base64> - transaction signature, as base-64 encoded string
  pub_key : <Base64> - signer's public key, as base-64 encoded string
  request_type : <ExecuteTransactionRequestType> - The request type
  */
  signTx(txByte, String pwd) async {
    // print("pwd ="+pwd);
    String demnemonic = decryptMnemonic(currentWallet?._mnemonic ?? '', pwd);
    // print(demnemonic.toString());
    final keypair = await getKeypairFromMnemonics(demnemonic);
    final algorithm = Ed25519();
    keypair.extractPrivateKeyBytes();
    final signature = base64.encode((await algorithm.sign(base64.decode(txByte), keyPair: keypair)).bytes);
    final publicKey = base64.encode((await keypair.extractPublicKey()).bytes);
    return [txByte, "ED25519", signature, publicKey, "WaitForLocalExecution"];
  }

  signMsg(msg, pwd) async {
    String demnemonic = decryptMnemonic(currentWallet?._mnemonic ?? '', pwd);
    final keypair = await getKeypairFromMnemonics(demnemonic);
    final algorithm = Ed25519();
    keypair.extractPrivateKeyBytes();
    final signature =
        base64.encode((await algorithm.sign(msg, keyPair: keypair)).bytes);
    return signature;
  }

  needMerge(int amount) {
    final coins = ownedObjectBatch
        .where((element) =>
            isCoin((element as SuiObject).type) && isSuiCoin(element.type))
        .toList();
    //log coins

    if (checkIfMergeIsNeed(
        coins as List<SuiObject>, amount + defaultGasBudgetForMerge)) {
      // print("check Merge Is Needed");
      return true;
    } else {
      // print("check Merge Is Not Needed");
      return false;
    }
  }

  //多个Object先Merge
  Future<SuiTansaction?> mergeSuiObjects(int amount, String pwd) async {
    try {
      // print("start mergeSuiObjects !!!!!");

      final coins = ownedObjectBatch
          .where((element) =>
              isCoin((element as SuiObject).type) && isSuiCoin(element.type))
          .toList();
      //log coins
      // for (var ccc in coins) {
      //   print("coins =" +
      //       getCoinId(ccc) +
      //       " balance = " +
      //       (ccc).fields['balance']);
      // }

      if (coins.isEmpty) {
        // print("coins.isEmpty !!!!!");
        return null;
      }
      //primaryCoin
      final coin = prepareCoinWithEnoughBalance(
              coins as List<SuiObject>, amount + defaultGasBudgetForMerge)
          as SuiObject;

      final coinToMerge = coinsToMerge(coins);
      if (coinToMerge == Null) {
        // print("No coin to merge");
        return null;
      }
      // bool enough = checkIfAmountIsENoughAfterMerge(coin, coinToMerge, amount, defaultGasBudgetForTransferSUI);

      final transferSuiTransaction = [
        '0x${suiWallet.currentWalletAddress.value}',
        getCoinId(coin),
        getCoinId(coinToMerge),
        getCoinId(coin),
        defaultGasBudgetForTransferSUI,
      ];

      final response =
          await currentWallet?._suiApi?.suiMergeCoins(transferSuiTransaction);

      final txByte = JSON.resolve(
          json: response.data, path: 'result.txBytes', defaultValue: '');

      // print("txByte = " + txByte.toString());

      final executeSuiTransaction = await signTx(txByte, pwd);

      return await currentWallet?._suiApi?.suiExecuteTransaction(
          suiWallet.currentWalletAddress.value, executeSuiTransaction);
    } catch (e) {
      showError('mergeSuiObjects error!', e.toString());
      return null;
    }
  }

  //pay sui with multi pbjects
  /*
Note: !!! Gas coin should not in input coins of Pay transaction !!!!!!

Params
signer : <SuiAddress> - the transaction signer's Sui address
input_coins : <[ObjectID]> - the Sui coins to be used in this transaction
recipients : <[SuiAddress]> - the recipients' addresses, the length of this vector must be the same as amounts.
amounts : <[]> - the amounts to be transferred to recipients, following the same order
gas : <ObjectID> - gas object to be used in this transaction, the gateway will pick one from the signer's possession if not provided
gas_budget : <uint64> - the gas budget, the transaction will fail if the gas cost exceed the budget
  */
  Future<SuiTansaction?> paySuiObjects(
      String recipient, int amount, String pwd) async {
    // try {
    final coins = ownedObjectBatch
        .where((element) =>
            isCoin((element as SuiObject).type) && isSuiCoin(element.type))
        .toList();
    if (coins.isEmpty) {
      print("coins.isEmpty !!!!!");
      return null;
    }

    num totalbalances = 0;
    for (var ccc in coins) {
      totalbalances += (ccc).fields['balance'];
    }
    if (totalbalances - defaultGasBudgetForTransferSUI - amount < 0) {
      print("Not enough balance");
      return null;
    }
    final coinsToSend = prepareCoinsWithEnoughTotalBalance(
            coins as List<SuiObject>, amount + defaultGasBudgetForMerge)
        as List<SuiObject>;
    List<String> idOfCoins = []; //param 1
    for (SuiObject sss in coinsToSend) {
      print("coinid = ${getCoinId(sss)}");
      idOfCoins.add(getCoinId(sss));
    }
    if (coinsToSend.length == coins.length) {
      //No object to pay fee
      if (coinsToSend.length == 1) {
        return await transferSui(recipient, amount, pwd);
      } else {
        int leftamount = coinsToSend[0].fields['balance'] -
            defaultGasBudgetForTransferSUI * idOfCoins.length;
        int leftfee = defaultGasBudgetForTransferSUI * idOfCoins.length;
        if (leftamount <= 0) {
          print("balances not enough 1");
          return null;
        }
        if (coinsToSend[1].fields['balance'] < defaultGasBudgetForTransferSUI) {
          print("balances not enough 2");
          return null;
        }
        await splitSui(getCoinId(coinsToSend[0]), getCoinId(coinsToSend[1]),
            [leftamount, leftfee], pwd);
        await suiWallet.getBalance();
        return paySuiObjects(recipient, amount, pwd);
      }
      //return null;
    } else {
      //1*
      String feecoinId = "no";
      for (SuiObject sx in coins) {
        print("current sx = " + getCoinId(sx));
        if (idOfCoins.contains(getCoinId(sx)) == false &&
            (sx).fields['balance'] > defaultGasBudgetForTransferSUI) {
          // print("idOfCoins contains " + getCoinId(sx));
          feecoinId = getCoinId(sx);
          //  break;
        }
      }
      if (feecoinId == "no") {
        print("No object to pay fee! 2");
        return null;
      }

      List<String> recip = [];
      recip.add(recipient);
      List<int> amou = [];
      amou.add(amount);

      final transferSuiTransaction = [
        '0x${suiWallet.currentWalletAddress.value}',
        idOfCoins,
        recip,
        amou,
        feecoinId,
        defaultGasBudgetForTransferSUI * idOfCoins.length,
      ];

      final response =
          await currentWallet?._suiApi?.paySuiCoins(transferSuiTransaction);

      final txByte = JSON.resolve(
          json: response.data, path: 'result.txBytes', defaultValue: '');

      print("txByte = $txByte");

      final executeSuiTransaction = await signTx(txByte, pwd);

      return await currentWallet?._suiApi?.suiExecuteTransaction(
          suiWallet.currentWalletAddress.value, executeSuiTransaction);
    }
  }

  int suiEstimateFee(int amount) {
    final coins = ownedObjectBatch
        .where((element) =>
            isCoin((element as SuiObject).type) && isSuiCoin(element.type))
        .toList();
    if (coins.isEmpty) {
      // print("suiEstimateFee 1 "+defaultGasBudgetForTransferSUI.toString());
      return defaultGasBudgetForTransferSUI;
    }
    num totalbalances = 0;
    for (var ccc in coins) {
      totalbalances += (ccc).fields['balance'];
    }
    final coinsToSend = prepareCoinsWithEnoughTotalBalance(
            coins as List<SuiObject>, amount + defaultGasBudgetForMerge)
        as List<SuiObject>;
    if (coinsToSend.isEmpty) {
      //print("suiEstimateFee 3 "+defaultGasBudgetForTransferSUI.toString());
      return defaultGasBudgetForTransferSUI;
    }
    if (coinsToSend.length == coins.length) {
      if (coinsToSend.length == 1) {
        //print("suiEstimateFee 4 "+(defaultGasBudgetForTransferSUI + defaultGasBudgetForSplit).toString());
        return defaultGasBudgetForTransferSUI + defaultGasBudgetForSplit;
      } else {
        //print("suiEstimateFee 5 "+(defaultGasBudgetForSplit + defaultGasBudgetForTransferSUI * coins.length).toString());
        return defaultGasBudgetForSplit +
            defaultGasBudgetForTransferSUI * coins.length;
      }
    } else {
      //print("suiEstimateFee 6 "+(defaultGasBudgetForSplit +defaultGasBudgetForTransferSUI * coins.length).toString());
      return defaultGasBudgetForSplit + defaultGasBudgetForTransferSUI * coinsToSend.length;
    }
  }

  /*获取交易记录
  {
  "jsonrpc": "2.0",
  "id": 1,
  "method": "sui_getTransactions",
  "params": [
    {
      "FromAddress": "0xdb360a6241bcc14f185767c526d8cb7e41a92869" // `All`, `MoveFunction`, `InputObject`, `MutatedObject`, `FromAddress`, `ToAddress`
    },
    null,
    100,
    "Ascending"
  ]
}
  */

  //get txs
  //Future<List<SuiTansaction>?>
 getTxDigestForCurrentwallet() async {
    transactions.value = await currentWallet?._suiApi
            ?.getTransactionsForAddress(suiWallet.currentWalletAddress.value) ??
        [];
  }
}

class SuiWallet {
  String? _mnemonic;
  SuiApi? _suiApi;
  String? address;
  String? name;
  SuiWallet({required String mnemonic, required SuiApi suiApi}) {
    _mnemonic = mnemonic;
    _suiApi = suiApi;
  }

  executeMoveCall(transaction) {
    //ToDo
  }
}
