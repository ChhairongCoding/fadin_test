import 'dart:developer';

import 'package:fardinexpress/features/app/extend_app_logistic/feature/delivery/models/item.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/feature/delivery/models/operation.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/utils/helper/data_validator.dart';
import 'receiver.dart';
import 'sender.dart';

class Delivery {
  final String id;
  final String code;
  final Sender? sender;
  final Receiver? receiver;
  final List<Item> itemList;
  final String createDate;
  final String? arriveDate;
  final String deliveryFrom;
  final String deliveryFromImage;
  final String note;
  final String? total;
  final String status;
  final String? width;
  final String? weight;
  final String? height;
  final String? length;
  final List<Operation> history;
  factory Delivery.fromJson(Map<String, dynamic> json) {
    // List<String> productNameList = [];
    List<Item> _itemList = [];

    // String _product = "";

    json["delviery_process_items"].forEach((data) {
      _itemList.add(Item.fromJson(data));
      // productNameList.add(data["name"]);
    });
    // _product = Helper.connectString(productNameList);
    final List<Operation> tempHistory = [];
    try {
      json["delivery_process_operations"].forEach((data) {
        tempHistory.add(Operation.fromJson(data));
      });
    } catch (e) {
      log("key 'delivery_process_operations' is null or not array");

      // throw "key 'delivery_process_operations' is null or not array";
    }

    return Delivery(
        id: json["id"].toString(),
        code: json["id"].toString(),
        sender: json["pickup_name"] == null ? null : Sender.fromJson(json),
        receiver:
            json["receiver_name"] == null ? null : Receiver.fromJson(json),
        itemList: _itemList,
        createDate: validate("date", json["date"]),
        arriveDate: json["delivery_date"] == null ? "" : json["delivery_date"],
        deliveryFrom: json["sender_country"]["name"].toString(),
        deliveryFromImage: json["sender_country"]["image"].toString(),
        note: json["note"].toString(),
        total: json["total_service"] == null || json["total_service"] == ""
            ? null
            : json["total_service"].toString(),
        status: json["status"].toString(),
        width: "1",
        weight: "1",
        height: "1",
        length: "1",
        history: tempHistory);
  }
  Delivery({
    required this.id,
    required this.code,
    required this.sender,
    required this.receiver,
    required this.itemList,
    required this.createDate,
    required this.arriveDate,
    required this.deliveryFrom,
    required this.deliveryFromImage,
    required this.note,
    required this.total,
    required this.status,
    required this.height,
    required this.weight,
    required this.width,
    required this.length,
    required this.history,
  });
}
