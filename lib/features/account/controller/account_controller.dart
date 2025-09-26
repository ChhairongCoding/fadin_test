import 'dart:io';

import 'package:fardinexpress/features/account/controller/account_repository.dart';
import 'package:fardinexpress/features/account/model/account_model.dart';
import 'package:fardinexpress/features/auth/bloc/auth_bloc.dart';
import 'package:fardinexpress/features/auth/bloc/auth_event.dart';
import 'package:fardinexpress/services/api_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class AccountController extends GetxController with StateMixin {
  var isLoading = false.obs;
  // var currentIndex = 0.obs;
  var addressId = "".obs;
  var addressName = "".obs;
  RxString userName = "".obs;
  RxString image = "".obs;
  var context;
  var accountInfo = AccountModel(
      id: "0",
      name: "",
      phone: "",
      address:
          AddressProfile(id: "", name: "", lat: "", long: "", description: ""),
      verifyStatus: "",
      profilePic: '',
      bankNumber: "",
      total: '');
  AccountRepository _accountRepository = AccountRepository();
  ApiProvider apiProvider = ApiProvider();

  // AccountController() {
  //   getAccountInfo();
  // }

  @override
  void onInit() {
    super.onInit();
    getAccountInfo();
    determinePosition();
  }

  showSnackBar(String title, String message, Color bgColor) {
    Get.snackbar(title, message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: bgColor,
        colorText: Colors.white);
  }

//  BlocProvider.of<AuthenticationBloc>(context).add(UserLoggedOut());
  getAccountInfo() async {
    try {
      isLoading(true);
      await _accountRepository.fetchProfileInfo().then((res) {
        accountInfo = res;
        userName.value = res.name;
        image.value = res.profilePic;
        addressId.value = res.address.id;
        addressName.value = res.address.description;
      }, onError: (err) {
        if (err.toString() == 'Unauthenticated.') {
          BlocProvider.of<AuthenticationBloc>(Get.context!)
              .add(UserLoggedOut());
        } else {
          print(err.toString());
        }
        print(err.toString());
      });
      isLoading(false);
    } finally {
      isLoading(false);
    }
  }

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: ((context) {
            return AlertDialog(
              title: Text("alert".tr),
              content: Text("សូមបើកសេវាទីតាំងរបស់អ្នក"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Geolocator.openLocationSettings();
                  },
                  child: Text("OK".tr),
                )
              ],
            );
          }));
      // _showLocationPermissionDialog(
      //     title: "locationServiceDisabled".tr,
      //     content: "pleaseEnableLocationService".tr,
      //     serviceEnabled: serviceEnabled,
      //     onPressed: () async {
      //       await Geolocator.openLocationSettings();
      //     });
      return Future.error('Location services are disabled.');
    }
    // else {
    //   Get.back();
    // }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: ((context) {
              return AlertDialog(
                title: Text("alert".tr),
                content: Text("សូមបើកសេវាទីតាំងរបស់អ្នក"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Geolocator.openLocationSettings();
                    },
                    child: Text("OK".tr),
                  )
                ],
              );
            }));
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: ((context) {
            return AlertDialog(
              title: Text("alert".tr),
              content: Text("សូមបើកសេវាទីតាំងរបស់អ្នក"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Geolocator.openLocationSettings();
                  },
                  child: Text("OK".tr),
                )
              ],
            );
          }));
      throw 'Location permissions are permanently denied.';
      // return Future.error(
      //     'Location permissions are permanently denied, we cannot request permissions.');
    }
    // if (serviceEnabled) {
    //   Get.back();
    // }
    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  void toEditAccount(
      String name, String address, String accNumber, File? image) async {
    try {
      isLoading(true);
      EasyLoading.show(status: 'loading...');
      String imageUrl = '';
      if (image != null) {
        imageUrl = await apiProvider.uploadImage(image: image);
      } else {
        imageUrl = "";
      }

      await _accountRepository
          .editAccount(
              name: name,
              address: address,
              accNumber: accNumber,
              image: imageUrl)
          .then((resp) {
        if (resp.id != null) {
          isLoading(false);
          EasyLoading.dismiss();
          // showSnackBar(
          //     "Profile", "Your profile has been updated.", Colors.green);
          getAccountInfo();
          Alert(
            onWillPopActive: true,
            type: AlertType.success,
            context: Get.context!,
            closeIcon: Container(),
            style: AlertStyle(
              titlePadding: EdgeInsets.all(0),
              descTextAlign: TextAlign.center,
              descStyle: TextStyle(
                fontSize: 18,
              ),
            ),
            title: "",
            desc: "success".tr,
            buttons: [
              DialogButton(
                child: Text(
                  "done".tr,
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: () {
                  Navigator.pop(Get.context!);
                  Navigator.pop(Get.context!);
                },
                color: Colors.blue,
                radius: BorderRadius.circular(8.0),
              ),
            ],
          ).show();
        } else {
          EasyLoading.dismiss();
          Alert(
            onWillPopActive: true,
            type: AlertType.info,
            context: Get.context!,
            closeIcon: Container(),
            style: AlertStyle(
              titlePadding: EdgeInsets.all(0),
              descTextAlign: TextAlign.center,
              descStyle: TextStyle(
                fontSize: 18,
              ),
            ),
            title: "",
            desc: "alert".tr,
            buttons: [
              DialogButton(
                child: Text(
                  "ok".tr,
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: () {
                  Navigator.pop(Get.context!);
                },
                color: Colors.blue,
                radius: BorderRadius.circular(8.0),
              ),
            ],
          ).show();
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

  void toDeactivateAccount(var _) async {
    try {
      isLoading(true);
      EasyLoading.show(status: 'loading...');
      await _accountRepository.deleteAccount().then((resp) {
        if (resp.toString() == "200") {
          isLoading(false);
          EasyLoading.dismiss();
          // showSnackBar(
          //     "Profile", "Your profile has been updated.", Colors.green);
          Get.back();
          BlocProvider.of<AuthenticationBloc>(_).add(UserLoggedOut());
        } else {
          EasyLoading.dismiss();
          showSnackBar("Profile", "Failed to update profile", Colors.red);
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
