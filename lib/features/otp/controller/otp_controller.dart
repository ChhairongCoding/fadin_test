import 'package:fardinexpress/features/auth/bloc/auth_bloc.dart';
import 'package:fardinexpress/features/auth/bloc/auth_event.dart';
import 'package:fardinexpress/features/auth/login/view/create_password_page.dart';
import 'package:fardinexpress/features/otp/controller/otp_repository.dart';
import 'package:fardinexpress/features/otp/view/confirm_otp_forgot_password.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class OtpController extends GetxController {
  VerifyUserRepository verifyUserRepository = VerifyUserRepository();
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

  void verifyUser(var phone, var otpCode, var token, var _) async {
    try {
      isLoading(true);
      await verifyUserRepository
          .verifyUser(phone: phone, otpCode: otpCode)
          .then((resp) {
        if (resp.toString() == "success") {
          isLoading(false);
          // Get.find<CartStoreController>().getCartStoreList();
          // showSnackBar(
          //     "Success.", "Your account has been verified", Colors.green);
          BlocProvider.of<AuthenticationBloc>(_)
              .add(UserLoggedIn(token: token));
          Get.back();
        } else {
          showSnackBar("Alert!", "Failed to verify account.", Colors.red);
        }
      }, onError: (err) {
        isLoading(false);
        showSnackBar("Error", err.toString(), Colors.red);
      });
    } catch (e) {
      isLoading(false);
      showSnackBar("Exception", e.toString(), Colors.red);
    }
  }

  void confirmUserPhoneNumber(var phone, var secret, var type) async {
    try {
      isLoading(true);
      EasyLoading.show(status: "loading...");
      await verifyUserRepository
          .confirmPhoneNumber(phone: phone, secret: secret, type: type)
          .then((resp) {
        if (resp.message.toString() == "success") {
          isLoading(false);
          EasyLoading.dismiss();
          Get.off(() => ConfirmOPTForgot(
              reference: resp.reference!.toString(), phone: phone));
        } else {
          EasyLoading.dismiss();
          showSnackBar("Alert!", "Failed to verify account.", Colors.red);
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

  void verifyOtpForgotPassword(var reference, var secret, var otpCode) async {
    try {
      isLoading(true);
      EasyLoading.show(status: "loading...");
      await verifyUserRepository
          .confirmOtpForgotPassword(
              reference: reference, otp: otpCode, secret: secret)
          .then((resp) {
        if (resp.message.toString() == "success") {
          isLoading(false);
          EasyLoading.dismiss();
          Get.off(() =>
              CreateNewPasswordPage(reference: resp.reference.toString()));
        } else {
          EasyLoading.dismiss();
          showSnackBar("Alert!", "Failed to verify code.", Colors.red);
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
