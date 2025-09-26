import 'dart:async';

import 'package:fardinexpress/features/express/view/widget/taxi_tracking.dart';
import 'package:fardinexpress/features/taxi/controller/taxi_controller.dart';
import 'package:fardinexpress/features/taxi/view/widget/taxi_map_osm.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TaxiWrapperPage extends StatefulWidget {
  const TaxiWrapperPage({Key? key}) : super(key: key);

  @override
  State<TaxiWrapperPage> createState() => _TaxiWrapperPageState();
}

class _TaxiWrapperPageState extends State<TaxiWrapperPage> {
  final _controller = Get.find<TaxiController>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("delivery length: ${_controller.taxiHistoryList.length}");
    Get.find<TaxiController>().initTaxiRidding('taxi').then((value) {
      if (_controller.taxiHistoryList.isEmpty) {
        Timer(Duration(seconds: 2), () => Get.off(() => MapPickerScreen()));
      } else {
        if ((_controller.taxiRiddingList[0].status.toLowerCase() == "pending" &&
                _controller.taxiRiddingList[0].customerRating.toString() ==
                    "null") ||
            (_controller.taxiRiddingList[0].status.toLowerCase() ==
                    "completed" &&
                _controller.taxiRiddingList[0].customerRating.toString() ==
                    "null")) {
          print("Check status1: " +
              Get.find<TaxiController>().status.toLowerCase() +
              "-" +
              Get.find<TaxiController>().taxiRiddingList.length.toString());
          Timer(
              Duration(seconds: 2),
              () => Get.off(() => TrackingLocation(
                    status: 'pending',
                  )));
        } else {
          // print("check status2: " +
          //     Get.find<TaxiController>().status.toLowerCase());
          // Get.to(() => TaxiBookingPage());
          Timer(Duration(seconds: 2), () => Get.off(() => MapPickerScreen()));
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Theme.of(context).primaryColor,
        // child: Image.asset("assets/img/splash_page/stand_banner.jpg"),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(4.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: AspectRatio(
                    aspectRatio: 18 / 5,
                    child: Image.asset("assets/img/fardin-logo.png")),
              ),
              SizedBox(
                height: 10.0,
              ),
              Text("Loading...",
                  textScaler: TextScaler.linear(1.5),
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontFamily: "Roboto")),
              // SizedBox(
              //   height: 10.0,
              // ),
              // Text(
              //   "Fardin Express",
              //   textScaleFactor: 1.3,
              //   style: TextStyle(fontWeight: FontWeight.w600),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
