import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/feature/delivery/models/delivery.dart';
import 'package:fardinexpress/services/api_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class DeliveryListingRepository {
  final ApiProvider apiProvider = ApiProvider();
  late String url;
  Future<List<Delivery>> getDeliveryList(
      {required int page, required int rowPerPage, required additionalArg});
  Future<List<Delivery>> operate(
      {required String urlSuffix,
      required int page,
      required int rowPerPage}) async {
    try {
      url = "${dotenv.env['baseUrl']}/deliveries?" + urlSuffix;

      Response response = (await apiProvider.get(url, null, null))!;

      if (response.statusCode == 200) {
        // return compute(parseProducts, response.data["data"]);
        List<Delivery> products = [];
        response.data["data"].forEach((val) {
          products.add(Delivery.fromJson(val));
        });
        log("logs:" + products.toString());
        return products;
      }
      throw "Exception";
    } catch (e) {
      log(e.toString());
      throw e;
    }
  }
}

class DeliveryListByInternationRepo extends DeliveryListingRepository {
  @override
  Future<List<Delivery>> getDeliveryList(
          {required int page,
          required int rowPerPage,
          required additionalArg}) async =>
      await super.operate(
          urlSuffix:
              "status=pending&country_type=foreign&row_per_page=$rowPerPage&page=$page&country_id=$additionalArg",
          // "row_per_page=$rowPerPage&page=$page&status=pending&delivery_type=logistic",
          page: page,
          rowPerPage: rowPerPage);
}

class DeliveryListByLocalRepo extends DeliveryListingRepository {
  @override
  Future<List<Delivery>> getDeliveryList(
          {required int page,
          required int rowPerPage,
          required additionalArg}) async =>
      await super.operate(
          urlSuffix:
              "status=pending&country_type=local&row_per_page=$rowPerPage&page=$page&country_id=$additionalArg",
          page: page,
          rowPerPage: rowPerPage);
}

class DeliveryListByCompletedRepo extends DeliveryListingRepository {
  @override
  Future<List<Delivery>> getDeliveryList(
          {required int page,
          required int rowPerPage,
          required additionalArg}) async =>
      await super.operate(
          urlSuffix:
              "status=completed&row_per_page=$rowPerPage&page=$page&country_id=$additionalArg",
          page: page,
          rowPerPage: rowPerPage);
}

class DeliveryListBySearchRepo extends DeliveryListingRepository {
  final String code;
  DeliveryListBySearchRepo({required this.code});
  @override
  Future<List<Delivery>> getDeliveryList(
          {required int page,
          required int rowPerPage,
          required additionalArg}) async =>
      await super.operate(
          urlSuffix: "country=$code", page: page, rowPerPage: rowPerPage);
}
