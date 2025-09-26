import 'package:dio/dio.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/feature/warehouse_address/models/warehouse_address.dart';
import 'package:fardinexpress/services/api_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class WarehouseAddressRepository {
  Future<List<WarehouseAddress>> getwarehouseaddresses() async {
    ApiProvider apiProvider = ApiProvider();
    String url =
        "${dotenv.env['baseUrl']}/warehouses?page=1&row_per_page=12&vendor_code=${dotenv.env['vendor_code']}";

    try {
      Response response = (await apiProvider.get(url, null, null))!;
      final List<WarehouseAddress> itemList = [];
      response.data["data"].forEach((element) {
        itemList.add(WarehouseAddress.fromJson(element));
      });
      return itemList;
    } catch (error) {
      throw error;
    }
  }
}
