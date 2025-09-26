import 'package:dio/dio.dart';
import 'package:fardinexpress/features/auth/login/model/create_new_password_respone.dart';
import 'package:fardinexpress/features/auth/login/model/register_response.dart';
import 'package:fardinexpress/services/api_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class RegisterRepository {
  ApiProvider apiProvider = ApiProvider();

  Future<UserResponseModel> register(
      {
      // @required String firstName,
      // @required String lastName,
      required String name,
      required String phone,
      required String password}) async {
    await Future.delayed(Duration(seconds: 1));
    String url =
        '${dotenv.env['baseUrl']}/register?vendor_code=${dotenv.env['vendor_code']}';
    String body = '{"name": "$name","phone":"$phone","password":"$password"}';
    try {
      Response response = (await (apiProvider.post(url, body, null)))!;
      if (response.statusCode == 201) {
        var data = response.data;
        if (response.data["token"] == null) {
          throw response.data["message"];
        }
        return UserResponseModel(
            name: data["user"]["name"],
            token: data["token"],
            phone: data["user"]["phone"]);
      }
      throw response.data["message"];
    } catch (e) {
      throw e;
    }
  }

  Future<CreateNewPasswordResponse> sendCreateNewPassword(
      {required String reference,
      required String password,
      required String secret}) async {
    await Future.delayed(Duration(seconds: 1));
    String url =
        '${dotenv.env['baseUrl']}/auth/forgot/password?vendor_code=${dotenv.env['vendor_code']}';
    dynamic body = {
      "reference": reference,
      "password": password,
      "secret": secret
    };
    try {
      Response response = (await (apiProvider.post(url, body, null)))!;
      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = response.data;
        return CreateNewPasswordResponse.fromJson(data);
      } else {
        throw response.data.toString();
      }
    } catch (e) {
      throw e;
    }
  }

  Future<String> changePassword(
      {required String currentPass, required String newPass}) async {
    String url = '${dotenv.env['baseUrl']}/auth/change';
    dynamic body = {
      "current_password": currentPass,
      "new_password": newPass,
    };
    try {
      Response response = (await (apiProvider.put(url, body)))!;
      if (response.statusCode == 200) {
        var data = response.data;
        return data["message"].toString();
      } else {
        throw response.data["message"].toString();
      }
    } catch (e) {
      throw e;
    }
  }
}
