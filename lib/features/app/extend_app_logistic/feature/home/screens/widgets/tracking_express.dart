import 'package:fardinexpress/features/app/extend_app_logistic/feature/search/screens/search_page.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/feature/search/screens/tracking_delivery_order.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/utils/constants/app_constant.dart';
import 'package:fardinexpress/features/express/controller/express_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TrackingExpress extends StatelessWidget {
  ExpressController _expressController =
      Get.put(ExpressController(), tag: "filter");
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text(
        //   AppLocalizations.of(context)!.translate("track")!,
        //   style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        //   textScaleFactor: 1.5,
        // ),
        // SizedBox(height: 15),
        Container(
          height: 50,
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      showSearch(context: context, delegate: TrackingDeliveryOrder());
                    },
                    style: TextButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Colors.grey[200],
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(searchBarBorderRadius)),
                        padding: EdgeInsets.symmetric(horizontal: 15)),
                    // width: double.infinity,
                    // decoration: BoxDecoration(
                    //     color: Colors.grey[200],
                    //     borderRadius: BorderRadius.circular(18)),
                    // padding: EdgeInsets.symmetric(horizontal: 15),
                    // height: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.search_outlined),
                            SizedBox(width: 10),
                            Text(
                              "trackNum".tr,
                              // AppLocalizations.of(context)!
                              //     .translate("trackingNumber")!,
                              style: TextStyle(color: Colors.grey[700]),
                              textScaleFactor: 1,
                            ),
                          ],
                        ),
                        Container(
                            // margin: EdgeInsets.only(right: 5),
                            padding: EdgeInsets.all(6.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              color: Colors.green,
                            ),
                            child: Icon(
                              Icons.qr_code_scanner_sharp,
                              size: 25,
                              color: Colors.white,
                            ))
                      ],
                    ),
                  ),
                ),
              ),
              // SizedBox(width: 15),
              // AspectRatio(
              //   aspectRatio: 1,
              //   child: TextButton(
              //       onPressed: () {},
              //       style: TextButton.styleFrom(
              //           elevation: 0,
              //           backgroundColor: Colors.grey[200],
              //           shape: RoundedRectangleBorder(
              //               borderRadius: BorderRadius.circular(18)),
              //           padding: EdgeInsets.symmetric(horizontal: 15)),
              //       child: Icon(
              //         Icons.qr_code_outlined,
              //         color: Theme.of(context).primaryColor,
              //       )),
              // )
            ],
          ),
        )
      ],
    );
  }
}
