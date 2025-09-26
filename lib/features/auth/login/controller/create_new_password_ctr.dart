import 'package:fardinexpress/features/auth/bloc/auth_bloc.dart';
import 'package:fardinexpress/features/auth/bloc/auth_event.dart';
import 'package:fardinexpress/features/auth/login/repositories/register_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class CreateNewPasswordController extends GetxController {
  RegisterRepository registerRepository = RegisterRepository();
  var isLoading = false.obs;
  var rpMessage;
  // ForgotPasswordResponse _forgotPasswordResponse = ForgotPasswordResponse(message: "", reference: "");

  // common snack bar
  showSnackBar(String title, String message, Color bgColor) {
    Get.snackbar(title, message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: bgColor,
        colorText: Colors.white);
  }

  void toCreateNewPassword(
      var reference, var password, var secret, var _) async {
    try {
      isLoading(true);
      EasyLoading.show(status: "loading...");
      await registerRepository
          .sendCreateNewPassword(
              reference: reference, password: password, secret: secret)
          .then((resp) {
        if (resp.token.toString() != "" || resp.token.toString() != "null") {
          isLoading(false);
          EasyLoading.dismiss();
          // Get.find<CartStoreController>().getCartStoreList();
          // showSnackBar(
          //     "Success.", "Your account has been verified", Colors.green);
          BlocProvider.of<AuthenticationBloc>(_)
              .add(UserLoggedIn(token: resp.token.toString()));
          Get.back();
        } else {
          EasyLoading.dismiss();
          showSnackBar("Alert!", "Failed to create password.", Colors.red);
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

  void toChangePassword(var currentPass, var newPass, var _) async {
    try {
      isLoading(true);
      EasyLoading.show(status: "loading...");
      await registerRepository
          .changePassword(currentPass: currentPass, newPass: newPass)
          .then((String? resp) {
        if (resp != null) {
          isLoading(false);
          EasyLoading.dismiss();
          // Get.find<CartStoreController>().getCartStoreList();
          // showSnackBar(
          //     "Success.", "Your account has been verified", Colors.green);
          BlocProvider.of<AuthenticationBloc>(_).add(UserLoggedOut());
          Get.back();
          Get.back();
        } else {
          EasyLoading.dismiss();
          showSnackBar("Alert!", "Failed to change password.", Colors.red);
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
