import 'package:fardinexpress/features/taxi/controller/taxi_repository.dart';
import 'package:fardinexpress/features/taxi/model/location_detail_model.dart';
import 'package:fardinexpress/features/taxi/model/taxi_history_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TaxiController extends GetxController {
  TaxiRepository _taxiRepository = TaxiRepository();
  var isLoading = false.obs;
  var rpMessage;
  var isDataProcessing = false.obs;
  var isMoreDataAvailable = true.obs;
  List<TaxiHistoryModel> taxiHistoryList = <TaxiHistoryModel>[].obs;
  List<TaxiHistoryModel> taxiRiddingList = <TaxiHistoryModel>[].obs;
    // List<LocationDetailModel> locationDetailList = <LocationDetailModel>[].obs;
  ScrollController scrollController = ScrollController();
  int page = 1;
  int rowPerPage = 6;
  String status = "";

  TaxiController() {
    initTaxiHistoryList("taxi");
    paginateTaxiHistoryList("taxi");
  }

  // @override
  // void onInit() {
  //   super.onInit();
  //   initTaxiHistoryList("taxi");
  //   paginateTaxiHistoryList("taxi");
  // }

  // common snack bar
  showSnackBar(String title, String message, Color bgColor) {
    Get.snackbar(title, message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: bgColor,
        colorText: Colors.white);
  }

  //  getLocationDetailList(String query) async {
  //   try {
  //     // if (isMoreDataAvailable() && deliveryHistoryList.isNotEmpty) {
  //     //   deliveryHistoryList.clear();
  //     // }
  //     // page = 1;
  //     isDataProcessing(true);

  //     final response = await _taxiRepository.fetchLocationDetailList(query: query);

  //     isDataProcessing(false);
  //     locationDetailList.addAll(response);
  //   } catch (error) {
  //     isDataProcessing(false);
  //     showSnackBar("Error", error.toString(), Colors.red);
  //   }
  // }


  initTaxiHistoryList(String transportType) async {
    try {
      if (isMoreDataAvailable(true) && taxiHistoryList.isNotEmpty) {
        taxiHistoryList.clear();
      }
      page = 1;
      isDataProcessing(true);
      await _taxiRepository
          .fetchTaxiHistoryList(
              page: page, rowPerPage: rowPerPage, transportType: transportType)
          .then((resp) {
        isDataProcessing(false);
        taxiHistoryList.addAll(resp);
        // resp.forEach((item) {
        //   if (item.status == "pending") {
        //     status = "pending";
        //   } else if (item.status == "completed") {
        //     status = "completed";
        //   } else {
        //     status = "";
        //   }
        // });
      }, onError: (err) {
        isDataProcessing(false);
        showSnackBar("Error", err.toString(), Colors.red);
      });
    } catch (e) {
      isDataProcessing(false);
      showSnackBar("Exception", e.toString(), Colors.red);
    }
  }

  paginateTaxiHistoryList(String showTransportType) {
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        print("reached end");
        page++;
        getMoreTaxiHistoryList(page, showTransportType);
      }
    });
  }

  getMoreTaxiHistoryList(var page, String transportType) async {
    try {
      await _taxiRepository
          .fetchTaxiHistoryList(
              page: page, rowPerPage: rowPerPage, transportType: transportType)
          .then((resp) {
        if (resp.length > rowPerPage) {
          isMoreDataAvailable(true);
        } else {
          isMoreDataAvailable(false);
          // showSnackBar("Message", "No more items", Colors.lightBlueAccent);
        }
        taxiHistoryList.addAll(resp);
      }, onError: (err) {
        isMoreDataAvailable(false);
        // showSnackBar("Error", err.toString(), Colors.red);
      });
    } catch (e) {
      isMoreDataAvailable(false);
      showSnackBar("Exception", e.toString(), Colors.red);
    }
  }

  initTaxiRidding(String transportType) async {
    try {
      if (taxiRiddingList.isNotEmpty) {
        taxiRiddingList.clear();
      }
      // page = 1;
      isLoading(true);
      await _taxiRepository
          .fetchTaxiRidding(
              page: page, rowPerPage: rowPerPage, transportType: transportType)
          .then((resp) {
        isDataProcessing(false);
        taxiRiddingList.addAll(resp);
        print("object : " + resp.length.toString());
        // resp.forEach((item) {
        //   if (item.status == "pending") {
        //     status = "pending";
        //   } else if (item.status == "completed") {
        //     status = "completed";
        //   } else {
        //     status = "";
        //   }
        // });
      }, onError: (err) {
        isLoading(false);
        // showSnackBar("Error", err.toString(), Colors.red);
      });
    } catch (e) {
      isLoading(false);
      showSnackBar("Exception", e.toString(), Colors.red);
    }
  }
}
