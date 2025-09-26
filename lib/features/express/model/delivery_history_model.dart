import 'dart:developer';

import 'package:fardinexpress/features/app/extend_app_logistic/feature/delivery/models/operation.dart';

class DeliveryHistoryModel {
  final String? id;
  final String? total;
  final String? date;
  final String senderAddress;
  final String senderPhone;
  final double pickupLat;
  final double pickupLong;
  final String receiverAddress;
  final String receiverPhone;
  final double receiverLat;
  final double receiverLong;
  final String packagePrice;
  final String note;
  final String paymentNote;
  final String status;
  final String deliveryImage;
  final String deliveryFee;
  final String deliveryType;
  final String totalService;
  final String otherFee;
  final String currency;
  final String grandTotal;
  final String driverId;
  final String driverName;
  final String driverPhone;
  final String duration;
  final String distance;
  final String customerRating;
  final String transportType;
  final List<Operation> operations;

  factory DeliveryHistoryModel.fromJson(Map<String, dynamic> json) {
    final List<Operation> tempOperations = [];
    try {
      json["delivery_process_operations"].forEach((data) {
        tempOperations.add(Operation.fromJson(data));
      });
    } catch (e) {
      log("key 'delivery_process_operations' is null or not array");
    }
    return DeliveryHistoryModel(
        id: json["id"].toString(),
        total: json["total"].toString(),
        date: json["date"].toString(),
        senderAddress: json["pickup_location"].toString(),
        senderPhone: json["pickup_phone"].toString(),
        pickupLat: json["pickup_lat"].toString() == "null" ||
                json["pickup_lat"].toString() == ""
            ? 0
            : double.parse(json["pickup_lat"]),
        pickupLong: json["pickup_long"].toString() == "null" ||
                json["pickup_long"].toString() == ""
            ? 0
            : double.parse(json["pickup_long"]),
        receiverAddress: json["receiver_location"].toString(),
        receiverPhone: json["receiver_phone"].toString(),
        receiverLat: json["receiver_lat"].toString() == "null" ||
                json["receiver_lat"].toString() == ""
            ? 0
            : double.parse(json["receiver_lat"]),
        receiverLong: json["receiver_long"].toString() == "null" ||
                json["receiver_long"].toString() == ""
            ? 0
            : double.parse(json["receiver_long"]),
        packagePrice: json["total_collect_from"].toString(),
        note: json["note"].toString(),
        paymentNote: json["payment_note"].toString(),
        status: json["status"].toString(),
        deliveryImage: json["image_url"].toString(),
        deliveryFee: json["service_fee"].toString(),
        deliveryType: json["delivery_type"].toString(),
        totalService: json["total_service"].toString(),
        otherFee: json["other_service_fee"].toString(),
        currency: json["currency_symbol"].toString(),
        grandTotal: json["grand_total"].toString(),
        driverId: json["delivery_driver"] == null
            ? ""
            : json["delivery_driver"]["id"].toString(),
        driverName: json["delivery_driver"] == null
            ? ""
            : json["delivery_driver"]["name"].toString(),
        driverPhone: json["delivery_driver"] == null
            ? ""
            : json["delivery_driver"]["phone"].toString(),
        duration: json["duration"].toString(),
        distance: json["distance"].toString(),
        customerRating: json["customer_rating"].toString(),
        transportType: json["transport"] == null
            ? ""
            : json["transport"]["name"].toString(),
        operations: tempOperations);
  }
  DeliveryHistoryModel(
      {required this.id,
      required this.total,
      required this.date,
      required this.senderAddress,
      required this.senderPhone,
      required this.pickupLat,
      required this.pickupLong,
      required this.receiverAddress,
      required this.receiverPhone,
      required this.receiverLat,
      required this.receiverLong,
      required this.packagePrice,
      required this.note,
      required this.paymentNote,
      required this.status,
      required this.deliveryImage,
      required this.deliveryFee,
      required this.deliveryType,
      required this.totalService,
      required this.otherFee,
      required this.currency,
      required this.grandTotal,
      required this.operations,
      required this.driverId,
      required this.driverName,
      required this.driverPhone,
      required this.duration,
      required this.distance,
      required this.customerRating,
      required this.transportType});
}
