import 'package:fardinexpress/features/app/extend_app_logistic/utils/helper/data_validator.dart';

class Sender {
  final String name;
  final String phone;
  final String address;
  factory Sender.fromJson(Map<String, dynamic> json) {
    return Sender(
        name: json["pickup_name"] == null ? "" : json["pickup_name"],
        phone: validate("pickup_phone", json["pickup_phone"]).toString(),
        address: validate("pickup_location", json["pickup_location"]));
  }
  Sender({required this.name, required this.phone, required this.address});
}
