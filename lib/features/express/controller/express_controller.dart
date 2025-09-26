import 'dart:io';

import 'package:fardinexpress/features/checkout/view/checkout_success.dart';
import 'package:fardinexpress/features/express/controller/express_repository.dart';
import 'package:fardinexpress/features/express/model/currency_model.dart';
import 'package:fardinexpress/features/express/model/delivery_history_model.dart';
import 'package:fardinexpress/features/express/view/widget/taxi_tracking.dart';
import 'package:fardinexpress/features/taxi/controller/taxi_controller.dart';
import 'package:fardinexpress/features/taxi/model/location_detail_model.dart';
import 'package:fardinexpress/features/taxi/view/widget/taxi_map_osm.dart';
import 'package:fardinexpress/services/api_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';

class ExpressController extends GetxController {
  ExpressRepository _expressRepository = ExpressRepository();
  ApiProvider apiProvider = ApiProvider();
  var isLoading = false.obs;
  var rpMessage;
  var isDataProcessing = false.obs;
  var isMoreDataAvailable = true.obs;
  List<DeliveryHistoryModel> deliveryHistoryList = <DeliveryHistoryModel>[].obs;
  List<LocationDetailModel> locationDetailList = <LocationDetailModel>[].obs;
  RxList<LocationDetailModel> filteredLocationDetailList =
      <LocationDetailModel>[].obs;
  DeliveryHistoryModel? taxiBookingDetail;
  List<CurrencyModel> currencyList =
      <CurrencyModel>[].obs; // <CurrencyModel>[].obs>
  DeliveryHistoryModel? deliveryHistoryModel;
  ScrollController scrollController = ScrollController();
  TextEditingController searchController = TextEditingController();
  int page = 1;
  int rowPerPage = 12;
  RxBool isShowPicker = true.obs;
  RxString getDeliveryFee = "".obs;
  RxString getZoneFee = "".obs;
  RxString getProvinceFee = "".obs;
  RxString getAddress = "".obs;
  LatLongModel? latLongModel;

  // common snack bar
  showSnackBar(String title, String message, Color bgColor) {
    Get.snackbar(title, message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: bgColor,
        colorText: Colors.white);
  }

  Future<void> toCalculateDeliveryFee(
      {required String deliveryType,
      required String senderPhone,
      required String senderAddress,
      required String senderLat,
      required String senderLong,
      required String receiverLat,
      required String receiverLong,
      required String receiverPhone,
      required String receiverAddress,
      required String note,
      required String paymentNote,
      required String total,
      required String transportId,
      required String showTransportType,
      required String currencyId,
      required String deliveryFee}) async {
    try {
      isLoading(true);
      EasyLoading.show(status: 'loading...');
      await _expressRepository
          .calculateDeliveryFee(
              deliveryType: deliveryType,
              senderPhone: senderPhone,
              senderLocation: senderAddress,
              senderLat: senderLat,
              senderLong: senderLong,
              receiverPhone: receiverPhone,
              receiverLocation: receiverAddress,
              receiverLat: receiverLat,
              receiverLong: receiverLong,
              note: note,
              paymentNote: paymentNote,
              total: total,
              transportId: transportId,
              currencyId: currencyId,
              deliveryFee: deliveryFee)
          .then((resp) async {
        if (resp["message"].toString() == "success") {
          isLoading(false);
          EasyLoading.dismiss();
          getDeliveryFee.value = resp["data"]["grand_total"].toString();
          // Get.defaultDialog(
          //   backgroundColor: Colors.white,
          //   contentPadding: EdgeInsets.all(18.0),
          //   // title: "Confirm to Book Now2?",
          //   // middleText:
          //   //     "Please verify your information before booking.\nDelivery Fee: ${resp["data"]["grand_total"].toString()}",
          //   content: Column(
          //     mainAxisSize: MainAxisSize.min,
          //     children: [
          //       Text("Please verify your information before booking.",
          //           style: TextStyle(fontSize: 16)),
          //       SizedBox(height: 10),
          //       Text("Delivery Fee: ${resp["data"]["grand_total"].toString()}",
          //           style: TextStyle(
          //               fontSize: 16,
          //               // color: Colors.green,
          //               fontWeight: FontWeight.bold)),
          //     ],
          //   ),
          //   textConfirm: "Book Now",
          //   textCancel: "Cancel",
          //   confirm: Container(
          //       child: Text(
          //         "Book Now",
          //         style: TextStyle(color: Colors.white),
          //       ),
          //       padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          //       decoration: BoxDecoration(
          //           color: Colors.green,
          //           borderRadius: BorderRadius.circular(30.0))),
          //   cancel: Container(
          //       //   child: Text(
          //       //     "Cancel",
          //       //     style: TextStyle(color: Colors.white),
          //       //   ),
          //       //   padding: EdgeInsets.all(10.0),
          //       //   decoration: BoxDecoration(
          //       //       color: Colors.red, borderRadius: BorderRadius.circular(5.0)),
          //       ),
          //   onConfirm: () {
          //     Get.back(); // closes the dialog
          //   },
          //   onCancel: () {
          //     // optional, automatically closes
          //   },
          // );
        } else {
          EasyLoading.dismiss();
          print("error" + resp.toString());
          // showSnackBar("Checkout", "Failed to send request", Colors.red);
        }
      }, onError: (err) {
        isLoading(false);
        EasyLoading.dismiss();
        print("error" + err.toString());
        // showSnackBar("Error", err.toString(), Colors.red);
      });
    } catch (e) {
      isLoading(false);
      EasyLoading.dismiss();
      print("error" + e.toString());
      // showSnackBar("Exception", e.toString(), Colors.red);
    }
  }

