import 'package:dio/dio.dart';
import 'package:fardinexpress/features/cart/model/cart_store_model.dart';
import 'package:fardinexpress/features/checkout/model/khqr_res_model.dart';
import 'package:fardinexpress/features/product/model/product_res_model.dart';
import 'package:fardinexpress/services/api_provider.dart';

class CheckoutRepository {
  ApiProvider apiProvider = ApiProvider();

  Future<String?> checkoutToServer(
      {required String type,
      required String grandTotal,
      required List<CartStoreItem> cartStoreModel,
      required String addressId,
      required List<ProductModelRes> productList,
      required String? paymentType,
      required String? uploadImageUrl,
      required String? paymentMethod,
      required String? countryId,
      required String? deliveryMode}) async {
    List<Map<String, dynamic>> items = [];

    // if (type == "Taobao") {
    // cartStoreModel.taobao.forEach((item) {

    // });

    for (int i = 0; i < cartStoreModel.length; i++) {
      var item = cartStoreModel[i];
      var productModel = productList[i];
      var itemData = {
        "id": "${item.id}",
        "code": "${item.id.toString()}",
        "name": "${productModel.name}",
        "cost": "${productModel.price}",
        "price": "${productModel.price}",
        "quantity": "${item.quantity}",
        "subtotal": "${grandTotal}",
        "image": "https:${productModel.image![0]}",
        "product_details": "",
        "source_type": "${type}"
      };

      items.add(itemData);
    }
    // }

    Map<String, dynamic> body = {
      "type": "${type}",
      "grand_total": "${grandTotal}",
      "items": items,
      "payment_type": "${paymentType}",
      "image_url": "${uploadImageUrl}",
      "payment_method": "${paymentMethod}",
      "country_id": "${countryId}",
      "delivery_mode": "${deliveryMode}"
    };

    String url =
        'http://delivery.anakutapp.com/anakut/public/api/checkout?address=$addressId';
    try {
      Response response = (await (apiProvider.post(url, body, null)))!;
      if (response.statusCode == 200) {
        var data = response.data;
        print("Checkout Success!");
        return data["message"].toString();
      } else {
        throw response.data["message"].toString();
      }
    } catch (e) {
      throw e;
    }
  }

  Future<KHQRResModel> reqGenerateKHQRCode(
      {required String paymentMethod,
      required String amount,
      required String type}) async {
    String url =
        'https://delivery.anakutapp.com/anakut/public/api/payment/generate_khqr';
    try {
      Map<String, dynamic> body = {
        "type": "${type}",
        "amount": "${amount}",
        "payment_method": "${paymentMethod}"
      };
      Response response = (await (apiProvider.post(url, body, null)))!;
      if (response.statusCode == 200) {
        print("response data: ${response.data}");
        return KHQRResModel.fromJson(response.data);
      } else {
        throw response.data["message"].toString();
      }
    } catch (e) {
      throw e;
    }
  }

  Future<String> checkPaymentStatusKhqr() async {
    String url =
        'https://delivery.anakutapp.com/anakut/public/api/payment/check_payment_status';
    try {
      Response response = (await (apiProvider.post(url, null, null)))!;
      if (response.statusCode == 200) {
        print("response data: ${response.data}");
        return response.data["data"]["payment_status"].toString();
      } else {
        throw response.data["message"].toString();
      }
    } catch (e) {
      throw e;
    }
  }
}
