import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fardinexpress/features/auth/login/model/login_response.dart';
import 'package:fardinexpress/services/api_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class LoginRepository {
  ApiProvider apiProvider = ApiProvider();

  Future<LoginResponseModel> login(
      {required String phone, required String password}) async {
    String url =
        "${dotenv.env['baseUrl']}/login?vendor_code=${dotenv.env['vendor_code']}";
    String body = '{"phone":"$phone","password":"$password"}';
    var auth = 'basic' + base64Encode(utf8.encode('$phone:$password'));
    try {
      Response response = (await (apiProvider.post(url, body, null)))!;
      if (response.statusCode == 200 &&
          response.data["user"]["status"].toString().toLowerCase() ==
              "active") {
        var data = response.data;
        return LoginResponseModel(
            token: data["token"], phone: data["user"]["phone"]);
      } else if (response.statusCode == 200 &&
          response.data["user"]["status"].toString().toLowerCase() ==
              "inactive") {
        throw "Your account has been deactivated!";
      } else {
        var dataM = response.data["Message"].toString();
        var datam = response.data["message"].toString();
        if (dataM.isEmpty) {
          throw datam;
        } else {
          throw dataM;
        }
      }
    } catch (e) {
      throw e;
    }
  }
}
