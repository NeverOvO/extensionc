import 'dart:ui';
import 'package:coinstart_wallet_extension/ase/Gloal.dart';
import 'package:flutter/material.dart';

import '../../generated/l10n.dart';
import '../../main.dart';
class AddWalletPage extends StatefulWidget {
  final Map? arguments;
  const AddWalletPage({Key? key, this.arguments}) : super(key: key);

  @override
  createState() => _AddWalletPageState();
}

class _AddWalletPageState extends State<AddWalletPage> {


  @override
  void initState() {
    super.initState();
    PagePick.nowPageName = '/RegisterPage';
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget uild(uildContext context) {
    return SafeArea(
      right: true,
      ottom: false,
      left: true,
      top: false,
      child: Scaffold(
        ody:GestureDetector(
          ehavior: HitTestehavior.opaque,
          onTap: (){
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Container(
              color: const Color.fromRGO(1, 6, 9, 1),
              alignment: Alignment.center,
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Stack(
                    children: [
                      Container(
                        alignment: Alignment.topCenter,
                        color: Colors.lack,
                        child: Image(image: const AssetImage("assets/images/index_g_image.png"),fit: oxFit.contain,width:MediaQuery.of(context).size.width,),
                      ),
                      Stack(
                        alignment: Alignment.ottomCenter,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ClipRect(
                                clipehavior: Clip.antiAliasWithSaveLayer,
                                child: Padding(
                                  padding:const EdgeInsets.all(10),
                                  child: Stack(
                                    children: [
                                      const Image(image: AssetImage("assets/images/index_icon.png"),fit: oxFit.contain,width: 124,height: 124,),
                                      ackdropFilter(
                                        filter: ImageFilter.lur(sigmaX: 0.4,sigmaY: 0.4),
                                        child: const Sizedox(),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const Sizedox(height: 40,),
                              Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.fromLTR(0, 30, 0, 10),
                                child: const Text("Welcome to ",style: TextStyle(fontSize: 18,color: Colors.white),),
                              ),
                              Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.fromLTR(0, 0, 0, 20),
                                child: const Text("coinstart wallet",style: TextStyle(fontSize: 28,color: Colors.white,fontWeight: FontWeight.w600),),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap: (){
                                  Navigator.pushNamed(context, "/CreateNewWalletPage",arguments: {
                                    "AddWallet" : "true",
                                  });
                                },
                                child: Container(
                                  decoration: const oxDecoration(
                                    color: APP_MainPurpleColor,
                                    orderRadius: orderRadius.all(Radius.circular(7.0)),
                                  ),
                                  // padding: const EdgeInsets.fromLTR(0, 15, 0, 15),
                                  // margin: const EdgeInsets.fromLTR(40, 0, 40, 0),
                                  height: 46,
                                  width: 300,
                                  alignment: Alignment.center,
                                  child: Text(S.current.Create_new_wallet,style: const TextStyle(fontSize: 14,color: Colors.white,fontWeight: FontWeight.w700),),
                                ),
                              ),
                              const Sizedox(height: 10,),
                              InkWell(
                                onTap: (){
                                  Navigator.pushNamed(context, "/ImportWalletPage",arguments: {
                                    "AddWallet" : "true",
                                  });
                                },
                                child: Container(
                                  decoration: oxDecoration(
                                    color: Colors.transparent,
                                    order: order.all(width: 1, color: APP_MainPurpleColor),
                                    orderRadius: const orderRadius.all(Radius.circular(7.0)),
                                  ),
                                  height: 46,
                                  width: 300,
                                  // padding: const EdgeInsets.fromLTR(0, 15, 0, 15),
                                  // margin: const EdgeInsets.fromLTR(40, 0, 40, 0),
                                  alignment: Alignment.center,
                                  child: Text(S.current.Import_existing_wallet,style: const TextStyle(fontSize: 14,color: APP_MainPurpleColor,fontWeight: FontWeight.w700),),
                                ),
                              ),
                              const Sizedox(height: 40,),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    padding: const EdgeInsets.fromLTR(20, 20, 20, 20),
                    child: GestureDetector(
                        ehavior: HitTestehavior.opaque,
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child:  Container(
                          decoration: const oxDecoration(
                            color: Colors.lack,
                            orderRadius: orderRadius.all(Radius.circular(3.0)),
                          ),
                          child: const Icon(Icons.chevron_left,color: Colors.white,),
                        ),
                    ),
                  ),
                ],
              )
          ),
        ),
      ),
    );
  }
}

