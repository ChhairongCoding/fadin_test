import 'package:dio/dio.dart';
import 'package:fardinexpress/features/otp/model/confirm_otp_forgot_response.dart';
import 'package:fardinexpress/features/otp/model/forgot_password_response.dart';
import 'package:fardinexpress/services/api_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class VerifyUserRepository {
  ApiProvider apiProvider = ApiProvider();

  Future<String?> verifyUser(
      {required String phone, required String otpCode}) async {
    String url =
        "${dotenv.env['baseUrl']}/verify?vendor_code=${dotenv.env['vendor_code']}";
    String body = '{"phone":"$phone","otp":"$otpCode"}';
    try {
      Response response = (await (apiProvider.post(url, body, null)))!;
      if (response.statusCode == 200) {
        // if (response.data["token"] == null) {
        //   throw Exception("response faild!");
        // }
        return response.data["message"];
      } else {
        throw response.data["message"];
      }
    } catch (e) {
      throw e;
    }
  }

  Future<ForgotPasswordResponse> confirmPhoneNumber(
      {
      // @required String firstName,
      // @required String lastName,
      required String phone,
      required String secret,
      required String type}) async {
    await Future.delayed(Duration(seconds: 1));
    String url =
        '${dotenv.env['baseUrl']}/auth/resend?vendor_code=${dotenv.env['vendor_code']}';
    String body = '{"phone": "$phone","secret":"$secret","type":"$type"}';
    try {
      Response response = (await (apiProvider.post(url, body, null)))!;
      if (response.statusCode == 200) {
        var data = response.data;
        return ForgotPasswordResponse.fromJson(data);
      }
      throw response.data["message"];
    } catch (e) {
      throw e;
    }
  }

  Future<ConfirmOtpForgotModel> confirmOtpForgotPassword(
      {required String reference,
      required String otp,
      required String secret}) async {
    String url =
        "${dotenv.env['baseUrl']}/auth/forgot/otp?vendor_code=${dotenv.env['vendor_code']}";
    String body = '{"reference":"$reference","otp":"$otp", "secret":"$secret"}';
    try {
      Response response = (await (apiProvider.post(url, body, null)))!;
      if (response.statusCode == 200) {
        print("Code has been sent to your phone");
        var data = response.data;
        return ConfirmOtpForgotModel.fromJson(data);
      } else {
        throw response.data["message"].toString();
      }
    } catch (e) {
      throw e;
    }
  }
}
