import 'package:fardinexpress/features/my_order/controller/my_order_repository.dart';
import 'package:fardinexpress/features/my_order/model/order_detail_model.dart';
import 'package:fardinexpress/features/my_order/model/order_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyOrderController extends GetxController {
  var isLoading = false.obs;
  var isDataProcessing = false.obs;
  var isMoreDataAvailable = true.obs;
  List<OrderModel> orderList = <OrderModel>[].obs;
  OrderDetailModel? orderDetailModel;
  // var productList = List<ProductModel>.empty(growable: true).obs;
  // <ProductModel>[].obs;
  MyOrderRepository _orderRepository = MyOrderRepository();
  ScrollController scrollController = ScrollController();
  // final String? categoryId;
  int page = 1;
  int rowPerPage = 12;

  // common snack bar
  showSnackBar(String title, String message, Color backgroundColor) {
    Get.snackbar(title, message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: backgroundColor,
        colorText: Colors.white);
  }

  initMyOrderList(String status) async {
    try {
      isMoreDataAvailable(false);
      isDataProcessing(true);
      await _orderRepository
          .fetchMyOrderList(page: page, rowPerPage: rowPerPage, status: status)
          .then((resp) {
        isDataProcessing(false);
        orderList.addAll(resp);
      }, onError: (err) {
        isDataProcessing(false);
        showSnackBar("Error", err.toString(), Colors.red);
      });
    } catch (e) {
      isDataProcessing(false);
      showSnackBar("Exception", e.toString(), Colors.red);
    }
  }

  paginateMyOrderList(String status) {
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        print("reached end");
        page++;
        getMoreMyOrderList(page, status);
      }
    });
  }

  getMoreMyOrderList(var page, String status) async {
    try {
      await _orderRepository
          .fetchMyOrderList(page: page, rowPerPage: rowPerPage, status: status)
          .then((resp) {
        if (resp.length > rowPerPage) {
          isMoreDataAvailable(true);
        } else {
          isMoreDataAvailable(false);
          // showSnackBar("Message", "No more items", Colors.lightBlueAccent);
        }
        orderList.addAll(resp);
      }, onError: (err) {
        isMoreDataAvailable(false);
        showSnackBar("Error", err.toString(), Colors.red);
      });
    } catch (e) {
      isMoreDataAvailable(false);
      showSnackBar("Exception", e.toString(), Colors.red);
    }
  }

  initMyOrderDetail(String orderId) async {
    try {
      isLoading(true);
      await _orderRepository.fetchMyOrderDetail(orderId: orderId).then((resp) {
        orderDetailModel = resp;
      }, onError: (err) {
        showSnackBar("Error", err.toString(), Colors.red);
      });
      isLoading(false);
    } catch (e) {
      isLoading(false);
      showSnackBar("Exception", e.toString(), Colors.red);
    }
  }
}
