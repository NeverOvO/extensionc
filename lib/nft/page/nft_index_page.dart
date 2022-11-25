
import 'package:coinstart_wallet_extension/api/sui_api.dart';
import 'package:coinstart_wallet_extension/base/Global.dart';
import 'package:coinstart_wallet_extension/base/MyBotTextToast.dart';
import 'package:coinstart_wallet_extension/base/image_helper.dart';
import 'package:coinstart_wallet_extension/controller/sui_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'package:neveruseless/neveruseless.dart';

import '../../generated/l10n.dart';
import '../../main.dart';
class NFTIndexPage extends StatefulWidget {
  final Map? arguments;
  const NFTIndexPage({Key? key, this.arguments}) : super(key: key);

  @override
  createState() => _NFTIndexPageState();
}

class _NFTIndexPageState extends State<NFTIndexPage> with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;

  List<SuiObject>? _nftsList = [];

  @override
  void initState() {
    super.initState();
    PagePick.nowPageName = '/NFTIndexPage';

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
    // getNFTHttp();
    getNFT();
  }

  @override
  void dispose() {
    super.dispose();
  }

  getNFT() async{
    await suiWallet.getNFTs();
    setState(() {
      _nftsList = suiWallet.currentWalletNFTs;
    });
    print(_nftsList!.length);
  }

  void getNFTHttp(){
    print("Test nft mint start**************************");

    const name = 'NFT for test';
    const desc = 'Coinstart NFT description';
    const url =
        'https://gateway.pinata.cloud/ipfs/QmZ73jRb723qXftdpwmcry7vvn43dLfj3SuJddk2ZMuL4a/IMG_6646.jpg';

    String pwd = "Lai123456";
    ////Step 1. Mint

    MoveCallTransaction mintNFT = MoveCallTransaction(
        packageObjectId: '0x2',
        module: 'devnet_nft',
        function: 'mint',
        typeArguments: [],
        arguments: [name, desc, url],
        gasPayment: null,
        gasBudget: defaultGasBudgetForMoveCall);
    suiWallet.suiMoveCall(mintNFT, pwd);

    ////Step 2. get all nft
    Future.delayed(const Duration(seconds: 2)).then((onValue) async{
      getNFT();
    });


    ////Step 3. transfer nft
    // List<SuiObject> nfts = suiWallet.currentWalletNFTs;
    // print(nfts);
    // suiWallet.transferNFT(nfts[0], '0x53b8f1fc4c018e73ff1c64d7415cfef2ceca3355', pwd);

  }

  bool _isNowSort = false;


  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      right: true,
      bottom: false,
      left: true,
      top: false,
      child: Scaffold(
        body: Container(
          color: APP_MainBGColor,
          child: ListView(
            children: [
              Container(
                height: 38,
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(65, 65, 65, 1),
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                margin: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                alignment: Alignment.center,
                child: Row(
                  children: [
                    const Text("My NFT address", style: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w700),),
                    Expanded(
                      child: GestureDetector(
                        onLongPress: (){
                          getNFTHttp();
                        },
                        onTap: (){
                          Clipboard.setData(ClipboardData(text: "0x${suiWallet.currentWalletAddress}"));
                          showMyCustomCopyText(S.current.Copy_successfully);
                        },
                        behavior: HitTestBehavior.opaque,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.fromLTRB(10, 0, 5, 0),
                                alignment: Alignment.centerRight,
                                child: Text("0x${suiWallet.currentWalletAddress}", style: const TextStyle(fontSize: 12, color: Colors.white,),textAlign: TextAlign.end,),
                              ),
                            ),
                            const ImageHelper("/images/copy.png",width: 16,height: 16,),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              _nftsList!.isEmpty ?
              Container(
                alignment: Alignment.center,
                height: 400,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Image(image: AssetImage("assets/images/no_nft.png"),width: 61,height: 61,),
                    Container(
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                      alignment: Alignment.center,
                      child: Text(S.current.Null_NFTs,style: const TextStyle(fontSize: 12,color: APP_MainTextGrayColor),),
                    )

                  ],
                ),
              ) :
              Column(
                children: [
                  Container(
                      padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                      alignment: Alignment.centerLeft,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("NFT", style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.w700),),
                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: (){
                              setState(() {
                                _isNowSort = !_isNowSort;
                              });
                              getNFTHttp();
                            },
                            child: Row(
                              children: [
                                Text(S.current.AddTime, style: const TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w700),),
                                Icon(_isNowSort ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded ,color: Colors.white,size: 18,),
                              ],
                            ),
                          )
                        ],
                      )
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, //每行三列
                        childAspectRatio: 0.65, //显示区域宽高相等
                        mainAxisSpacing: 0,
                        crossAxisSpacing: 20,
                      ),
                      itemCount: _nftsList!.length,
                      itemBuilder: (context, index) {
                        
                        String url = _nftsList![index].fields["url"];
                        if(url.contains("ipfs://")){
                          url = url.replaceAll("ipfs://", "https://ipfs.io/ipfs/");
                        }
                        return GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, "/NFTDetailsPage",arguments: {
                              // "nftData" : _nftsList![index].fields,
                              "data" : _nftsList![index],
                            }).then((value){
                              getNFT();
                            });
                          },
                          behavior: HitTestBehavior.opaque,
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(0),
                                child:Image(image: NetworkImage(url), fit: BoxFit.contain,height: 120,
                                  errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                    return Container(
                                      height: 120,
                                      color: Colors.transparent,
                                      alignment: Alignment.center,
                                      child: Icon(Icons.sms_failed_rounded,color: Colors.grey.withOpacity(0.2),),
                                    );
                                  },
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                alignment: Alignment.centerLeft,
                                child: Text(_nftsList![index].fields["name"], style: const TextStyle(fontSize: 12, color: Colors.grey),),
                              ),
                              Container(
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                                alignment: Alignment.centerLeft,
                                child: Text(_nftsList![index].fields["description"], style: const TextStyle(fontSize: 11, color: Colors.white),),
                              ),
                              Container(
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: const [
                                    Image(image: AssetImage("assets/icons/crypto/ETH.png"),fit: BoxFit.contain, height: 15,),
                                    SizedBox(width: 5,),
                                    Text("0.014", style: TextStyle(fontSize: 11, color: Colors.white),),
                                    Text(" ~ \$21.20", style: TextStyle(fontSize: 11, color: Colors.grey),),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}





