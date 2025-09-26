import 'package:fardinexpress/features/express/model/delivery_history_model.dart';
import 'package:fardinexpress/features/express/view/delivery_history_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeliveryItemTile extends StatelessWidget {
  final DeliveryHistoryModel deliveryHistoryModel;
  final String deliveryType;
  const DeliveryItemTile(
      {Key? key,
      required this.deliveryHistoryModel,
      required this.deliveryType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey[100], borderRadius: BorderRadius.circular(10.0)),
      margin: EdgeInsets.only(top: 10, left: 20, right: 20),
      // padding: EdgeInsets.all(10.0),
      child: TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Colors.grey[100], // Text color
            splashFactory: InkRipple.splashFactory, // Splash effect
            // overlayColor: MaterialStateProperty.resolveWith<Color?>(
            //   (Set<MaterialState> states) {
            //     if (states.contains(MaterialState.pressed)) {
            //       return Colors.green.withOpacity(0.3); // Splash color
            //     }
            //     return null; // Default
            //   },
            // ),
          ),
          // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          // color: Colors.grey[100],
          // padding: EdgeInsets.all(15),
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${'orderId'.tr}:  ${deliveryHistoryModel.id.toString()}",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
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
                            "${'deliveryType'.tr}: ",
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "${'date'.tr}: ",
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "${'status'.tr}: ",
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "${'receiver'.tr}: ",
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "${'deliveryFee'.tr}: ",
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "${'packagePrice'.tr}: ",
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          // Text(
                          //   "${'total'.tr}: ",
                          //   style: TextStyle(color: Colors.grey[600]),
                          // ),
                          // SizedBox(
                          //   height: 5,
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
                          // Text("#${deliveryHistoryModel.id.toString()}",
                          //     style: TextStyle(
                          //         color: Colors.black,
                          //         fontWeight: FontWeight.bold,
                          //         fontSize: 18.0)),
                          // SizedBox(
                          //   height: 2,
                          // ),
                          Text(
                              "${deliveryHistoryModel.deliveryType == 'express' ? 'fastExpress' : deliveryHistoryModel.deliveryType == 'delivery' ? 'normalExpress' : deliveryHistoryModel.deliveryType == 'province' ? 'provinceExpress' : 'cargoExpress'}"
                                  .tr
                                  .toUpperCase(),
                              maxLines: 1,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                          SizedBox(
                            height: 5,
                          ),
                          Text(deliveryHistoryModel.date.toString(),
                              maxLines: 1,
                              style: TextStyle(color: Colors.black)),
                          SizedBox(
                            height: 5,
                          ),
                          Text(deliveryHistoryModel.status.toString(),
                              maxLines: 1,
                              style: TextStyle(color: Colors.black)),
                          SizedBox(
                            height: 5,
                          ),
                          Flexible(
                            child: Text(
                              "${deliveryHistoryModel.receiverPhone.toString()}, ${deliveryHistoryModel.receiverAddress.toString()}",
                              style: TextStyle(
                                  color: Colors.black, fontSize: 13.0),
                              maxLines: 1,
                              overflow: TextOverflow.clip,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                              "${deliveryHistoryModel.currency} ${deliveryHistoryModel.deliveryFee.toString()}",
                              maxLines: 1,
                              style: TextStyle(color: Colors.red[300])),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                              "${deliveryHistoryModel.currency} ${deliveryHistoryModel.total.toString()}",
                              maxLines: 1,
                              style: TextStyle(color: Colors.red[300])),
                          SizedBox(
                            height: 5,
                          ),
                          // Text(deliveryHistoryModel.grandTotal.toString(),
                          //     style: TextStyle(color: Colors.red[300])),
                          // SizedBox(
                          //   height: 5,
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${'total'.tr}:  ${deliveryHistoryModel.currency} ${deliveryHistoryModel.grandTotal.toString()}",
                      style: TextStyle(
                          color: Colors.green[300],
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold),
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          side: BorderSide(color: Colors.green),
                          elevation: 0,
                          backgroundColor: Colors.green,
                          // Colors.grey[100],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0)),
                        ),
                        onPressed: () => Get.to(() => DeliveryHistoryDetailPage(
                              deliveryHistoryModel: deliveryHistoryModel,
                              deliveryType: deliveryType,
                            )),
                        child: Text(
                          "orderDetails".tr,
                          style: TextStyle(color: Colors.white),
                        ))
                  ],
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
          onPressed: () {}
          // => Get.to(() => DeliveryHistoryDetailPage(
          //       deliveryHistoryModel: deliveryHistoryModel,
          //       deliveryType: deliveryType,
          //     )),
          ),
    );
  }
}
