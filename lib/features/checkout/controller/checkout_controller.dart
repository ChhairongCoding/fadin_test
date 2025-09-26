import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dotted_border/dotted_border.dart';
import 'package:fardinexpress/features/cart/controller/cart_store_controller.dart';
import 'package:fardinexpress/features/cart/model/cart_store_model.dart';
import 'package:fardinexpress/features/checkout/controller/checkout_repository.dart';
import 'package:fardinexpress/features/checkout/view/checkout_success.dart';
import 'package:fardinexpress/features/product/model/product_res_model.dart';
import 'package:fardinexpress/services/api_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class CheckoutController extends GetxController {
  CheckoutRepository _checkoutRepository = CheckoutRepository();
  ApiProvider apiProvider = ApiProvider();
  var isLoading = false.obs;
  var rpMessage;
  late Timer timerKH = Timer(Duration(milliseconds: 0), () {});
  Uint8List decodedBytes = Uint8List(0);

  // common snack bar
  showSnackBar(String title, String message, Color bgColor) {
    Get.snackbar(title, message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: bgColor,
        colorText: Colors.white);
  }

  void checkPaymentStatus(
      {required List<CartStoreItem> cartStoreModel,
      required String type,
      required String grandTotal,
      required List<ProductModelRes> products,
      required String addressId,
      required String? paymentType,
      required String? paymentMethod,
      required String? countryId,
      required String? deliveryMode}) {
    timerKH = Timer.periodic(Duration(seconds: 5), (timer) {
      checkPaymentKhqrstatus(
          cartStoreModel: cartStoreModel,
          type: type,
          grandTotal: grandTotal,
          products: products,
          addressId: addressId,
          paymentType: paymentType,
          paymentMethod: paymentMethod,
          countryId: countryId,
          deliveryMode: deliveryMode);
    });
  }

  void toCheckout(
      List<CartStoreItem> cartStoreModel,
      String type,
      String grandTotal,
      List<ProductModelRes> products,
      String addressId,
      String? paymentType,
      String? paymentMethod,
      String? countryId,
      String? deliveryMode,
      File? image) async {
    try {
      String imageUrl = "";
      if (image != null) {
        imageUrl = await apiProvider.uploadImage(image: image);
      } else {
        imageUrl = "";
      }

      isLoading(true);
      EasyLoading.show(
          status: 'loading...',
          maskType: EasyLoadingMaskType.black,
          dismissOnTap: false);
      await _checkoutRepository
          .checkoutToServer(
              type: type,
              // grandTotal: grandTotal,
              grandTotal: grandTotal,
              cartStoreModel: cartStoreModel,
              productList: products,
              addressId: addressId,
              paymentType: paymentType,
              uploadImageUrl: imageUrl,
              paymentMethod: paymentMethod,
              countryId: countryId,
              deliveryMode: deliveryMode)
          .then((resp) {
        if (resp.toString() == "success") {
          isLoading(false);
          EasyLoading.dismiss();
          // showSnackBar("Checkout", "Success!", Colors.green);
          Get.find<CartStoreController>().getCartStoreList();
          Get.off(() =>
              SuccessfulScreen(successScreenType: SuccessScreenType.otherType));
        } else {
          EasyLoading.dismiss();
          showSnackBar("Checkout", "Failed to send request", Colors.red);
        }
      }, onError: (err) {
        isLoading(false);
        EasyLoading.dismiss();
        showSnackBar("Error", err.toString(), Colors.red);
      });
    } catch (e) {
      isLoading(false);
      EasyLoading.dismiss();
      showSnackBar("Exception", e.toString(), Colors.red);
    }
  }

  void generateKhqrCode(
      String paymentMethod,
      String amount,
      String type,
      var context,
      List<CartStoreItem> cartStoreModel,
      List<ProductModelRes> products,
      String addressId,
      String? paymentType,
      String? countryId,
      String? deliveryMode) async {
    try {
      isLoading(true);
      EasyLoading.show(status: 'loading...');
      await _checkoutRepository
          .reqGenerateKHQRCode(
              paymentMethod: paymentMethod, amount: amount, type: type)
          .then((resp) {
        // print("return resp : " + resp);
        if (resp.message.toString() == "success") {
          isLoading(false);
          EasyLoading.dismiss();
          showABAQRCodeDialog(
              context, amount, resp.qrCodeUrl.toString(), paymentMethod);
          checkPaymentStatus(
              cartStoreModel: cartStoreModel,
              type: type,
              grandTotal: amount,
              products: products,
              addressId: addressId,
              paymentType: paymentType,
              paymentMethod: paymentMethod,
              countryId: countryId,
              deliveryMode: deliveryMode);
        } else {
          EasyLoading.dismiss();
          showSnackBar("Checkout", "Failed to send request", Colors.red);
        }
      }, onError: (err) {
        isLoading(false);
        EasyLoading.dismiss();
        showSnackBar("Error", err.toString(), Colors.red);
      });
    } catch (e) {
      isLoading(false);
      EasyLoading.dismiss();
      print("exception: " + e.toString());
      showSnackBar("Exception", e.toString(), Colors.red);
    }
  }

  void checkPaymentKhqrstatus(
      {required List<CartStoreItem> cartStoreModel,
      required String type,
      required String grandTotal,
      required List<ProductModelRes> products,
      required String addressId,
      required String? paymentType,
      required String? paymentMethod,
      required String? countryId,
      required String? deliveryMode}) async {
    try {
      isLoading(true);
      // EasyLoading.show(status: 'loading...');
      await _checkoutRepository.checkPaymentStatusKhqr().then((resp) {
        // print("return resp : " + resp);
        if (resp == "paid") {
          isLoading(false);
          timerKH.cancel();
          Get.back();
          toCheckout(
            cartStoreModel,
            type,
            grandTotal,
            products,
            addressId,
            paymentType,
            paymentMethod,
            countryId,
            deliveryMode,
            null,
          );
          // print("return resp : " + resp);
          // showSnackBar("Checkout", "Success!", Colors.green);
        } else {
          isLoading(false);
          print("Checking KHQR...");
        }
      }, onError: (err) {
        isLoading(false);
        print("error: " + err.toString());
        // showSnackBar("Error", err.toString(), Colors.red);
      });
    } catch (e) {
      isLoading(false);
      print("exception: " + e.toString());
      // showSnackBar("Exception", e.toString(), Colors.red);
    }
  }

  void showABAQRCodeDialog(BuildContext context, String amount,
      String qrcodeUrl, String paymentMethod) {
    // String svgData = qrcodeUrl;
    // var decoded = "";
    // if (paymentMethod == "anakut") {
    //   String data = qrcodeUrl.split(',').last,
    //       decoded = utf8.decode(base64.decode(qrcodeUrl.split(',').last));
    // }
    // decodedBytes = base64.decode(data);
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: paymentMethod == "anakut"
              ? Colors.white
              // Color.fromARGB(255, 35, 35, 56)
              : Colors.transparent,
          // backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          contentPadding: EdgeInsets.zero,
          content: Container(
            width: 300,
            decoration: BoxDecoration(
                // color: const Color.fromARGB(255, 32, 46, 57),
                // color: Colors.black.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border(
                    bottom: BorderSide(
                  color: Colors.grey[800]!,
                  width: 1.0,
                  style: BorderStyle.values[1],
                ))),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Aligns text to left
              children: [
                // Header
                paymentMethod == "anakut"
                    ? Container(
                        padding: EdgeInsets.symmetric(vertical: 12.0),
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          // Colors.red,
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(20)),
                        ),
                        child: const Center(
                          child: Text(
                            'ANAKUT QR',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    : Container(),

                // User Info (Aligned Left)
                paymentMethod == "anakut"
                    ? Padding(
                        padding: EdgeInsets.only(
                            left: 50.0, top: 10.0, bottom: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Fardin Express", // Dynamic title
                              style: const TextStyle(
                                // color: Colors.amber,
                                fontSize: 16,
                                // fontWeight: FontWeight.bold
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              '\$${double.parse(amount.toString()).toStringAsFixed(2)}', // Dynamic amount
                              style: const TextStyle(
                                  // color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      )
                    : Container(),
                // QR Code (Centered)
                DottedBorder(
                    options: CustomPathDottedBorderOptions(
                      // padding: const EdgeInsets.all(8),
                      color: Colors.grey[800]!,
                      strokeWidth: 2,
                      dashPattern: [10, 5],
                      customPath: (size) => Path()
                        ..moveTo(0, size.height)
                        ..relativeLineTo(size.width, 0),
                    ),
                    child: Container(
                      width: Get.width,
                    )),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    padding: EdgeInsets.all(0),
                    child: paymentMethod == "anakut"
                        ? Container(
                            margin: EdgeInsets.symmetric(horizontal: 20.0),
                            padding: EdgeInsets.symmetric(
                                horizontal: 0.0, vertical: 0.0),
                            width: MediaQuery.of(context).size.width * 0.6,
                            // height: MediaQuery.of(context).size.width * 0.5,
                            child: Container(
                              padding: EdgeInsets.all(20),
                              // color: Colors.white,
                              child: SvgPicture.string(
                                utf8.decode(
                                    base64.decode(qrcodeUrl.split(',').last)),
                                fit: BoxFit.contain,
                              ),
                            ))
                        : Image.network(
                            "$qrcodeUrl", // Dynamic QR Code URL
                            width: MediaQuery.of(context).size.width * 0.8,
                            // height: 200,
                            fit: BoxFit.contain,
                          ),
                  ),
                ),

                // Close Button (Centered)
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: paymentMethod == "anakut"
                        ? Colors.amber
                        : Colors.transparent,
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(12)),
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: TextButton(
                      onPressed: () {
                        timerKH.cancel();
                        Navigator.pop(context);
                      },
                      child: Text('Close'.toUpperCase(),
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
