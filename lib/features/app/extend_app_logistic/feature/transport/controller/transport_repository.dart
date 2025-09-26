import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/feature/transport/model/transport_model.dart';
import 'package:fardinexpress/services/api_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class TransportRepository {
  ApiProvider apiProvider = ApiProvider();
  // int rowPerPage = 10;
  Future<List<TransportModel>> fetchTransportList(
      {required String type}) async {
    String url = "${dotenv.env['baseUrl']}/transports?type=$type";
    ;
    try {
      Response response = (await (apiProvider.get(url, null, null)))!;
      if (response.statusCode == 200) {
        var data = response.data;
        List<TransportModel> transports = <TransportModel>[].obs;
        data["data"].forEach((item) {
          transports.add(TransportModel.fromJson(item));
        });
        return transports;
      }
      var data = json.decode(response.data);
      throw data["message"];
    } catch (e) {
      throw e;
    }
  }
}
