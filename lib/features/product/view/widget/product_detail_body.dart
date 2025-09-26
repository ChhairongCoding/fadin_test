import 'dart:convert';

import 'package:fardinexpress/features/product/model/product_res_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ProductDetailBody extends StatelessWidget {
  final String productId;
  final String price;
  final String name;
  final String description;
  final String promotionPrice;
  final String descriptionDetail;
  final String storeId;
  final String countryCode;
  final ProductModelRes productModelRes;
  ProductDetailBody(
      {required this.productId,
      required this.name,
      required this.price,
      required this.description,
      required this.promotionPrice,
      required this.descriptionDetail,
      required this.storeId,
      required this.countryCode,
      required this.productModelRes});
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 5,
                ),

                SizedBox(
                  height: 10,
                ),
                // SizedBox(
                //   height: 10,
                // ),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 7,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Text(
                              "${this.productModelRes.name}",
                              style: TextStyle(
                                  color: Colors.black, letterSpacing: 0),
                              // textScaleFactor: 1.3,
                              textScaler: TextScaler.linear(1.3),
                              maxLines: 4,
                            ),
                          ),
                          Text(
                            "\$ ${this.price}",
                            style: TextStyle(
                                color: Colors.red[300],
                                fontWeight: FontWeight.bold),
                            // textScaleFactor: 1.6,
                            textScaler: TextScaler.linear(1.6),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Container(
                        child: QrImageView(
                          // dataModuleStyle: QrDataModuleStyle(
                          //   color: Colors.grey[800],
                          //   dataModuleShape: QrDataModuleShape.square,
                          // ),
                          // eyeStyle: QrEyeStyle(color: Colors.blue),
                          data: jsonEncode({
                            "store_id": "${storeId}",
                            // "item_id": "${productModelRes.id}",
                            "item_id": "${productId}",
                            "countryCode": "${countryCode}"
                          }),
                          version: QrVersions.auto,
                          size: 100.0,
                          gapless: false,
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                // Divider(
                //   thickness: 1,
                // ),
                // _itemReview(context),
                SizedBox(height: 5),
              ],
            ),
          ),
          // Column(
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: [
          //     Container(
          //       margin: EdgeInsets.symmetric(horizontal: 15),
          //       child: Column(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           Divider(
          //             thickness: 1,
          //           ),
          //           Text(
          //             "description".tr,
          //             textScaleFactor: 1.3,
          //             style: TextStyle(fontWeight: FontWeight.bold),
          //           ),
          //         ],
          //       ),
          //     ),
          //     SizedBox(height: 10),
          //     Container(
          //         padding: EdgeInsets.symmetric(horizontal: 10),
          //         child: HtmlWidget(
          //           this.productModelRes.description!.contains('"//img')
          //               ? """${this.productModelRes.description!.replaceAll("//img", "http://img")}"""
          //               : this.productModelRes.description!,
          //           renderMode: RenderMode.column,
          //         )
          //         // Text(this.description)
          //         // Html(data: """<p>${this.description}</p>"""),
          //         ),
          //   ],
          // ),
          SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }
}
