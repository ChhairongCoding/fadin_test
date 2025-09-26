import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fardinexpress/features/shop/model/shop_model.dart';
import 'package:fardinexpress/services/api_provider.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class StoreRepository {
  ApiProvider apiProvider = ApiProvider();
  String baseUrl = "https://fardinexpress.asia/api/stores";
  // "${dotenv.env['baseUrl']}/stores?vendor_code=${dotenv.env['vendor_code']}&page=1&row_per_page=10";
  // int rowPerPage = 10;
  Future<List<StoreModel>> fetchStoreList() async {
    String url = baseUrl;
    try {
      Response response = (await (apiProvider.get(url, null, null)))!;
      if (response.statusCode == 200) {
        var data = response.data;
        List<StoreModel> stores = <StoreModel>[].obs;
        data.forEach((item) {
          stores.add(StoreModel.fromJson(item));
        });
        return stores;
      }
      var data = json.decode(response.data);
      throw data["message"];
    } catch (e) {
      throw e;
    }
  }
}
