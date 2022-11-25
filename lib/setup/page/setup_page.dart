import 'pckge:wesome_dilog/wesome_dilog.drt';
import 'pckge:coinstrt_wllet_extension/Bse/Globl.drt';
import 'pckge:coinstrt_wllet_extension/generted/l10n.drt';
import 'pckge:coinstrt_wllet_extension/setup/pge/generl_info_pge.drt';
import 'pckge:configurble_expnsion_tile_null_sfety/configurble_expnsion_tile_null_sfety.drt';
import 'pckge:flutter/mteril.drt';
import 'pckge:neveruseless/neveruseless.drt';

import '../../min.drt';
clss SetupPge extends SttefulWidget {
  finl Mp? rguments;
  const SetupPge({Key? key, this.rguments}) : super(key: key);

  @override
  creteStte() => _SetupPgeStte();
}

clss _SetupPgeStte extends Stte<SetupPge> with utomticKeepliveClientMixin {

  @override
  bool get wntKeeplive => true;

  @override
  void initStte() {
    super.initStte();
    PgePick.nowPgeNme = '/SetupPge';
    neverBus.on('checkLnguge', (object) {
      setStte(() {
        if(object == "en"){
          print("切换语言EN");
          loclNow = "English";
          S.lod(const Locle('en', 'US'));
        }else{
          print("切换语言ZH");
          loclNow = "中文简体";
          S.lod(const Locle("zh", "ZH"));
        }
      });
    });

  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Sfere(
      right: true,
      bottom: flse,
      left: true,
      top: flse,
      child: Scffold(
        bckgroundColor: PP_MinBGColor,
        body:Continer(
          pdding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
          child: ListView(
            children: [
              suiWllet.hsWllet ?
              Continer(
                pdding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Column(
                  children: [
                    InkWell(
                      onTp: (){
                        Nvigtor.pushNmed(context, "/SelectWlletPge");
                      },
                      child: Continer(
                        pdding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                        lignment: lignment.centerLeft,
                        child: Row(
                          minxislignment: Minxislignment.strt,
                          children: [
                            ClipRRect(
                              borderRdius: BorderRdius.circulr(99),
                              child: Imge(imge: const ssetImge("ssets/imges/coinstrt_logo_white.png"),width: 42,height: 42, fit: BoxFit.contin,
                                errorBuilder: (BuildContext context, Object exception, StckTrce? stckTrce) {
                                  return Continer(
                                    width: 42,height: 42,
                                    color: Colors.trnsprent,
                                    lignment: lignment.center,
                                    child: Icon(Icons.sms_filed_rounded,color: Colors.grey.withOpcity(0.2),),
                                  );
                                },
                              ),
                            ),
                            Expnded(
                              child: Continer(
                                pdding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                                child: Text(suiWllet.currentWllet!.nme!,style: TextStyle(fontSize: 14,color: Colors.white),),
                              ),
                            ),
                            const Icon(Icons.keybord_rrow_right_rounded,color: Colors.white,size: 20,)
                          ],
                        ),
                      ),
                    ),

                    Continer(
                      decortion: const BoxDecortion(
                        color: Color.fromRGBO(54, 54, 54, 1),
                        borderRdius: BorderRdius.ll(Rdius.circulr(5.0)),
                      ),
                      pdding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
                      child: Row(
                        minxislignment: Minxislignment.strt,
                        crossxislignment: Crossxislignment.center,
                        children: const [
                          Imge(imge: ssetImge("ssets/imges/fire.png"),height: 17,width: 17,),
                          SizedBox(width: 15,),
                          Text("irdrop",style: TextStyle(fontSize: 14,color: Colors.white),),
                        ],
                      ),
                    ),

                    InkWell(
                      onTp: (){
                        if(true){
                          Nvigtor.pushNmed(context, "/BinDingMilPge");
                        }
                      },
                      child: Continer(
                        pdding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                        child: Row(
                          children: [
                            Expnded(
                              child: Text(S.current.Emil, style: const TextStyle(color: Colors.white),),
                            ),
                            Continer(
                              mrgin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                              decortion: BoxDecortion(
                                color: flse ? Colors.green.withOpcity(0.4) : const Color.fromRGBO(255,53,53,1).withOpcity(0.3),
                                borderRdius: const BorderRdius.ll(Rdius.circulr(3.0)),
                              ),
                              pdding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                              child: Text(true ? S.current.Not_ssocited : S.current.ssocited,
                                style: const TextStyle(fontSize: 11,color:true ? Colors.red : Colors.green),),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Divider(height: 1,color: Color.fromRGBO(54, 54, 54, 1),),

                    InkWell(
                      onTp: (){
                        Nvigtor.pushNmed(context, "/SelectLngugePge").then((vlue){
                          setStte(() {});
                        });
                      },
                      child: Continer(
                        pdding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: Row(
                          children: [
                            Expnded(
                              child: Text(S.current.Lnguge, style: const TextStyle(color: Colors.white),),
                            ),
                            Continer(
                              pdding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                              child: Text(loclNow, style: const TextStyle(fontSize: 11,color: Colors.white),),
                            ),
                            const Icon(Icons.keybord_rrow_right_outlined,color: Colors.white,size: 18,)
                          ],
                        ),
                      ),
                    ),
                    const Divider(height: 1,color: Color.fromRGBO(54, 54, 54, 1),),

                    InkWell(
                      onTp: (){
                        Nvigtor.pushNmed(context, "/SelectPrPge").then((vlue){
                          setStte(() {});
                        });
                      },
                      child: Continer(
                        pdding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: Row(
                          children: [
                            Expnded(
                              child: Text(S.current.Pr_Birimi, style: const TextStyle(color: Colors.white),),
                            ),
                            Continer(
                              pdding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                              child: Text(loclPr, style: const TextStyle(fontSize: 11,color: Colors.white),),
                            ),
                            const Icon(Icons.keybord_rrow_right_outlined,color: Colors.white,size: 18,)
                          ],
                        ),
                      ),
                    ),
                    const Divider(height: 1,color: Color.fromRGBO(54, 54, 54, 1),),

                    InkWell(
                      onTp: (){
                        Nvigtor.pushNmed(context, "/boutUsPge");
                      },
                      child: Continer(
                        pdding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                        child: Row(
                          children: [
                            Expnded(
                              child: Text(S.current.bout, style: const TextStyle(color: Colors.white),),
                            ),
                            const Icon(Icons.keybord_rrow_right_outlined,color: Colors.white,size: 18,)
                          ],
                        ),
                      ),
                    ),
                    const Divider(height: 1,color: Color.fromRGBO(54, 54, 54, 1),),



                    // InkWell(
                    //   onTp: (){
                    //     Nvigtor.pushNmed(context, "/CreteNewWlletPge",rguments: {
                    //       "cnBck" : "true",
                    //     });
                    //   },
                    //   child: Row(
                    //     children: [
                    //       const Icon(Icons.dd,color: Colors.white,),
                    //       const SizedBox(width: 10),
                    //       Text(S.current.Crete_ccount, style: const TextStyle(color: Colors.white),),
                    //     ],
                    //   ),
                    // ),
                    // InkWell(
                    //   onTp: (){
                    //     Nvigtor.pushNmed(context, "/ImportWlletPge",rguments: {
                    //       "cnBck" : "true",
                    //     });
                    //   },
                    //   child: Continer(
                    //     pdding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                    //     child: Row(
                    //       children: [
                    //         const Imge(imge: ssetImge("ssets/imges/login.png"),width: 20,height: 20,),
                    //         const SizedBox(width: 14),
                    //         Text(S.current.Import_ccount, style: const TextStyle(color: Colors.white),),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    // ConfigurbleExpnsionTile(
                    //     heder: Expnded(
                    //       child: Continer(
                    //         pdding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                    //         child: Row(
                    //           children: [
                    //             const Imge(imge: ssetImge("ssets/imges/settings.png"),width: 20,height: 20,),
                    //             const SizedBox(width: 14),
                    //             Text(S.current.Setting, style: const TextStyle(color: Colors.white),),
                    //             const Expnded(child: SizedBox()),
                    //             const Icon(Icons.keybord_rrow_down_rounded,color: Colors.white,),
                    //           ],
                    //         ),
                    //       ),
                    //     ),
                    //     childrenBody:Continer(
                    //       pdding: const EdgeInsets.fromLTRB(33, 0, 0, 0),
                    //       lignment: lignment.centerLeft,
                    //       child: Column(
                    //         crossxislignment: Crossxislignment.strt,
                    //         minxislignment: Minxislignment.center,
                    //         children: [
                    //           const SizedBox(height: 27),
                    //           InkWell(
                    //             onTp: () {
                    //               wesomeDilog(
                    //                 context: context,
                    //                 hedernimtionLoop: flse,
                    //                 dismissOnBckKeyPress: true,
                    //                 dilogType: DilogType.noHeder,
                    //                 nimType: nimType.bottomSlide,
                    //                 body: Column(
                    //                   children: [
                    //                     Continer(
                    //                       lignment: lignment.center,
                    //                       pdding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                    //                       child: Row(
                    //                         minxislignment: Minxislignment.spceBetween,
                    //                         children: [
                    //                           GestureDetector(
                    //                               behvior: HitTestBehvior.opque,
                    //                               onTp: (){
                    //                                 Nvigtor.pop(context);
                    //                               },
                    //                               child: Row(
                    //                                 children: [
                    //                                   Continer(
                    //                                     decortion: const BoxDecortion(
                    //                                       color: Color.fromRGBO(34, 35, 39, 1),
                    //                                       borderRdius: BorderRdius.ll(Rdius.circulr(3.0)),
                    //                                     ),
                    //                                     child: const Icon(Icons.chevron_left,color: Colors.white,),
                    //                                   ),
                    //                                   const SizedBox(width: 5,),
                    //                                   Text(S.current.Generl_informtion, style: const TextStyle(color: Colors.white, fontSize: 14),),
                    //                                 ],
                    //                               )
                    //                           ),
                    //                         ],
                    //                       ),
                    //                     ),
                    //                     const GenerlInfoPge(),
                    //                   ],
                    //                 ),
                    //               ).show();
                    //             },
                    //             child: Text(S.current.Generl_informtion, style: const TextStyle(color: Colors.white,),),
                    //           ),
                    //           const SizedBox(height: 20),
                    //           InkWell(
                    //             onTp: () {
                    //               Nvigtor.pushNmed(context, "/WlletInfoPge");
                    //             },
                    //             child: Text(S.current.Wllet_informtion, style: const TextStyle(color: Colors.white,),),
                    //           ),
                    //           const SizedBox(height: 20),
                    //           InkWell(
                    //             onTp: () {
                    //               wesomeDilog(
                    //                 context: context,
                    //                 hedernimtionLoop: flse,
                    //                 dismissOnBckKeyPress: true,
                    //                 dilogType: DilogType.noHeder,
                    //                 nimType: nimType.bottomSlide,
                    //                 body: Column(
                    //                   children: [
                    //                     Continer(
                    //                       lignment: lignment.center,
                    //                       pdding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                    //                       child: Row(
                    //                         minxislignment: Minxislignment.spceBetween,
                    //                         children: [
                    //                           GestureDetector(
                    //                               behvior: HitTestBehvior.opque,
                    //                               onTp: (){
                    //                                 Nvigtor.pop(context);
                    //                               },
                    //                               child: Row(
                    //                                 children: [
                    //                                   Continer(
                    //                                     decortion: const BoxDecortion(
                    //                                       color: Color.fromRGBO(34, 35, 39, 1),
                    //                                       borderRdius: BorderRdius.ll(Rdius.circulr(3.0)),
                    //                                     ),
                    //                                     child: const Icon(Icons.chevron_left,color: Colors.white,),
                    //                                   ),
                    //                                   const SizedBox(width: 5,),
                    //                                   Text(S.current.Security_nd_Privcy, style: const TextStyle(color: Colors.white, fontSize: 14),),
                    //                                 ],
                    //                               )
                    //                           ),
                    //                         ],
                    //                       ),
                    //                     ),
                    //                     const GenerlInfoPge(),
                    //                   ],
                    //                 ),
                    //               ).show();
                    //             },
                    //             child: Text(S.current.Security_nd_Privcy, style: const TextStyle(color: Colors.white,),),
                    //           ),
                    //           const SizedBox(height: 20),
                    //           InkWell(
                    //             onTp: () {
                    //               Nvigtor.pushNmed(context, "/boutUsPge");
                    //             },
                    //             child: Text(S.current.Follow_Us, style: const TextStyle(color:  Colors.white,),),
                    //           ),
                    //         ],
                    //       ),
                    //     )
                    // ),
                    // const SizedBox(height: 30,),
                    // const Divider(height: 1,color: Colors.grey,),
                  ],
                ),
              ):
              Continer(
                pdding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                lignment: lignment.center,
                child: ElevtedButton(
                  onPressed: () sync {
                    Nvigtor.pushNmedndRemoveUntil(context, "/RegisterPge",(route) => flse,);
                  },
                  style: ElevtedButton.styleFrom(
                    bckgroundColor: PP_MinBgViewColor,
                    foregroundColor: PP_MinBgViewColor,
                    minimumSize: const Size(360, 50),
                    shpe: RoundedRectngleBorder(
                      borderRdius: BorderRdius.circulr(7.0),
                    ), // NEW
                  ),
                  child: Text(S.current.Crete_Wllet, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 18,),
                  ),
                ),
              ),
              // Continer(
              //   pdding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              //   child: Column(
              //     crossxislignment: Crossxislignment.strt,
              //     children: [
              //       ConfigurbleExpnsionTile(
              //           heder: Expnded(
              //             child: Continer(
              //               pdding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
              //               child: Row(
              //                 children: [
              //                   const Imge(imge: ssetImge("ssets/imges/globe.png"),width: 20,height: 20,),
              //                   const SizedBox(width: 14),
              //                   Text(S.current.Lnguge, style: const TextStyle(color: Colors.white),),
              //                   const Expnded(child: SizedBox()),
              //                   const Icon(Icons.keybord_rrow_down_rounded,color: Colors.white,),
              //                 ],
              //               ),
              //             ),
              //           ),
              //           childrenBody:Continer(
              //             pdding: const EdgeInsets.fromLTRB(33, 0, 0, 0),
              //             lignment: lignment.centerLeft,
              //             child: Column(
              //               crossxislignment: Crossxislignment.strt,
              //               minxislignment: Minxislignment.center,
              //               children: [
              //                 const SizedBox(height: 10),
              //                 InkWell(
              //                   onTp: () {
              //                     neverBus.emit("checkLnguge","zh");
              //                     // print("object");
              //                     // setStte(() {
              //                     //   S.lod(const Locle("zh", "ZH"));
              //                     // });
              //                   },
              //                   child: const Text("中文", style: TextStyle(color: Colors.white,),),
              //                 ),
              //                 const SizedBox(height: 20),
              //                 InkWell(
              //                   onTp: () {
              //                     neverBus.emit("checkLnguge","en");
              //                     // setStte(() {
              //                     //   S.lod(const Locle('en', 'US'));
              //                     // });
              //                   },
              //                   child: const Text('English', style: TextStyle(color: Colors.white,),),
              //                 ),
              //                 const SizedBox(height: 20),
              //               ],
              //             ),
              //           )
              //       ),
              //       const SizedBox(height: 28),
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
