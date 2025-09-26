import 'package:dio/dio.dart';
import 'package:fardinexpress/features/taxi/model/location_detail_model.dart';
import 'package:fardinexpress/features/taxi/model/taxi_history_model.dart';
import 'package:fardinexpress/services/api_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class TaxiRepository {
  ApiProvider apiProvider = ApiProvider();

  Future<List<TaxiHistoryModel>> fetchTaxiHistoryList(
      {required int? page,
      required int rowPerPage,
      required String transportType}) async {
    try {
      String url =
          "${dotenv.env['baseUrl']}/deliveries?row_per_page=$rowPerPage&page=$page&delivery_type=$transportType";

      Response response = (await (apiProvider.get(url, null, null)))!;
      if (response.statusCode == 200) {
        var data = response.data;
        List<TaxiHistoryModel> tempList = <TaxiHistoryModel>[].obs;
        data["data"].forEach((item) {
          tempList.add(TaxiHistoryModel.fromJson(item));
        });
        return tempList;
      } else {
        var data = response.data;
        throw data["message"].toString();
      }
    } catch (e) {
      throw e;
    }
  }

  Future<List<TaxiHistoryModel>> fetchTaxiRidding(
      {required int? page,
      required int rowPerPage,
      required String transportType}) async {
    try {
      String url =
          "${dotenv.env['baseUrl']}/deliveries?row_per_page=$rowPerPage&page=$page&delivery_type=$transportType";
      // &status=pending

      Response response = (await (apiProvider.get(url, null, null)))!;
      if (response.statusCode == 200) {
        var data = response.data["data"] as List;
        List<TaxiHistoryModel> tempList = <TaxiHistoryModel>[].obs;

        // data.forEach((item) {
        //   tempList.add(TaxiHistoryModel.fromJson(item));
        // });
        if (data.isNotEmpty) {
          tempList =
              data.isNotEmpty ? [TaxiHistoryModel.fromJson(data.first)] : [];
        } else {
          tempList = [];
        }

        // print("status: " + tempList.first.id.toString());
        return tempList;
      } else {
        var data = response.data;
        throw data["message"].toString();
      }
    } catch (e) {
      throw e;
    }
  }

}
