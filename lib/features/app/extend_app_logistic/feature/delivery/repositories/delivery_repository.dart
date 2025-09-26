// import 'dart:developer';

// import 'package:chs/src/features/delivery/models/delivery.dart';
// import 'package:chs/src/utils/services/api_provider.dart';
// import 'package:dio/dio.dart';

// class DeliveryRepository {
//   Future<Delivery> requestDelivery(
//       {required String deliveryId, required String address}) async {
//     ApiProvider apiProvider = ApiProvider();
//     try {
//       final String url =
//           "http://chs.anakutjobs.com/anakut/public/api/order/request/$deliveryId";
//       Response response = (await apiProvider.post(
//           url, '{"request_delivery_address":"$address"}', null))!;
//       //log(response.data["data"].toString());
//       Delivery delivery = Delivery.fromJson(response.data["data"]);
//       return delivery;
//     } catch (e) {
//       throw e;
//     }
//   }
// }
