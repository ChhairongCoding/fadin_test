import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fardinexpress/features/account/model/account_model.dart';
import 'package:fardinexpress/features/account/model/user_model.dart';
import 'package:fardinexpress/services/api_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AccountRepository {
  ApiProvider apiProvider = ApiProvider();
  String baseUrl = "${dotenv.env['baseUrl']}/profile";

  Future<AccountModel> fetchProfileInfo() async {
    String url = baseUrl;
    try {
      Response response = (await (apiProvider.get(url, null, null)))!;
      if (response.statusCode == 200) {
        var data = response.data;
        // var data = res["data"];
        return AccountModel.fromJson(data);
      }
      var data = json.decode(response.data);
      throw data["message"];
    } catch (e) {
      throw e;
    }
  }

  Future<User> editAccount(
      {required String name,
      required String address,
      required String accNumber,
      required String image}) async {
    try {
      String url = baseUrl;
      String body =
          '{"name":"$name","address":"$address", "account_number": "$accNumber", "image": "$image"}';
      Response response = (await apiProvider.put(url + "/update", body))!;
      if (response.statusCode == 200) {
        return User.fromJson(response.data);
      } else if (response.statusCode == 401) {
        throw response.data["message"].toString();
      }
      throw response.data["message"].toString();
    } catch (e) {
      throw e;
    }
  }

  Future<String> deleteAccount() async {
    String url = '${dotenv.env['baseUrl']}/auth/delete';
    // String body = '{"name":"$name", "image_url":"$imageUrl"}';
    try {
      Response response = (await (apiProvider.delete(url, null)))!;
      print(response.statusCode);
      if (response.statusCode == 200) {
        return response.statusCode.toString();
      } else {
        throw response.data["message"].toString();
      }
    } catch (e) {
      throw e;
    }
  }
}
