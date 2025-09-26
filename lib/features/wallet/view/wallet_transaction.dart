import 'package:fardinexpress/features/account/controller/account_controller.dart';
import 'package:fardinexpress/features/wallet/controller/wallet_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WalletTranList extends StatefulWidget {
  final String title;
  const WalletTranList({Key? key, required this.title}) : super(key: key);

  @override
  State<WalletTranList> createState() => _WalletTranListState();
}

class _WalletTranListState extends State<WalletTranList> {
  WalletController _walletController =
      Get.put(WalletController(), tag: "walletList");

  @override
  void initState() {
    // _expressController.initDeliveryList("Pending");
    // _expressController.paginateDeliveryList("Pending");
    _walletController.initWalletTran();
    _walletController.paginateWalletTran();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Obx(() {
        if (_walletController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        } else if (_walletController.walletTranList.isEmpty) {
          return Center(child: Text("No item found"));
        } else {
          return SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Wallet Balance",
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    "\$ ${Get.find<AccountController>().accountInfo.total}",
                    textScaleFactor: 2.3,
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      "Recent Transaction",
                      textScaleFactor: 1.2,
                      textAlign: TextAlign.left,
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: _walletController.walletTranList.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: (_walletController
                                      .walletTranList[index].tranStatus
                                      .toString() ==
                                  "approved")
                              ? Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.green,
                                  ),
                                  child: Icon(
                                    Icons.done_rounded,
                                    color: Colors.white,
                                  ),
                                )
                              : Icon(
                                  Icons.pending,
                                  color: Colors.orange[900],
                                ),
                          title: Text(
                              "${_walletController.walletTranList[index].tranType!} " +
                                  "#" +
                                  "${_walletController.walletTranList[index].referNo.toString()}"),
                          subtitle: Text(
                              "${_walletController.walletTranList[index].payMethod} " +
                                  "date :" +
                                  "${_walletController.walletTranList[index].requestDate}"),
                          trailing: Container(
                            // color: Colors.red,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "\$ ${_walletController.walletTranList[index].amount}",
                                  textScaleFactor: 1.2,
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  "${_walletController.walletTranList[index].tranStatus}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Theme.of(context).primaryColor),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                ],
              ),
            ),
          );
        }
      }),
    );
  }
}
