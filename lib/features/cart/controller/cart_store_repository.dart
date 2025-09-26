import 'package:dio/dio.dart';
import 'package:fardinexpress/features/cart/model/cart_store_model.dart';
import 'package:fardinexpress/services/api_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CartStoreRepository {
  ApiProvider apiProvider = ApiProvider();

  final allStores = ["taobao", "1688", "amazon", "lazada", "fardin"];

  // Future<List<CartStoreModel>> fetchCartStoreList() async {
  //   String url = "${dotenv.env['baseUrl']}/cart/stores";
  //   try {
  //     Response response = (await (apiProvider.get(url, null, null)))!;
  //     if (response.statusCode == 200) {
  //       var data = response.data;
  //       // print(data.toString());
  //       List<CartStoreModel> cartStoreModel = [];
  //       var cartTotal = data['total'].toString();
  //       data["data"].forEach((store) {
  //         List<CartStoreItem> cartStoreItem = [];
  //         store['cart'].forEach((item) {
  //           cartStoreItem.add(CartStoreItem(
  //               id: item['id'],
  //               name: item['name'].toString(),
  //               price: item['price'].toString(),
  //               quantity: item['quantity'].toString(),
  //               image: item['image'].toString(),
  //               code: "12312312",
  //               grandTotal: item['grand_total'].toString(),
  //               cost: "1212",
  //               productDetail: "productDetail"));
  //         });
  //         cartStoreModel.add(CartStoreModel(
  //             id: store['id'],
  //             name: store['name'].toString(),
  //             address: store['address'].toString(),
  //             phone: store['phone'].toString(),
  //             grandTotal: store['grand_total'].toString(),
  //             total: store['total'].toString(),
  //             deliveryFee: store['delivery_fee'].toString(),
  //             item: cartStoreItem));
  //       });
  //       return cartStoreModel;
  //     }
  //     throw response.data["message"].toString();
  //   } catch (e) {
  //     throw e;
  //   }
  // }

  Future<CartStoreModel> fetchCartStoreList() async {
    String url = "${dotenv.env['baseUrl']}/cart?type=external";
    String urlProduct = "${dotenv.env['baseUrl']}/cart";
    try {
      Response response = (await (apiProvider.get(url, null, null)))!;

      if (response.statusCode == 200) {
        var data = response.data;
        return CartStoreModel.fromJson(data);
      }
      throw response.data["message"].toString();
    } catch (e) {
      throw e;
    }
  }

  Future<String> removeCartItem(
      {required String productId,
      required String store,
      required String cartId}) async {
    // dotenv.env['baseUrl']}/cart/remove/$productId?variant_id=$variantId
    String url = "${dotenv.env['baseUrl']}/cart/remove/$cartId?type=$store";
    dynamic body;
    try {
      Response response = (await (apiProvider.delete(url, body)))!;
      if (response.statusCode == 200) {
        var data = response.data["message"].toString();
        return data;
      }
      throw response.data["message"].toString();
    } catch (e) {
      throw e;
    }
  }

  Future<String> putQuantity(
      {required String productId, required String quantity}) async {
    String url = "${dotenv.env['baseUrl']}/cart/update/$productId";
    dynamic body = {"quantity": quantity};
    try {
      Response response = (await (apiProvider.put(url, body)))!;
      if (response.statusCode == 200) {
        var data = response.data["message"].toString();
        return data;
      }
      throw response.data["message"].toString();
    } catch (e) {
      throw e;
    }
  }
}