  void toRequestPickup(
      {required String deliveryType,
      required String senderPhone,
      required String senderAddress,
      required String senderLat,
      required String senderLong,
      required String receiverLat,
      required String receiverLong,
      required String receiverPhone,
      required String receiverAddress,
      required String note,
      required String paymentNote,
      required String total,
      required String transportId,
      required String showTransportType,
      required String currencyId,
      required String deliveryFee,
      File? image}) async {
    try {
      isLoading(true);
      EasyLoading.show(status: 'loading...');
      String imageUrl = '';
      if (image != null) {
        imageUrl = await apiProvider.uploadImage(image: image);
      } else {
        imageUrl = "";
      }
      await _expressRepository
          .createBookingLocal(
              deliveryType: deliveryType,
              senderPhone: senderPhone,
              senderLocation: senderAddress,
              senderLat: senderLat,
              senderLong: senderLong,
              receiverPhone: receiverPhone,
              receiverLocation: receiverAddress,
              receiverLat: receiverLat,
              receiverLong: receiverLong,
              note: note,
              paymentNote: paymentNote,
              total: total,
              transportId: transportId,
              currencyId: currencyId,
              deliveryFee: deliveryFee,
              imageUrl: imageUrl)
          .then((resp) async {
        if (resp.toString() == "success") {
          isLoading(false);
          EasyLoading.dismiss();
          //  Get.find<TaxiController>();
          if (showTransportType == "human") {
            await Get.find<TaxiController>().initTaxiRidding("taxi");
            Get.off(TrackingLocation(
              status: 'pending',
            ));
            // Get.find<TaxiController>().status = "pending";
            // Get.find<TaxiController>().paginateTaxiHistoryList("taxi");
          } else {
            Get.off(SuccessfulScreen(
              successScreenType: SuccessScreenType.deliveryType,
            ));
          }
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

  Future<void> getLocationDetailList(String query) async {
    isDataProcessing(true);
    try {
      final response =
          await _expressRepository.fetchLocationDetailList(query: query);
      locationDetailList
        ..clear() // Optional: Clear previous list if needed
        ..addAll(response);
    } catch (error) {
      showSnackBar("Error", error.toString(), Colors.red);
    } finally {
      isDataProcessing(false); // Always called, even on error
    }
  }

  Future<void> getLatLngFromGoogleMap(String url) async {
    isLoading(true);
    EasyLoading.show(status: 'loading...');
    try {
      final LatLongModel? response =
          await _expressRepository.fetchLatLngFromGoogleMap(mapUrl: url);
      if (response != null) {
        latLongModel = response;
        List<Placemark> placemarks = await placemarkFromCoordinates(
            double.parse(latLongModel!.lat.toString()),
            double.parse(latLongModel!.long.toString()));
        if (placemarks.isNotEmpty) {
          Placemark place = placemarks[0];
          getAddress.value =
              "${place.street}, ${place.locality}, ${place.country}";
          MapPickerScreenState.dropAddress.text =
              "${place.street}, ${place.locality}, ${place.country}";
          MapPickerScreenState.dropLat.text = latLongModel!.lat.toString();
          MapPickerScreenState.dropLong.text = latLongModel!.long.toString();
        }
        isLoading(false);
        print(
            "Latitude: ${latLongModel!.lat}, Longitude: ${latLongModel!.long} address: ${getAddress}");
        EasyLoading.dismiss();
      }
    } catch (error) {
      showSnackBar("Error", error.toString(), Colors.red);
    } finally {
      EasyLoading.dismiss();
      isDataProcessing(false); // Always called, even on error
    }
  }

  void filterLocationByName(String name) async {
    try {
      if (name.isEmpty) {
        // If no name is provided, reset the filtered list to the original list
        filteredLocationDetailList.assignAll(locationDetailList);
      } else {
        final response =
            await _expressRepository.fetchLocationDetailList(query: name);
        filteredLocationDetailList
          ..clear() // Optional: Clear previous list if needed
          ..addAll(response);

        // Filter the zoneList by name
        // filteredLocationDetailList.assignAll(
        //   locationDetailList
        //       .where((location) =>
        //           location.locationDetailData.locationName.toLowerCase().contains(name.toLowerCase()))
        //       .toList(),
        // );
      }
    } catch (e) {
      showSnackBar("Exception", e.toString(), Colors.red);
    }
  }

  // getLocationDetailList(String query) async {
  //   try {
  //     isDataProcessing(true);

  //     final response = await _expressRepository.fetchLocationDetailList(query: query);

  //     isDataProcessing(false);
  //     locationDetailList.addAll(response);
  //   } catch (error) {
  //     isDataProcessing(false);
  //     showSnackBar("Error", error.toString(), Colors.red);
  //   }
  // }

  initDeliveryList(String status, String transportType) async {
    try {
      if (isMoreDataAvailable() && deliveryHistoryList.isNotEmpty) {
        deliveryHistoryList.clear();
      }
      page = 1;
      isDataProcessing(true);

      final response = await _expressRepository.fetchDeliveryList(
        page: page,
        rowPerPage: rowPerPage,
        status: status,
        transportType: transportType,
      );

      isDataProcessing(false);
      deliveryHistoryList.addAll(response);
    } catch (error) {
      isDataProcessing(false);
      showSnackBar("Error", error.toString(), Colors.red);
    }
  }

  getRiddingDeliveryList(
      {required String status, required String transportType}) async {
    try {
      isLoading(true);
      final response = await _expressRepository.fetchTaxiRidding(
        page: page,
        rowPerPage: rowPerPage,
        status: status,
        transportType: transportType,
      );
      isLoading(false);
      if (response.isEmpty) {
        taxiBookingDetail = null;
      } else {
        taxiBookingDetail = response[0];
      }
      // deliveryHistoryList.addAll(response);
    } catch (e) {
      isLoading(false);
      showSnackBar("Exception", "មានបញ្ហាក្នុងការទាញយកទិន្ន័យ", Colors.red);
    }
  }

  paginateDeliveryList(String status, String showTransportType) {
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        print("reached end");
        page++;
        getMoreDeliveryList(page, status, showTransportType);
      }
    });
  }

  getMoreDeliveryList(var page, String status, String transportType) async {
    try {
      await _expressRepository
          .fetchDeliveryList(
              page: page,
              rowPerPage: rowPerPage,
              status: status,
              transportType: transportType)
          .then((resp) {
        if (resp.length > rowPerPage) {
          isMoreDataAvailable(true);
        } else {
          isMoreDataAvailable(false);
          // showSnackBar("Message", "No more items", Colors.lightBlueAccent);
        }
        deliveryHistoryList.addAll(resp);
      }, onError: (err) {
        isMoreDataAvailable(false);
        showSnackBar("Error", err.toString(), Colors.red);
      });
    } catch (e) {
      isMoreDataAvailable(false);
      showSnackBar("Exception", e.toString(), Colors.red);
    }
  }

  getCurrencies() async {
    try {
      isLoading(true);
      await _expressRepository.fetchCurrencies(page, 100).then((resp) {
        isLoading(false);
        currencyList.addAll(resp);
      }, onError: (err) {
        isLoading(false);
        showSnackBar("Error", err.toString(), Colors.red);
      });
    } catch (e) {
      isLoading(false);
      showSnackBar("Exception", e.toString(), Colors.red);
    }
  }

  trackingDeliveryHistory({required String id}) async {
    try {
      isLoading(true);
      deliveryHistoryModel = null;
      await _expressRepository.trackDeliveryById(id: id).then((resp) {
        isLoading(false);
        deliveryHistoryModel = resp;
      }, onError: (err) {
        isLoading(false);
        print("error" + err.toString());
        // showSnackBar("Error", err.toString(), Colors.red);
      });
    } catch (e) {
      isLoading(false);
      showSnackBar("Exception", "មានបញ្ហាក្នុងការទាញយកទិន្ន័យ", Colors.red);
    }
  }

  void toSubmitCustomerRating(
      {required int starRate,
      required String customerFeedback,
      required String id}) async {
    try {
      isLoading(true);
      EasyLoading.show(status: 'loading...');
      await _expressRepository
          .addCustomerRating(
              starRate: starRate, customerFeedback: customerFeedback, id: id)
          .then((resp) async {
        if (resp.toString() == "success") {
          isLoading(false);
          EasyLoading.dismiss();
          // Get.back();
          showSnackBar("Success", "Request sent successfully", Colors.green);
        } else {
          EasyLoading.dismiss();
          showSnackBar("Alert!", "Failed to send request", Colors.red);
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
}

class LatLongModel {
  String? lat;
  String? long;

  LatLongModel({this.lat, this.long});

  factory LatLongModel.fromJson(Map<String, dynamic> json) {
    return LatLongModel(
      lat: json['lat'],
      long: json['lng'],
    );
  }
}
