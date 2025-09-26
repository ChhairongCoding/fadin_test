import 'package:fardinexpress/features/express/controller/express_controller.dart';
import 'package:fardinexpress/features/express/model/currency_model.dart';
import 'package:fardinexpress/features/express/model/delivery_history_model.dart';
import 'package:fardinexpress/features/taxi/model/location_detail_model.dart';
import 'package:fardinexpress/services/api_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
// import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class ExpressRepository {
  ApiProvider apiProvider = ApiProvider();

  Future<dynamic> calculateDeliveryFee(
      {required String deliveryType,
      required String senderPhone,
      required String senderLocation,
      required String senderLat,
      required String senderLong,
      required String receiverPhone,
      required String receiverLocation,
      required String receiverLat,
      required String receiverLong,
      required String note,
      required String paymentNote,
      required String total,
      required String transportId,
      required String currencyId,
      required String deliveryFee}) async {
    Map<String, dynamic> body = {
      "delivery_type": deliveryType,
      "pickup_lat": senderLat,
      "pickup_long": senderLong,
      "receiver_lat": receiverLat,
      "receiver_long": receiverLong,
      "transport_id": transportId,
    };

    String url = '${dotenv.env['baseUrl']}/delivery/calculate_price';
    try {
      var response = (await (apiProvider.post(url, body, null)))!;
      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = response.data;
        print("Add booking Success!");
        // Get.find<TaxiController>();
        return data;
        // data["data"]["grand_total"].toString();
      } else {
        throw response.data["message"].toString();
      }
    } catch (e) {
      throw e;
    }
  }

  Future<String?> createBookingLocal(
      {required String deliveryType,
      required String senderPhone,
      required String senderLocation,
      required String senderLat,
      required String senderLong,
      required String receiverPhone,
      required String receiverLocation,
      required String receiverLat,
      required String receiverLong,
      required String note,
      required String paymentNote,
      required String total,
      required String transportId,
      required String currencyId,
      required String deliveryFee,
      required String imageUrl}) async {
    Map<String, dynamic> body = {
      "delivery_type": deliveryType,
      "pickup_phone": senderPhone,
      "pickup_location": senderLocation,
      "pickup_lat": senderLat,
      "pickup_long": senderLong,
      "receiver_phone": receiverPhone,
      "receiver_location": receiverLocation,
      "receiver_lat": receiverLat,
      "receiver_long": receiverLong,
      "note": note,
      "payment_note": paymentNote,
      "total": total,
      "transport_id": transportId,
      "currency_id": currencyId,
      "delivery_fee": deliveryFee,
      "image_url": imageUrl
    };

    String url = '${dotenv.env['baseUrl']}/delivery/add';
    try {
      var response = (await (apiProvider.post(url, body, null)))!;
      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = response.data;
        print("Add booking Success!");
        // Get.find<TaxiController>();
        return data["message"].toString();
      } else {
        throw response.data["message"].toString();
      }
    } catch (e) {
      throw e;
    }
  }

  Future<String?> addCustomerRating(
      {required int starRate,
      required String customerFeedback,
      required String id}) async {
    Map<String, dynamic> body = {
      "customer_rating": starRate,
      "customer_rating_feedback": customerFeedback,
    };

    String url = '${dotenv.env['baseUrl']}/delivery/rating/$id';
    try {
      var response = (await (apiProvider.post(url, body, null)))!;
      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = response.data;
        print("Add booking Success!");
        // Get.find<TaxiController>();
        return data["message"].toString();
      } else {
        throw response.data["message"].toString();
      }
    } catch (e) {
      throw e;
    }
  }

  Future<List<DeliveryHistoryModel>> fetchDeliveryList(
      {required int? page,
      required int rowPerPage,
      required String? status,
      required String transportType}) async {
    try {
      String url =
          "${dotenv.env['baseUrl']}/deliveries?row_per_page=$rowPerPage&page=$page&status=$status&delivery_type=$transportType";
      // (transportType == "express")
      //     ? "${dotenv.env['baseUrl']}/deliveries?row_per_page=$rowPerPage&page=$page&status=$status"
      //     : "${dotenv.env['baseUrl']}/deliveries?row_per_page=$rowPerPage&page=$page&status=$status&delivery_type=$transportType";
      // https: //delivery.anakutapp.com/anakut/public/api/tracking_delivery/10306?vendor_code=anakut_buy

      var response = (await (apiProvider.get(url, null, null)))!;
      if (response.statusCode == 200) {
        var data = response.data;
        List<DeliveryHistoryModel> tempList = <DeliveryHistoryModel>[].obs;
        data["data"].forEach((item) {
          tempList.add(DeliveryHistoryModel.fromJson(item));
        });
        return tempList;
      } else {
        var data = response.data;
        throw data.toString();
      }
    } catch (e) {
      throw e;
    }
  }

  Future<List<LocationDetailModel>> fetchLocationDetailList(
      {required String? query}) async {
    String mapKey = '5b3ce3597851110001cf62487c1331c772794ab29193951acf66f2be';
    try {
      String url =
          "https://api.openrouteservice.org/geocode/autocomplete?api_key=$mapKey&text=$query&boundary.country=KH";

      var response = (await (apiProvider.get(url, null, null)))!;
      if (response.statusCode == 200) {
        var data = response.data;
        List<LocationDetailModel> tempList = <LocationDetailModel>[].obs;
        data["features"].forEach((item) {
          tempList.add(LocationDetailModel.fromJson(item));
        });
        return tempList;
      } else {
        var data = response.data;
        throw data.toString();
      }
    } catch (e) {
      throw e;
    }
  }

  Future<LatLongModel> fetchLatLngFromGoogleMap(
      {required String? mapUrl}) async {
    try {
      String url = "${dotenv.env['baseUrl']}/query_google_map";

      // request body
      Map<String, dynamic> body = {
        "url": mapUrl,
      };

      var response = (await (apiProvider.post(url, body, null)))!;
      if (response.statusCode == 200) {
        var data = response.data;

        return LatLongModel.fromJson(data);
      } else {
        var data = response.data;
        throw data.toString();
      }
    } catch (e) {
      throw e;
    }
  }

  Future<List<DeliveryHistoryModel>> fetchTaxiRidding(
      {required int? page,
      required int rowPerPage,
      required String? status,
      required String transportType}) async {
    try {
      String url =
          "${dotenv.env['baseUrl']}/deliveries?row_per_page=$rowPerPage&page=$page&delivery_type=$transportType";
      // https: //delivery.anakutapp.com/anakut/public/api/tracking_delivery/10306?vendor_code=anakut_buy

      var response = (await (apiProvider.get(url, null, null)))!;
      if (response.statusCode == 200) {
        var data = response.data["data"] as List;
        List<DeliveryHistoryModel> tempList = <DeliveryHistoryModel>[].obs;
        // data["data"].forEach((item) {
        //   tempList.add(DeliveryHistoryModel.fromJson(item));
        // });
        tempList =
            data.isNotEmpty ? [DeliveryHistoryModel.fromJson(data.first)] : [];
        return tempList;
      } else {
        var data = response.data;
        throw data.toString();
      }
    } catch (e) {
      throw e;
    }
  }

  Future<DeliveryHistoryModel> trackDeliveryById({required String id}) async {
    try {
      String url =
          "${dotenv.env['baseUrl']}/tracking_delivery/$id?vendor_code=anakut_buy";

      var response = (await (apiProvider.get(url, null, null)))!;
      if (response.statusCode == 200) {
        var data = response.data["data"];
        return DeliveryHistoryModel.fromJson(data);
      } else {
        var data = response.data;
        throw data.toString();
      }
    } catch (e) {
      throw e;
    }
  }

  Future<List<CurrencyModel>> fetchCurrencies(int page, int rowPerPage) async {
    String baseUrl =
        "${dotenv.env['baseUrl']}/currencies?row_per_page=$rowPerPage&page=$page";
    String url = baseUrl;
    try {
      var response = (await (apiProvider.get(url, null, null)))!;
      if (response.statusCode == 200) {
        var data = response.data;
        List<CurrencyModel> zoneList = [];
        data["data"].forEach((item) {
          zoneList.add(CurrencyModel.fromJson(item));
        });
        return zoneList;
      }
      var data = response.data;
      throw Exception(data["message"].toString());
    } catch (e) {
      throw Exception(e);
    }
  }
}
