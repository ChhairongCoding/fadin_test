import 'package:fardinexpress/features/app/extend_app_logistic/feature/blog/screens/info_page.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/feature/delivery/screens/delivery_by_completed_page.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/feature/delivery/screens/delivery_by_international_page.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/feature/delivery/screens/delivery_by_local_pagel.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/feature/price_estimation/screens/price_estimation_page.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/feature/warehouse_address/screens/warehouse_address_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Service extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<Map> row1 = [
      {
        Function: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (c) => DeliveryByInternationalPage()));
        },
        // ImageIcon: ImageIcon(
        //   AssetImage("assets/icons/features/warehouse.png"),
        //   // color: Colors.white,
        //   size: 28,
        // ),
        ImageIcon: Image(
          image: AssetImage("assets/img/history.png"),
          fit: BoxFit.cover,
          width: MediaQuery.of(context).size.width / 10,
          height: 40.0,
        ),
        String: "waiting".tr
        // AppLocalizations.of(context)!.translate("foreignWarehouse")
      },
      {
        Function: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (c) => DeliveryByLocalPage()));
        },
        // ImageIcon: ImageIcon(
        //   AssetImage("assets/icons/features/warehouse.png"),
        //   // color: Colors.white,
        //   size: 28,
        // ),
        ImageIcon: Image(
          image: AssetImage("assets/img/local-warehouse.png"),
          fit: BoxFit.cover,
          width: MediaQuery.of(context).size.width / 10,
          height: 40.0,
        ),
        String: "arrived".tr
        // AppLocalizations.of(context)!.translate("foreignWarehouse")
      },
      {
        Function: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (c) => DeliveryByCompletedPage()));
        },
        // ImageIcon: ImageIcon(
        //   AssetImage("assets/icons/features/delivery.png"),
        //   // color: Colors.white,
        //   // size: 30,
        // ),
        ImageIcon: Image(
          image: AssetImage("assets/img/delivered.png"),
          fit: BoxFit.cover,
          width: MediaQuery.of(context).size.width / 10,
          height: 40.0,
        ),
        String: "delivered".tr,
        // AppLocalizations.of(context)!.translate("delivered")
      },
    ];
    final List<Map> row2 = [
      {
        Function: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (c) => WarehouseAddressPage()));
        },
        // ImageIcon: ImageIcon(
        //   AssetImage("assets/icons/features/address.png"),
        //   // color: Colors.white,
        //   size: 28,
        // ),
        ImageIcon: Image(
          image: AssetImage("assets/img/features/warehouse.png"),
          fit: BoxFit.cover,
          width: MediaQuery.of(context).size.width / 10,
          height: 40.0,
        ),
        String: "warehouseAddress".tr
        // AppLocalizations.of(context)!.translate("warehouseAddress")
      },
      {
        Function: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (c) => PriceEstimationPage()));
        },
        // ImageIcon: ImageIcon(
        //   AssetImage("assets/icons/features/calculator.png"),
        //   color: Colors.,
        //   size: 28,
        // ),
        ImageIcon: Image(
          image: AssetImage("assets/img/features/calculator.png"),
          fit: BoxFit.cover,
          width: MediaQuery.of(context).size.width / 10,
          height: 40.0,
        ),
        String: "priceEstimate".tr
        // AppLocalizations.of(context)!.translate("priceEstimation")
      },
      {
        Function: () {
          // Get.to(() => DeliveryLocalPage(
          //       title: 'បញ្ញើរ',
          //       transportType: "delivery",
          //     ));
        },
        ImageIcon: Container(),
        // Image(
        //   image: AssetImage(""),
        //   fit: BoxFit.cover,
        //   // width: MediaQuery.of(context).size.width / 10,
        //   height: 00.0,
        // ),
        String: ""
      },
      // {
      //   Function: () {
      //     Navigator.push(
      //         context, MaterialPageRoute(builder: (c) => InfoPageWrapper()));
      //   },
      //   // ImageIcon: ImageIcon(
      //   //   AssetImage("assets/icons/features/tutorial.png"),
      //   //   // color: Colors.white,
      //   //   size: 30,
      //   // ),
      //   ImageIcon: Image(
      //     image: AssetImage("assets/img/features/tutorial.png"),
      //     fit: BoxFit.cover,
      //     width: MediaQuery.of(context).size.width / 10,
      //     height: 40.0,
      //   ),
      //   String: "information".tr
      //   // AppLocalizations.of(context)!.translate("info")
      // },
    ];

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text(
          //   "ourServices",
          //   // AppLocalizations.of(context)!.translate("ourServices")!,
          //   style: TextStyle(
          //     fontWeight: FontWeight.bold,
          //   ),
          //   textScaleFactor: 1.5,
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
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ...row2.map((data) => Expanded(child: _tile(context, data))),
              ],
            ),
          )
        ],
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
