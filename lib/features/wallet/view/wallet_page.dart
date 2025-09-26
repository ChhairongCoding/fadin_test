import 'package:fardinexpress/features/wallet/view/topup_balance.dart';
import 'package:fardinexpress/features/wallet/view/wallet_transaction.dart';
import 'package:fardinexpress/features/wallet/view/withdrawal_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WalletPage extends StatelessWidget {
  final String title;
  const WalletPage({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map> row1 = [
      {
        Function: () {
          Get.to(() => WalletTranList(
                title: title,
              ));
        },
        ImageIcon: Image(
          image: AssetImage("assets/icon/wallet.png"),
          fit: BoxFit.cover,
          // width: MediaQuery.of(context).size.width / 10,
          height: 40.0,
        ),
        String: "wallet".tr
      },
      {
        Function: () {
          Get.to(() => TopupBalance(title: "Top Up"));
        },
        ImageIcon: Image(
          image: AssetImage("assets/icon/topup.png"),
          fit: BoxFit.cover,
          // width: MediaQuery.of(context).size.width / 10,
          height: 40.0,
        ),
        String: "topUp".tr
      },
    ];
    final List<Map> row2 = [
      {
        Function: () {
          Get.to(() => WithdrawFormPage(
                title: title,
              ));
        },
        ImageIcon: Image(
          image: AssetImage("assets/icon/withdraw.png"),
          fit: BoxFit.cover,
          // width: MediaQuery.of(context).size.width / 10,
          height: 40.0,
        ),
        String: "withdrawal".tr
      },
      {
        Function: () {
          // Get.to(() => WalletTranList(title: title,));
        },
        ImageIcon: Container(),
        String: ""
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.only(left: 20, right: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 15),
            IntrinsicHeight(
              child: Row(
                children: [
                  ...row1.map((data) => Expanded(child: _tile(context, data))),
                ],
              ),
            ),
            SizedBox(height: 15),
            IntrinsicHeight(
              child: Row(
                children: [
                  ...row2.map((data) => Expanded(child: _tile(context, data))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tile(BuildContext context, Map data) {
    return Container(
      margin: EdgeInsets.only(right: 15),
      child: TextButton(
          onPressed: () {
            data[Function]();
          },
          style: TextButton.styleFrom(
            elevation: 0,
            backgroundColor: (data[String] == "")
                ? Colors.transparent
                : Theme.of(context).primaryColor.withAlpha(30),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          ),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 3, vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                data[ImageIcon],
                SizedBox(
                  height: 8,
                ),
                Text(
                  data[String],
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black),
                  textScaleFactor: 0.9,
                )
              ],
            ),
          )),
    );
  }
}
