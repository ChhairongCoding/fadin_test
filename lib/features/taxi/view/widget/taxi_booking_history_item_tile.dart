import 'package:fardinexpress/features/taxi/model/taxi_history_model.dart';
import 'package:fardinexpress/features/taxi/view/taxi_history_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TaxiBookingHistoryItemTile extends StatelessWidget {
  final TaxiHistoryModel taxiHistoryModel;
  const TaxiBookingHistoryItemTile({Key? key, required this.taxiHistoryModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(() => TaxiHistoryDetailPage(
            taxiHistoryModel: this.taxiHistoryModel,
            status: taxiHistoryModel.status,
          )),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10.0)),
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        padding: EdgeInsets.all(10.0),
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "orderId".tr + ": ",
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "total".tr + ": ",
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "date".tr + ": ",
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "status".tr + ": ",
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    // SizedBox(
                    //   height: 5,
                    // ),
                    // Text(
                    //   "Address: ",
                    //   style: TextStyle(color: Colors.grey[600]),
                    // ),
                  ],
                ),
              ),
              Expanded(
                flex: 7,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("#${taxiHistoryModel.id.toString()}",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold)),
                    SizedBox(
                      height: 5,
                    ),
                    Text(taxiHistoryModel.total.toString(),
                        style: TextStyle(color: Colors.red[300])),
                    SizedBox(
                      height: 5,
                    ),
                    Text(taxiHistoryModel.date.toString(),
                        style: TextStyle(color: Colors.black)),
                    SizedBox(
                      height: 5,
                    ),
                    Text(taxiHistoryModel.status.toString(),
                        style: TextStyle(color: Colors.black)),
                    // SizedBox(
                    //   height: 5,
                    // ),
                    // Flexible(
                    //   child: Text(
                    //     taxiHistoryModel.senderAddress.toString(),
                    //     style: TextStyle(color: Colors.black),
                    //     maxLines: 2,
                    //     overflow: TextOverflow.clip,
                    //   ),
                    // ),
                  ],
                ),
              ),
            ],
          ),

          // Column(
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: [
          //     Row(
          //       children: [
          //         Text(
          //           "Order Id: ",
          //           style: TextStyle(color: Colors.grey[600]),
          //         ),
          //         Text("#${deliveryHistoryModel.id.toString()}",
          //             style: TextStyle(
          //                 color: Colors.black, fontWeight: FontWeight.bold)),
          //       ],
          //     ),
          //     SizedBox(
          //       height: 5,
          //     ),
          //     Row(
          //       children: [
          //         Text(
          //           "Total: ",
          //           style: TextStyle(color: Colors.grey[600]),
          //         ),
          //         Text(deliveryHistoryModel.total.toString(),
          //             style: TextStyle(color: Colors.red[300])),
          //       ],
          //     ),
          //     SizedBox(
          //       height: 5,
          //     ),
          //     Row(
          //       children: [
          //         Text(
          //           "Date: ",
          //           style: TextStyle(color: Colors.grey[600]),
          //         ),
          //         Text(deliveryHistoryModel.date.toString(),
          //             style: TextStyle(color: Colors.black)),
          //       ],
          //     ),
          //     SizedBox(
          //       height: 5,
          //     ),
          //     Row(
          //       children: [
          //         Text(
          //           "Address: ",
          //           style: TextStyle(color: Colors.grey[600]),
          //         ),
          //         Flexible(
          //           child: Text(
          //             deliveryHistoryModel.senderAddress.toString(),
          //             style: TextStyle(color: Colors.black),
          //             maxLines: 2,
          //             overflow: TextOverflow.clip,
          //           ),
          //         ),
          //       ],
          //     ),
          //     SizedBox(
          //       height: 5,
          //     ),
          //     Row(
          //       children: [
          //         Text(
          //           "Status: ",
          //           style: TextStyle(color: Colors.grey[600]),
          //         ),
          //         Text(deliveryHistoryModel.status.toString(),
          //             style: TextStyle(color: Colors.black)),
          //       ],
          //     ),
          //   ],
          // ),
        ),
      ),
    );
  }
}
