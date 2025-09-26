import 'dart:io';

import 'package:fardinexpress/features/cart/model/cart_store_model.dart';
import 'package:fardinexpress/features/checkout/controller/checkout_controller.dart';
import 'package:fardinexpress/features/payment/controller/paymet_control_index_controller.dart';
import 'package:fardinexpress/features/product/model/product_res_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class PaymentOptionList extends StatelessWidget {
  final List<CartStoreItem> cartStoreModel;
  final String grandTotal;
  final String type;
  final String addressId;
  final List<ProductModelRes> products;
  final String countryId;
  final String deliveryMode;
  PaymentOptionList(
      {Key? key,
      required this.cartStoreModel,
      required this.grandTotal,
      required this.type,
      required this.addressId,
      required this.products,
      required this.countryId,
      required this.deliveryMode})
      : super(key: key);
  final _controller = Get.find<PaymentControlIndexController>();
  final _checkoutController = Get.find<CheckoutController>();

  @override
  Widget build(BuildContext context) {
    List<Map> paymentMethodList = [
      // {
      //   "name": "ABA",
      //   "image": "assets/img/payment/aba-logo.png",
      //   "description": "010 601 168 | Sim Sophea"
      // },
      // {
      //   "name": "Aceleda",
      //   "image": "assets/img/payment/aceleda.png",
      //   "description": "010 601 168 | Sim Sophea"
      // },
      {
        "name": "transferNumber".tr,
        "image": "assets/img/payment/phone_transfer.jpg",
        "description": "010 601 168"
      }
    ];

    String initPaymentMethod = paymentMethodList[0]["name"];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("paymentOption".tr),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        //height: 500,
        child: SingleChildScrollView(
          child: Column(children: [
            ...paymentMethodList
                .map(
                  (data) => Column(
                    children: [
                      Obx(
                        () => ListTile(
                          onTap: (() {
                            // Update the selected payment method when tapped
                            _controller.selectBankTransferIndex(
                                paymentMethodList.indexOf(data));
                            initPaymentMethod = "${data["name"]}";
                          }),
                          leading: Image.asset(
                            "${data["image"]}",
                            width: 50.0,
                          ),
                          title: Text(
                            "${data["name"]}",
                            // _controller.isClick.toString(),
                            style: TextStyle(
                                // color: Colors.grey[700],
                                // fontWeight: FontWeight.bold
                                ),
                          ),
                          subtitle: Text(
                            "${data["description"]}",
                            style: TextStyle(
                              color: Colors.grey[700],
                              // fontWeight: FontWeight.bold
                            ),
                          ),
                          trailing: Icon(
                            _controller.selectedBank.value ==
                                    paymentMethodList.indexOf(data)
                                ? Icons.radio_button_checked
                                : Icons.radio_button_unchecked,
                            color: _controller.selectedBank.value ==
                                    paymentMethodList.indexOf(data)
                                ? Theme.of(context).primaryColor
                                : Colors.grey,
                          ),
                        ),
                      ),
                      // Divider(
                      //   // height: 8,
                      //   color: Colors.grey,
                      //   thickness: 0.3,
                      // ),
                    ],
                  ),
                )
                .toList(),
            Container(
              margin: EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(8.0))),
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("uploadTransactionPhoto".tr),
                  SizedBox(height: 10),
                  Divider(thickness: 0.5),
                  GestureDetector(
                    onTap: () {
                      _showPicker(context);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: MediaQuery.of(context).size.width / 3,
                      child: Obx(() {
                        // Display selected image or icon if none selected
                        return _controller.selectedImage.value == null
                            ? AspectRatio(
                                aspectRatio: 1,
                                child: FittedBox(
                                    fit: BoxFit.fitHeight,
                                    child: Icon(
                                      Icons.add_a_photo_outlined,
                                      color: Colors.grey[300],
                                    )),
                              )
                            : Image.file(
                                File(_controller.selectedImage.value!.path),
                                fit: BoxFit.cover,
                              );
                      }),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  onPressed: () {
                    if (_controller.selectedImage.value == null) {
                      Get.dialog(
                        AlertDialog(
                          title: Text("Alert !"),
                          content: Text(
                              "${'please'.tr} ${'uploadTransactionPhoto'.tr}"),
                        ),
                        barrierDismissible: true,
                      );
                      return;
                    } else {
                      _checkoutController.toCheckout(
                          cartStoreModel,
                          type,
                          grandTotal,
                          products,
                          addressId,
                          "transfer",
                          "${initPaymentMethod.toLowerCase()}",
                          countryId,
                          deliveryMode,
                          File(_controller.selectedImage.value!.path));
                    }
                  },
                  child: Text(
                    "Check out".toUpperCase(),
                    style: TextStyle(color: Colors.white),
                  )),
            )
          ]),
        ),
      ),
    );
  }

  void _showPicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: Icon(Icons.photo_library),
                    title: Text('Gallery'),
                    onTap: () {
                      _controller.pickImage(ImageSource.gallery);
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: Icon(Icons.photo_camera),
                  title: Text('Camera'),
                  onTap: () {
                    _controller.pickImage(ImageSource.camera);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }
}
