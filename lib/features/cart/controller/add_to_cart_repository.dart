import 'package:dio/dio.dart';
import 'package:fardinexpress/services/api_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AddToCartRepository {
  ApiProvider apiProvider = ApiProvider();

  Future<String?> addToCart(
      {required String productId,
      required String quantity,
      required String storeId}) async {
    Map<String, dynamic> body = {
      "product_id": productId,
      "quantity": quantity,
      "type": storeId
    };

    String url = '${dotenv.env['baseUrl']}/cart/add';
    try {
      Response response = (await (apiProvider.post(url, body, null)))!;
      if (response.statusCode == 201) {
        var data = response.data;
        print("you have been added product to cart");
        return data["message"].toString();
      } else {
        throw response.data["message"].toString();
      }
    } catch (e) {
      throw e;
    }
  }
}
