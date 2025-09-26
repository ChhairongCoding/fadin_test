import 'package:fardinexpress/features/account/controller/account_controller.dart';
import 'package:fardinexpress/features/address/controller/address_repository.dart';
import 'package:fardinexpress/features/address/model/address_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class AddressController extends GetxController {
  var isLoading = false.obs;
  // var currentIndex = 0.obs;
  List<AddressModel> addressList = <AddressModel>[].obs;
  AddressRepository addressRepository = AddressRepository();

  AddressController() {
    getAddressList();
  }

  showSnackBar(String title, String message, Color bgColor) {
    Get.snackbar(title, message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: bgColor,
        colorText: Colors.white);
  }

  void getAddressList() async {
    try {
      isLoading(true);
      var tempList = await addressRepository.fetchAddressList();
      addressList.addAll(tempList);
      isLoading(false);
    } catch (e) {
      isLoading(false);
      showSnackBar("Exception", e.toString(), Colors.red);
    }
  }

  void toSelectLocation({required String addressId}) async {
    try {
      isLoading(true);
      EasyLoading.show(status: 'loading...');
      await addressRepository.selectAddress(addressId: addressId).then((resp) {
        if (resp == "Address selected") {
          isLoading(false);
          addressList.clear();
          EasyLoading.dismiss();
          // showSnackBar(
          //     "Profile", "Your profile has been updated.", Colors.green);
          getAddressList();
          Get.find<AccountController>().getAccountInfo();
        } else {
          EasyLoading.dismiss();
          showSnackBar("Address", "Failed to update address", Colors.red);
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

  void toAddLocation(
      {required String name,
      required String lat,
      required String long,
      required String description}) async {
    try {
      isLoading(true);
      EasyLoading.show(status: 'loading...');
      await addressRepository
          .addAddress(
              name: name, lat: lat, long: long, description: description)
          .then((resp) {
        if (resp == "Created") {
          isLoading(false);
          addressList.clear();
          EasyLoading.dismiss();
          // showSnackBar(
          //     "Profile", "Your profile has been updated.", Colors.green);
          getAddressList();
          Get.back();
        } else {
          EasyLoading.dismiss();
          showSnackBar("Address", "Failed to update address", Colors.red);
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

  void toDeleteLocation({required String addressId}) async {
    try {
      isLoading(true);
      EasyLoading.show(status: 'loading...');
      await addressRepository.removeAddress(addressId: addressId).then((resp) {
        if (resp == "Deleted") {
          isLoading(false);
          addressList.clear();
          EasyLoading.dismiss();
          // showSnackBar(
          //     "Profile", "Your profile has been updated.", Colors.green);
          getAddressList();
        } else {
          EasyLoading.dismiss();
          showSnackBar("Address", "Failed to update address", Colors.red);
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
