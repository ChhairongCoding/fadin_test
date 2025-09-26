import 'package:dio/dio.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/feature/delivery/models/delivery.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/feature/search/models/search_history.dart';
import 'package:fardinexpress/services/api_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SearchRepository {
  ApiProvider apiProvider = ApiProvider();

  Future<List<Delivery>> searchDelivery(
      {required int page, required String query}) async {
    final String url =
        "${dotenv.env['baseUrl']}/deliveries?code=$query&row_per_page=10&page=$page&delivery_type=logistic";
    try {
      Response response = (await apiProvider.get(url, null, null))!;

      if (response.statusCode == 200) {
        // return compute(parseProducts, response.data["data"]);
        List<Delivery> products = [];
        response.data["data"].forEach((val) {
          products.add(Delivery.fromJson(val));
        });
        return products;
      }
      throw response.data["message"].toString();
    } catch (e) {
      throw e;
    }
  }

  Future<List<SearchHistory>> getHistory({required int page}) async {
    final String url =
        "${dotenv.env['baseUrl']}/search/history/?row_per_page=10&page=$page";
    try {
      Response response = (await apiProvider.get(url, null, null))!;

      if (response.statusCode == 200) {
        // return compute(parseProducts, response.data["data"]);
        List<SearchHistory> products = [];
        response.data["data"].forEach((val) {
          products.add(SearchHistory.fromJson(val));
        });
        return products;
      }
      throw response.data["message"].toString();
    } catch (e) {
      throw e;
    }
  }

  Future<void> clearHistory({required String historyId}) async {
    final String url =
        "${dotenv.env['baseUrl']}/search/history/clear/$historyId";
    try {
      Response response = (await apiProvider.delete(url, null))!;

      if (response.statusCode == 200) {
        return;
      }
      throw response.data["message"].toString();
    } catch (e) {
      throw e;
    }
  }

  Future<void> clearAllHistory() async {
    final String url = "${dotenv.env['baseUrl']}/search/history/clear";
    try {
      Response response = (await apiProvider.delete(url, null))!;

      if (response.statusCode == 200) {
        return;
      }
      throw response.data["message"].toString();
    } catch (e) {
      throw e;
    }
  }
}
