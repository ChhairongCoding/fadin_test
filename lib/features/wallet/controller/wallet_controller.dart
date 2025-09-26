import 'dart:io';

import 'package:fardinexpress/features/checkout/view/checkout_success.dart';
import 'package:fardinexpress/features/wallet/controller/wallet_repository.dart';
import 'package:fardinexpress/features/wallet/model/wallet_transaction_model.dart';
import 'package:fardinexpress/services/api_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class WalletController extends GetxController {
  WalletRepository _walletRepository = WalletRepository();
  ApiProvider apiProvider = ApiProvider();
  var isLoading = false.obs;
  var rpMessage;
  var isDataProcessing = false.obs;
  var isMoreDataAvailable = true.obs;
  List<WalletTransactionModel> walletTranList = <WalletTransactionModel>[].obs;
  ScrollController scrollController = ScrollController();
  int page = 1;
  int rowPerPage = 12;

  // common snack bar
  showSnackBar(String title, String message, Color bgColor) {
    Get.snackbar(title, message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: bgColor,
        colorText: Colors.white);
  }

  void toRequestTopup({
    required String note,
    required String paymentMethod,
    required String amount,
    required File image,
  }) async {
    try {
      isLoading(true);
      EasyLoading.show(status: 'loading...');
      var imageUrl = await apiProvider.uploadImage(image: image);
      await _walletRepository
          .topupBalance(
              note: note,
              paymentMethod: paymentMethod,
              amount: amount,
              image: imageUrl)
          .then((resp) {
        if (resp.toString() == "success") {
          isLoading(false);
          EasyLoading.dismiss();
          // showSnackBar("Checkout", "Success!", Colors.green);
          // Get.find<CartStoreController>().getCartStoreList();
          Get.off(SuccessfulScreen(successScreenType: SuccessScreenType.otherType,));
        } else {
          EasyLoading.dismiss();
          showSnackBar("Checkout", "Failed to send request", Colors.red);
        }
      }, onError: (err) {
        isLoading(false);
        EasyLoading.dismiss();
        showSnackBar("Alert", err.toString(), Colors.red);
      });
    } catch (e) {
      isLoading(false);
      EasyLoading.dismiss();
      showSnackBar("Exception", e.toString(), Colors.red);
    }
  }

  void toWithdraw({
    required String amount,
  }) async {
    try {
      isLoading(true);
      EasyLoading.show(status: 'loading...');
      await _walletRepository.withdrawal(amount: amount).then((resp) {
        if (resp.toString() == "success") {
          isLoading(false);
          EasyLoading.dismiss();
          // showSnackBar("Checkout", "Success!", Colors.green);
          // Get.find<CartStoreController>().getCartStoreList();
          Get.off(SuccessfulScreen(successScreenType: SuccessScreenType.otherType));
        } else {
          EasyLoading.dismiss();
          showSnackBar("Checkout", "Failed to send request", Colors.red);
        }
      }, onError: (err) {
        isLoading(false);
        EasyLoading.dismiss();
        showSnackBar("Alert", err.toString(), Colors.red);
      });
    } catch (e) {
      isLoading(false);
      EasyLoading.dismiss();
      showSnackBar("Exception", e.toString(), Colors.red);
    }
  }

  initWalletTran() async {
    try {
      if (isMoreDataAvailable(true) && walletTranList.isNotEmpty) {
        walletTranList.clear();
      }
      page = 1;
      isDataProcessing(true);
      await _walletRepository
          .getWalletTran(page: page, rowPerpage: rowPerPage)
          .then((resp) {
        isDataProcessing(false);
        walletTranList.addAll(resp);
      }, onError: (err) {
        isDataProcessing(false);
        showSnackBar("Error", err.toString(), Colors.red);
      });
    } catch (e) {
      isDataProcessing(false);
      showSnackBar("Exception", e.toString(), Colors.red);
    }
  }

  paginateWalletTran() {
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        print("reached end");
        page++;
        getMoreWalletTran(page);
      }
    });
  }

  getMoreWalletTran(var page) async {
    try {
      await _walletRepository
          .getWalletTran(page: page, rowPerpage: rowPerPage)
          .then((resp) {
        if (resp.length > rowPerPage) {
          isMoreDataAvailable(true);
        } else {
          isMoreDataAvailable(false);
          // showSnackBar("Message", "No more items", Colors.lightBlueAccent);
        }
        walletTranList.addAll(resp);
      }, onError: (err) {
        isMoreDataAvailable(false);
        showSnackBar("Error", err.toString(), Colors.red);
      });
    } catch (e) {
      isMoreDataAvailable(false);
      showSnackBar("Exception", e.toString(), Colors.red);
    }
  }
}
