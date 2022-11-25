import 'package:coinstart_wallet_extension/Base/Global.dart';
import 'package:coinstart_wallet_extension/base/MyBotTextToast.dart';
import 'package:coinstart_wallet_extension/base/image_helper.dart';
import 'package:coinstart_wallet_extension/generated/l10n.dart';
import 'package:common_utils/common_utils.dart';
import 'package:date_format/date_format.dart' as date_format;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:coinstart_wallet_extension/api/sui_api.dart';
import 'package:neveruseless/never/neverDoubleTryOrZero.dart';
import '../../main.dart';
class RecordPage extends StatefulWidget {
  final Map? arguments;
  const RecordPage({Key? key, this.arguments}) : super(key: key);

  @override
  createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> with SingleTickerProviderStateMixin {

  String coin = "";

  final List tabs = ["Overview","Send", "Record"];
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    PagePick.nowPageName = '/RecordPage';

    coin = widget.arguments!["coin"];

    // suiWallet.getTxDigestForCurrentwallet();
    // final transactions = suiWallet.transactions;
    // print(transactions);
    // SuiTansaction suiTansaction = transactions[0];
    // final amount = suiTansaction.isSender
    //     ? "-${suiTansaction.amount}"
    //     : "+${suiTansaction.amount}";
    // final address = suiTansaction.isSender
    //     ? addressFuzzy(suiTansaction.recipient)
    //     : addressFuzzy(suiTansaction.from);
    //
    // const network = 'SUI';
    // final status = suiTansaction.status;
    // final dt = DateTime.fromMillisecondsSinceEpoch(suiTansaction.timestampMs);
    // final d24 = DateFormat('yyyy-MM-dd HH:mm:ss').format(dt);
    _getTxDigestForCurrentwallet();


    _tabController = TabController(length: tabs.length, vsync: this)..addListener(() {
      if(_tabController!.index.toDouble() == _tabController!.animation!.value){
      }
    });

  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  List<SuiTansaction>? suiTansactionList = [];

  void _getTxDigestForCurrentwallet() async{
    await suiWallet.getTxDigestForCurrentwallet();
    final transactions = suiWallet.transactions;
    // print(transactions.toString());
    try{
      if(transactions.isNotEmpty){
        suiTansactionList = transactions.value as List<SuiTansaction>?;
      }else{
        suiTansactionList = [];
      }
    }catch(e){
      suiTansactionList = [];
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      right: true,
      bottom: false,
      left: true,
      top: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text(coin),
        ),
        body:Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
              alignment: Alignment.center,
              child: ImageHelper('/icons/crypto/$coin.png', width: 65, height: 65,),
            ),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 5),
              child: Text(
                  (NumUtil.getNumByValueDouble(neverDoubleTryOrZero(suiWallet.suiBalance.toString()) / 1000000000, 9)).toString(),
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w700),
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: Text("\$${NumUtil.getNumByValueDouble(neverDoubleTryOrZero(suiWallet.suiBalance.toString()) / 1000000000, 9)}",
                style: const TextStyle(color: Colors.grey, fontSize: 15,),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
              alignment: Alignment.centerLeft,
              child: TabBar(
                indicatorColor:APP_MainBgViewColor,
                indicatorSize:TabBarIndicatorSize.label,
                labelColor: APP_MainBgViewColor,
                labelStyle: const TextStyle(fontSize: 14,fontWeight: FontWeight.w600),
                unselectedLabelColor: Colors.grey,
                // isScrollable: true,
                controller: _tabController,
                tabs: tabs.map((e) => Tab(text: e)).toList(),
              ),
            ),
            Expanded(
              child: TabBarView( //构建
                controller: _tabController,
                children: tabs.map((e) {
                  if(e == "Overview"){
                    return ListView(
                      padding: const EdgeInsets.fromLTRB(15, 20, 15, 10),
                      children: [
                        Container(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                          alignment: Alignment.centerLeft,
                          child: const Text("Token info",style: TextStyle(fontSize: 13,color: Colors.white),),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                                  alignment: Alignment.centerLeft,
                                  child: Text(S.current.Token_name,style: const TextStyle(fontSize: 13,color: APP_MainGrayColor),),
                                ),
                                Container(
                                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                                  alignment: Alignment.centerLeft,
                                  child: Text(S.current.Project_name,style: const TextStyle(fontSize: 13,color: APP_MainGrayColor),),
                                ),
                                Container(
                                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                                  alignment: Alignment.centerLeft,
                                  child: Text(S.current.Total_circulation,style: const TextStyle(fontSize: 13,color: APP_MainGrayColor),),
                                ),
                              ],
                            ),
                            const SizedBox(width: 30,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                                  alignment: Alignment.centerLeft,
                                  child: const Text("SUI",style: TextStyle(fontSize: 13,color: APP_MainGrayColor),),
                                ),
                                Container(
                                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                                  alignment: Alignment.centerLeft,
                                  child: const Text("SUI blockchain",style: TextStyle(fontSize: 13,color: APP_MainGrayColor),),
                                ),
                                Container(
                                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                                  alignment: Alignment.centerLeft,
                                  child: const Text("105 Million",style: TextStyle(fontSize: 13,color: APP_MainGrayColor),),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 20,),
                        const Divider(height: 1,color: APP_MainGrayColor,),
                        const SizedBox(height: 10,),
                        Container(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                          alignment: Alignment.centerLeft,
                          child: const Text("Sui, a next-generation smart contract platform with high throughput, low latency, and an asset-oriented programming model powered by the Move programming language",style: TextStyle(fontSize: 13,color: Colors.grey),),
                        ),
                      ],
                    );
                  }else if(e == "Record" || e == "Send"){
                    return ListView.builder(
                      itemCount: suiTansactionList!.length,
                      itemBuilder: (context,index){
                        return GestureDetector(
                          onTap: (){
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
                                  height: 400,
                                  alignment: Alignment.centerLeft,
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(S.current.Transaction_details, style: const TextStyle(color: Colors.white,fontSize: 13),),
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
                                        padding: const EdgeInsets.fromLTRB(20, 20, 10, 10),
                                        child: Text(S.current.Amount, style: const TextStyle(color: Colors.grey,fontSize: 13),),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
                                        child: Text("${ !suiTansactionList![index].kind.contains("Pay")? suiTansactionList![index].kind:((suiTansactionList![index].isSender ? "-" : "+")
                                            + (NumUtil.getNumByValueDouble(neverDoubleTryOrZero(suiTansactionList![index].amount.toString()) / 1000000000, 9)).toString())} $coin", style: const TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.w600),),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            suiTansactionList![index].status == "success" ? const ImageHelper("/images/create_account_success.png",height: 15,)
                                            : const ImageHelper("/images/fall_icon.png",height: 15,),
                                            const SizedBox(width: 5,),
                                            Text(suiTansactionList![index].status == "success" ? S.current.Success : S.current.Fail, style: const TextStyle(color: Colors.grey,fontSize: 13),),
                                          ],
                                        )
                                      ),
                                      const SizedBox(height: 20,),
                                      const Divider(height: 2,color: APP_MainGrayColor,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.fromLTRB(15, 20, 20, 10),
                                            alignment: Alignment.centerLeft,
                                            child: Text(S.current.Select_transfer_network,style: const TextStyle(fontSize: 13,color: APP_MainGrayColor),),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.fromLTRB(15, 20, 20, 10),
                                            alignment: Alignment.centerRight,
                                            child: Text(coin,style: const TextStyle(fontSize: 13,color: Colors.white),),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.fromLTRB(15, 0, 50, 10),
                                            alignment: Alignment.centerLeft,
                                            child: Text(S.current.Address,style: const TextStyle(fontSize: 13,color: APP_MainGrayColor),),
                                          ),
                                          Expanded(
                                            child: GestureDetector(
                                              onTap: (){
                                                Clipboard.setData(ClipboardData(text: suiTansactionList![index].from));
                                                showMyCustomCopyText(S.current.Copy_successfully);
                                              },
                                              child: Container(
                                                padding: const EdgeInsets.fromLTRB(15, 0, 20, 10),
                                                alignment: Alignment.centerRight,
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(suiTansactionList![index].from,style: const TextStyle(fontSize: 13,color: Colors.white),textAlign: TextAlign.end,),
                                                    ),
                                                    const SizedBox(width: 5,),
                                                    const ImageHelper("/images/copy.png",width: 10,height: 10,),
                                                  ],
                                                )
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.fromLTRB(15, 0, 20, 10),
                                            alignment: Alignment.centerLeft,
                                            child: Text(S.current.Date,style: const TextStyle(fontSize: 13,color: APP_MainGrayColor),),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.fromLTRB(15, 0, 20, 10),
                                            alignment: Alignment.centerRight,
                                            child: Text(date_format.formatDate(DateTime.fromMillisecondsSinceEpoch(suiTansactionList![index].timestampMs),
                                [date_format.yyyy ,'-', date_format.mm, '-', date_format.dd, ' ',date_format.HH, ':', date_format.nn, ':', date_format.ss]),style: const TextStyle(fontSize: 13,color: Colors.white),),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )
                                );
                              },
                            );
                          },
                          behavior: HitTestBehavior.opaque,
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: const Text("SUI",style: TextStyle(fontSize: 15,color: Colors.white,fontWeight: FontWeight.w600),),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                                      alignment: Alignment.centerLeft,
                                      child: Text(date_format.formatDate(DateTime.fromMillisecondsSinceEpoch(suiTansactionList![index].timestampMs),
                                          [date_format.yyyy ,'-', date_format.mm, '-', date_format.dd, ' ',date_format.HH, ':', date_format.nn, ':', date_format.ss]),
                                        style: const TextStyle(fontSize: 12,color: APP_MainGrayColor,fontWeight: FontWeight.w600),),
                                    )
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text(!suiTansactionList![index].kind.contains("Pay")? suiTansactionList![index].kind:((suiTansactionList![index].isSender ? "-" : "+")
                                          + (NumUtil.getNumByValueDouble(neverDoubleTryOrZero(suiTansactionList![index].amount.toString()) / 1000000000, 9)).toString()),style: const TextStyle(fontSize: 15,color: Colors.white,fontWeight: FontWeight.w600),),
                                    ),
                                    Container(
                                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                                        alignment: Alignment.centerLeft,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text("●",style: TextStyle(fontSize: 12,color: suiTansactionList![index].status == "success" ? Colors.green : Colors.red,fontWeight: FontWeight.w600),),
                                            Text(suiTansactionList![index].status == "success" ? S.current.Success : S.current.Fail,style: const TextStyle(fontSize: 12,color: APP_MainGrayColor,fontWeight: FontWeight.w600),),
                                          ],
                                        )
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }else{
                    return Container();
                  }
                }).toList(),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        // push(context, const ShareAddressPage());
                        Navigator.pushNamed(context, "/ReceiveQRPage",arguments: {
                          "coin" : coin,
                          // "allAdd" : suiWallet.currentWalletAddress.toString(),
                          // "lessAdd" : suiWallet.currentWalletAddressFuzzyed.toString()
                        });
                      },
                      child: Container(
                        width: 106,
                        height: 48,
                        decoration: BoxDecoration(
                          color: APP_MainBgViewColor,
                          borderRadius: BorderRadius.circular(23),
                        ),
                        child: Center(
                          child: Text(S.current.Receive, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, "/TokenTransferPage",arguments: {
                          "coin" : coin,
                        });
                      },
                      child: Container(
                        width: 106,
                        height: 48,
                        decoration: BoxDecoration(
                          color: APP_MainBgViewColor,
                          borderRadius: BorderRadius.circular(23),
                        ),
                        child: Center(
                          child:  Text('Send', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
