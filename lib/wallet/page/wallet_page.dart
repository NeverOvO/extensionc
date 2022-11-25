import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:coinstart_wallet_extension/Base/Global.dart';
import 'package:coinstart_wallet_extension/base/MyBotTextToast.dart';
import 'package:coinstart_wallet_extension/base/image_helper.dart';
import 'package:coinstart_wallet_extension/controller/sui_wallet_controller.dart';
import 'package:coinstart_wallet_extension/generated/l10n.dart';
import 'package:coinstart_wallet_extension/main.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:neveruseless/neveruseless.dart';

class WalletPage extends StatefulWidget {
  final Map? arguments;
  const WalletPage({Key? key, this.arguments}) : super(key: key);

  @override
  createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> with AutomaticKeepAliveClientMixin,SingleTickerProviderStateMixin {

  SuiWalletController suiWallet = Get.find();

  List allCoinList = [
    "ETH",
    "SUI",
    "AVAX",
    "BNB",
    "FIL",
    "OKX",
    "SNX",
    "TRX",
    "USDT",
  ];

  List userCoinList = [];

  List userNFTList = [];

  bool _canTakeAirDrop = true;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      Future.delayed(const Duration(seconds: 1)).then((value) async {
        // await suiWallet.initWallet();
        // await suiWallet.getBalance();
        // await suiWallet.loadStorageWallet();
        setState(() {});
      }).then((value){
        readUserCoinList();
      });

    });
    super.initState();
    PagePick.nowPageName = '/WalletPage';

    neverBus.on('checkLanguage', (object) {
      setState(() {
        if(object == "en"){
          print("切换语言EN");
          localNow = "English";
          S.load(const Locale('en', 'US'));
        }else{
          print("切换语言ZH");
          localNow = "中文简体";
          S.load(const Locale("zh", "ZH"));
        }
      });
    });

    neverBus.on('upload', (object) {
      uploadData();
    });

  }

  @override
  void dispose() {

    super.dispose();
  }

  void readUserCoinList() async{
    var tList = await neverLocalStorageRead(suiWallet.currentWalletAddress.toString());
    if(tList.toString() == "" || tList.toString() == "null"){
      userCoinList = [];
    }else{
      try{
        userCoinList = tList.toString().split(",");
        setState(() {});
      }catch(e){
        userCoinList = [];
      }
    }
    uploadData();
  }

  void uploadData() async{
    await suiWallet.getSuiBalance();
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      right: true,
      bottom: false,
      left: true,
      top: false,
      child: Scaffold(
          backgroundColor: APP_MainBGColor,
          body:Column(
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(15, MediaQuery.of(context).padding.top + 10, 15, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: (){

                      },
                      child: Container(
                        decoration: const BoxDecoration(
                          color: APP_MainGrayColor,
                          borderRadius: BorderRadius.all(Radius.circular(7.0)),
                        ),
                        padding: const EdgeInsets.fromLTRB(10, 5, 5, 5),
                        child: Row(
                          children: [
                            const ImageHelper('/images/coinstart_logo.png',height: 20,width: 20,),
                            Container(
                              padding: const EdgeInsets.fromLTRB(10, 0, 5, 0),
                              child: const Text("Wallet",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600,color: Colors.white),),
                            ),
                            const Icon(Icons.arrow_drop_down_rounded,color: Colors.white,size: 20,),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: (){
                        showModalBottomSheet(
                          backgroundColor: Colors.transparent,
                          context: context,
                          isScrollControlled : true,
                          builder: (context){
                            return Container(
                              decoration: const BoxDecoration(
                                color: Color.fromRGBO(20, 21, 26, 1),
                                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                              ),
                              margin: const EdgeInsets.fromLTRB(0, 100, 0, 0),
                              alignment: Alignment.centerLeft,
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const SizedBox(width: 20,),
                                        Text(S.current.Select_Network, style: const TextStyle(color: Colors.white,fontSize: 13),),
                                        GestureDetector(
                                          onTap: (){
                                            Navigator.of(context).pop();
                                          },
                                          behavior: HitTestBehavior.opaque,
                                          child: Container(
                                            // color: Colors.white,
                                            padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                                            alignment: Alignment.centerRight,
                                            child: const Icon(Icons.close,color: Colors.white,size: 20,),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Divider(height: 2,color: APP_MainGrayColor,),
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: 10,
                                      itemBuilder: (context,index){
                                        return GestureDetector(
                                            behavior: HitTestBehavior.opaque,
                                            onTap: (){
                                              Navigator.pop(context);
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  const ImageHelper('/images/link_wallet_button_icon.png',height: 30,width: 30,),
                                                  const SizedBox(width: 10,),
                                                  Text("SUI${index.toString()}",style: const TextStyle(fontSize: 14,color: Colors.white,fontWeight: FontWeight.w600),),
                                                  const Expanded(child: SizedBox()),
                                                  // netword_done.png
                                                  Offstage(
                                                    offstage: index != 0,
                                                    child: const ImageHelper('/images/netword_done.png',height: 15,width: 15,),
                                                  ),
                                                  const SizedBox(width: 5,),
                                                ],
                                              ),
                                            )
                                        );
                                      },
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                        );
                      },
                      child: Container(
                        decoration: const BoxDecoration(
                          color: APP_MainGrayColor,
                          borderRadius: BorderRadius.all(Radius.circular(7.0)),
                        ),
                        padding: const EdgeInsets.fromLTRB(10, 5, 5, 5),
                        child: Row(
                          children: const [
                            ImageHelper('/images/link_wallet_button_icon.png',height: 22,width: 22,),
                            SizedBox(width: 5,),
                            Text("SUI",style: TextStyle(fontSize: 15,color: Colors.white,fontWeight: FontWeight.w600),),
                            Icon(Icons.arrow_drop_down_rounded,color: Colors.white,size: 20,),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.fromLTRB(20, 10, 0, 20),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.all(Radius.circular(16.0)),
                  ),
                  child: const SizedBox(height: 16,width: 16,),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: AutoSizeText(
                          "\$${NumUtil.getNumByValueDouble(neverDoubleTryOrZero(suiWallet.currentBalance.value.toString()) / 1000000000, 9)}",
                          style: const TextStyle(color: Colors.white, fontSize: 35, fontWeight: FontWeight.w700),
                          minFontSize: 12,
                          stepGranularity: 1.2,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        Navigator.pushNamedAndRemoveUntil(context, "/NeedPasswordPage", (route) => false);
                      },
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(0, 0, 10, 5),
                        decoration:  const BoxDecoration(
                          color: Color.fromRGBO(91, 163, 211, 1),
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        ),
                        padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                        child: const Text("Lock",style: TextStyle(fontSize: 14,color: Colors.white,fontWeight: FontWeight.w600),),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                child: GestureDetector(
                  onTap: (){
                    Clipboard.setData(ClipboardData(text: "0x${suiWallet.currentWalletAddress}"));
                    showMyCustomCopyText(S.current.Copy_successfully);
                  },
                  child: Row(
                    children: [
                      Text(suiWallet.currentWalletAddressFuzzyed.toString(), style: const TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w500),),
                      const SizedBox(width: 5,),
                      const ImageHelper("/images/copy.png",width:16,height: 16,),
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 20, 10, 19),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    actionButton(
                      title: S.of(context).Buy,
                      icon: '/icons/buy.png',
                      onTap: () {},
                      enable: false,
                    ),
                    actionButton(
                      title: S.of(context).Receive,
                      icon: '/icons/receive.png',
                      onTap: () {
                        showModalBottomSheet(
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          context: context,
                          builder: (context){
                            return Container(
                              decoration: const BoxDecoration(
                                color: Color.fromRGBO(20, 21, 26, 1),
                                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                              ),
                              alignment: Alignment.centerLeft,
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        GestureDetector(
                                          onTap: (){
                                            Navigator.of(context).pop();
                                          },
                                          child: Container(
                                            // color: Colors.white,
                                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                            alignment: Alignment.centerRight,
                                            child: const Icon(Icons.keyboard_arrow_left_rounded,color: Colors.white,size: 30,),
                                          ),
                                        ),
                                        Text(S.current.Select_the_currency_to_receive, style: const TextStyle(color: Colors.white,fontSize: 13,fontWeight: FontWeight.w600),),
                                        const SizedBox(width: 30,),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: allCoinList.length,
                                      itemBuilder: (context,index){
                                        return GestureDetector(
                                            behavior: HitTestBehavior.opaque,
                                            onTap: (){
                                              Navigator.pop(context);
                                              Navigator.pushNamed(context, "/ReceiveQRPage",arguments: {
                                                "coin" : allCoinList[index],
                                              });
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  ImageHelper('/icons/crypto/${allCoinList[index]}.png',height: 30,width: 30,),
                                                  const SizedBox(width: 10,),
                                                  Text(allCoinList[index],style: const TextStyle(fontSize: 14,color: Colors.white,fontWeight: FontWeight.w600),),
                                                ],
                                              ),
                                            )
                                        );
                                      },
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                    actionButton(
                      title: S.of(context).Send,
                      icon: '/icons/send.png',
                      onTap: () {

                        showModalBottomSheet(
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          context: context,
                          builder: (context){
                            return Container(
                              decoration: const BoxDecoration(
                                color: Color.fromRGBO(20, 21, 26, 1),
                                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                              ),
                              alignment: Alignment.centerLeft,
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        GestureDetector(
                                          onTap: (){
                                            Navigator.of(context).pop();
                                          },
                                          child: Container(
                                            // color: Colors.white,
                                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                            alignment: Alignment.centerRight,
                                            child: const Icon(Icons.keyboard_arrow_left_rounded,color: Colors.white,size: 30,),
                                          ),
                                        ),
                                        Text(S.current.Select_transfer_network, style: const TextStyle(color: Colors.white,fontSize: 13,fontWeight: FontWeight.w600),),
                                        const SizedBox(width: 30,),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: allCoinList.length,
                                      itemBuilder: (context,index){
                                        return GestureDetector(
                                            behavior: HitTestBehavior.opaque,
                                            onTap: (){
                                              Navigator.pop(context);
                                              Navigator.pushNamed(context, "/TokenTransferPage",arguments: {
                                                "coin" : allCoinList[index],
                                              });
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  ImageHelper('/icons/crypto/${allCoinList[index]}.png',height: 30,width: 30,),
                                                  const SizedBox(width: 10,),
                                                  Text(allCoinList[index],style: const TextStyle(fontSize: 14,color: Colors.white,fontWeight: FontWeight.w600),),
                                                ],
                                              ),
                                            )
                                        );
                                      },
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                    actionButton(
                      title: S.of(context).Swap,
                      icon: '/icons/swap.png',
                      onTap: () {
                        Navigator.pushNamed(context, "/SwapPage",arguments: {
                          "coin" : "",
                        });
                      },
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.all(Radius.circular(99.0)),
                    ),
                    padding: const EdgeInsets.all(10),
                    child:ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: const Image(image: AssetImage("assets/images/sui_icon_TR.png"), fit: BoxFit.contain,height: 16,width: 16,color: Colors.transparent,),
                    ),
                  ),//单纯占位
                  InkWell(
                    onTap: (){

                    },
                    child: Container(
                      decoration: const BoxDecoration(
                        color: APP_MainGrayColor,
                        borderRadius: BorderRadius.all(Radius.circular(14.0)),
                      ),
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          ImageHelper('/icons/stake.png', width: 15, height: 16,),
                          SizedBox(width: 10),
                          Text('Stake and Earn', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),),
                        ],
                      ),
                    ),
                  ),

                  InkWell(
                    onTap: () async{
                      if(_canTakeAirDrop){
                        _canTakeAirDrop = false;
                        startTimeOut();
                        var result = await suiWallet.getFaucet();
                        Future.delayed(Duration(seconds: 1)).then((onValue) async{
                          neverBus.emit("upload");
                        });
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                      decoration: const BoxDecoration(
                        color: APP_MainGrayColor,
                        borderRadius: BorderRadius.all(Radius.circular(99.0)),
                      ),
                      padding: const EdgeInsets.all(10),
                      child:ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: const Image(image: AssetImage("assets/images/sui_icon_TR.png"), fit: BoxFit.contain,height: 16,width: 16,),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(0, 10, 20, 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: const Text("Assets",style: TextStyle(fontSize: 18,color: APP_MainPurpleColor,fontWeight: FontWeight.w600),),
                      ),
                    ),
                    InkWell(
                      onTap: (){

                      },
                      child: const ImageHelper('/icons/search.png',height: 20,width: 20,color: Colors.white,),
                    ),
                    const SizedBox(width: 20),
                    InkWell(
                      onTap: (){
                        addCoinSheet();
                      },
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Color(0xFF2B2B2D),
                          borderRadius: BorderRadius.all(Radius.circular(14.0)),
                        ),
                        padding: const EdgeInsets.all(5),
                        child: const ImageHelper('/icons/plus.png',height: 20,width: 20,color: Colors.white,),
                      )
                    )
                  ],
                ),
              ),
              Expanded(
                child: userCoinList.isEmpty ?
                Container(
                  alignment: Alignment.center,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: (){
                      addCoinSheet();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: const Color.fromRGBO(95, 95, 95, 0.5)),
                        borderRadius: const BorderRadius.all(Radius.circular(6.0)),
                      ),
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                      child: Text(S.current.Add_currency_1,style: const TextStyle(color: Color.fromRGBO(95, 95, 95, 1),fontSize: 13),),
                    ),
                  ),
                ):
                ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
                  itemBuilder: (context, index){
                    return InkWell(
                      hoverColor:Colors.white.withOpacity(0.2),
                      onTap: () {

                        Navigator.pushNamed(context, "/RecordPage",arguments: {
                          "coin" : userCoinList[index],
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: Row(
                          children: [
                            ImageHelper('/icons/crypto/${userCoinList[index]}.png',height: 30,width: 30,),
                            const SizedBox(width: 10,),
                            Text(userCoinList[index],style: const TextStyle(fontSize: 14,color: Colors.white,fontWeight: FontWeight.w600),),
                            const Spacer(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(userCoinList[index] == "SUI" ? (NumUtil.getNumByValueDouble(neverDoubleTryOrZero(suiWallet.suiBalance.toString()) / 1000000000, 9)).toString() :"0.00", style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),),
                                const SizedBox(height: 5,),
                                Text(userCoinList[index] == "SUI" ? "\$${NumUtil.getNumByValueDouble(neverDoubleTryOrZero(suiWallet.suiBalance.toString()) / 1000000000, 9)}" :"0.00" ,style: const TextStyle(color: Color(0xFF696969), fontSize: 11, fontWeight: FontWeight.w600),),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(height: 5);
                  },
                  itemCount: userCoinList.length,
                )
                ,
              ),
            ],
          )
      ),
    );
  }

  void addCoinSheet(){
    final TextEditingController searchController = TextEditingController();
    List tempCoinList = [];
    tempCoinList.addAll(allCoinList);
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context){
        return StatefulBuilder(
          builder: (context,mSetState){
            // final TextEditingController searchController = TextEditingController();
            return Container(
              decoration: const BoxDecoration(
                color: Color.fromRGBO(20, 21, 26, 1),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              height: 500,
              alignment: Alignment.centerLeft,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(S.current.ADD_Token, style: const TextStyle(color: Colors.white,fontSize: 13),),
                        GestureDetector(
                          onTap: (){
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            // color: Colors.white,
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                            alignment: Alignment.centerRight,
                            child: const Icon(Icons.close,color: Colors.white,size: 20,),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 2,color: APP_MainGrayColor,),
                  Container(
                    height: 40,
                    padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                    child: TextField(
                      controller: searchController,
                      cursorColor: const Color(0xFF584ED3),
                      style: const TextStyle(color: Colors.white,fontSize: 12,textBaseline: TextBaseline.alphabetic),
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
                        fillColor: Colors.white.withOpacity(0.05),
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: const BorderSide(
                            width: 0,
                            style: BorderStyle.none,
                          ),
                        ),
                        prefixIcon: const Icon(Icons.search,size: 14,color: Colors.grey,),
                      ),
                      onChanged: (coin){
                        if(coin == ""){
                          tempCoinList.clear();
                          tempCoinList.addAll(allCoinList);
                        }else{
                          tempCoinList.clear();
                          tempCoinList.addAll(allCoinList.where((element) => element.toString().toUpperCase().contains(coin.toString().toUpperCase())));
                        }
                        setState(() {});
                        mSetState(() {});
                      },
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: tempCoinList.length,
                      itemBuilder: (context,index){
                        String coin = tempCoinList[index];
                        return GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: (){
                            },
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  ImageHelper('/icons/crypto/$coin.png',height: 30,width: 30,),
                                  const SizedBox(width: 10,),
                                  Text(coin,style: const TextStyle(fontSize: 14,color: Colors.white,fontWeight: FontWeight.w600),),
                                  const Expanded(child: SizedBox()),
                                  GestureDetector(
                                    onTap: () async{
                                      if(userCoinList.contains(coin)){
                                        userCoinList.remove(coin);
                                      }else{
                                        userCoinList.add(coin);
                                      }
                                      
                                      await neverLocalStorageWrite(suiWallet.currentWalletAddress.toString(), userCoinList.join(","));

                                      setState(() {});
                                      mSetState(() {});
                                    },
                                    behavior: HitTestBehavior.opaque,
                                    child: userCoinList.contains(coin) ? const ImageHelper('/images/netword_done.png',height: 15,width: 15,) : const ImageHelper('/images/netword_done.png',height: 15,width: 15,color: APP_MainGrayColor,),
                                    // child: Icon(userCoinList.contains(coin) ? Icons.remove_circle_outline_rounded : Icons.add_circle_outline_rounded,
                                    //   color: userCoinList.contains(coin) ? Colors.red : const Color.fromRGBO(137, 56, 245, 1),size: 15,),
                                  ),
                                  const SizedBox(width: 10,),
                                ],
                              ),
                            )
                        );
                      },
                    ),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget actionButton({required String icon, required String title, required VoidCallback onTap, bool enable = true,}) {
    return InkWell(
      onTap: enable ? onTap : null,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: enable ? APP_MainGrayColor : const Color(0xFF212020),
          borderRadius: BorderRadius.circular(14),
        ),
        padding: const EdgeInsets.all(19),
        child: ImageHelper(icon),
      ),
    );
  }



  startTimeOut(){
    var duration = const Duration(seconds: 60);
    return Timer(duration ,(){
      setState(() {
        _canTakeAirDrop = true;
      });
    });
  }
}

class CoinModel {
  final String? iconUrl;
  final String? coinName;
  final String? price;
  final String? total;

  CoinModel({this.iconUrl, this.coinName, this.price, this.total});

  factory CoinModel.fromJson(Map<dynamic, dynamic> json) {
    return CoinModel(
      iconUrl : json['iconUrl'].toString(),
      coinName : json['coinName'].toString(),
      price : json['price'].toString(),
      total : json['total'].toString(),
    );
  }
}
