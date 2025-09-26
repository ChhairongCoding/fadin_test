import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fardinexpress/features/banner/model/banner_model.dart';
import 'package:fardinexpress/services/api_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class BannerRepository {
  ApiProvider apiProvider = ApiProvider();
  String baseUrl =
      "${dotenv.env['baseUrl']}/banners?vendor_code=${dotenv.env['vendor_code']}";
  int rowPerPage = 10;
  Future<List<BannerModel>> getBannerImages() async {
    String url = baseUrl;
    try {
      Response response = (await (apiProvider.get(url, null, null)))!;
      if (response.statusCode == 200) {
        var data = response.data;
        List<BannerModel> banners = [];
        data["data"].forEach((banner) {
          banners.add(BannerModel.fromJson(banner));
        });
        return banners;
      }
      var data = json.decode(response.data);
      throw Exception(data["message"].toString());
    } catch (e) {
      throw Exception(e);
    }
  }
}
