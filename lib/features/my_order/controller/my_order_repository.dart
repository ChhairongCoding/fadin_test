import 'package:dio/dio.dart';
import 'package:fardinexpress/features/my_order/model/order_detail_model.dart';
import 'package:fardinexpress/features/my_order/model/order_model.dart';
import 'package:fardinexpress/services/api_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class MyOrderRepository {
  ApiProvider apiProvider = ApiProvider();
  String url = "";

  Future<List<OrderModel>> fetchMyOrderList(
      {required int? page,
      required int rowPerPage,
      required String? status}) async {
    try {
      url =
          "${dotenv.env['baseUrl']}/checkout/history?status=$status&page=$page&row_per_page=$rowPerPage";
      Response response = (await (apiProvider.get(url, null, null)))!;
      if (response.statusCode == 200) {
        var data = response.data;
        List<OrderModel> myOrderListing = <OrderModel>[].obs;
        data.forEach((item) {
          myOrderListing.add(OrderModel.fromJson(item));
        });
        return myOrderListing;
      } else {
        var data = response.data;
        throw data["message"].toString();
      }
    } catch (e) {
      throw e;
    }
  }

  Future<OrderDetailModel> fetchMyOrderDetail(
      {required String? orderId}) async {
    try {
      url = "${dotenv.env['baseUrl']}/checkout/history/detail/$orderId";
      Response response = (await (apiProvider.get(url, null, null)))!;
      if (response.statusCode == 200) {
        var data = response.data;
        return OrderDetailModel.fromJson(data);
      } else {
        var data = response.data;
        throw data["message"].toString();
      }
    } catch (e) {
      throw e;
    }
  }
}
