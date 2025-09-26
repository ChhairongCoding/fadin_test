import 'package:fardinexpress/features/app/extend_app_logistic/feature/home/screens/logistic_home_page.dart';
import 'package:fardinexpress/features/express/view/delivery_history_page.dart';
import 'package:fardinexpress/features/express/view/delivery_local.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExpressManuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<Map> row1 = [
      {
        Function: () {
          Get.to(() => DeliveryLocalPage(
                title: 'ដឹកក្នុងស្រុក',
                transportType: "express",
              ));
        },
        ImageIcon: Image(
          image: AssetImage("assets/img/scooter.png"),
          fit: BoxFit.cover,
          width: MediaQuery.of(context).size.width / 10,
          height: 40.0,
        ),
        String: "ដឹកក្នុងស្រុក"
      },
      {
        Function: () {
          Get.to(() => DeliveryLocalPage(
                title: 'ដឹកឆ្លងខេត្ត',
                transportType: "delivery",
              ));
        },
        ImageIcon: Image(
          image: AssetImage("assets/img/delivery-truck.png"),
          fit: BoxFit.cover,
          width: MediaQuery.of(context).size.width / 10,
          height: 40.0,
        ),
        String: "ដឹកឆ្លងខេត្ត"
      },
      {
        Function: () {
          Get.to(() => LogisticHomePage());
        },
        ImageIcon: Image(
          image: AssetImage("assets/img/transportation.png"),
          fit: BoxFit.cover,
          width: MediaQuery.of(context).size.width / 10,
          height: 40.0,
        ),
        String: "ដឹកឆ្លងប្រទេស"
      },
    ];
    final List<Map> row2 = [
      {
        Function: () {
          Get.to(() => DeliveryHistoryPage(
                initIndex: 0,
                transportType: 'express',
              ));
        },
        ImageIcon: Image(
          image: AssetImage("assets/img/history.png"),
          fit: BoxFit.cover,
          width: MediaQuery.of(context).size.width / 10,
          height: 40.0,
        ),
        String: "របាយការណ៍"
      },
      {
        Function: () {
          // Get.to(() => DeliveryHistoryPage(initIndex: 0));
        },
        ImageIcon: Container(),
        String: ""
      },
      {
        Function: () {
          // Get.to(() => DeliveryHistoryPage(initIndex: 0));
        },
        ImageIcon: Container(),
        String: ""
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text("Express"),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.only(left: 20, right: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IntrinsicHeight(
            //   child: Row(
            //     children: [
            //       ...row3.map((data) => Expanded(child: _tile(context, data))),
            //     ],
            //   ),
            // ),
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
