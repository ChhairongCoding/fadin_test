import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fardinexpress/features/zone/model/zone_model.dart';
import 'package:fardinexpress/services/api_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ZoneRepository {
  ApiProvider apiProvider = ApiProvider();
  Future<List<ZoneModel>> fetchZoneList(int page, int rowPerPage) async {
    String baseUrl =
        "${dotenv.env['baseUrl']}/delivery/locations?row_per_page=$rowPerPage&page=$page";
    String url = baseUrl;
    try {
      Response response = (await (apiProvider.get(url, null, null)))!;
      if (response.statusCode == 200) {
        var data = response.data;
        List<ZoneModel> zoneList = [];
        data["data"].forEach((item) {
          zoneList.add(ZoneModel.fromJson(item));
        });
        return zoneList;
      }
      var data = json.decode(response.data);
      throw Exception(data["message"].toString());
    } catch (e) {
      throw Exception(e);
    }
  }
}
