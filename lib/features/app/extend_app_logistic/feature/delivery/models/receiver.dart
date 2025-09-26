import 'package:fardinexpress/features/app/extend_app_logistic/utils/helper/data_validator.dart';

class Receiver {
  final String name;
  final String phone;
  final String address;
  factory Receiver.fromJson(Map<String, dynamic> json) {
    return Receiver(
        name: json["receiver_name"] == null ? "" : json["receiver_name"],
        phone: validate("receiver_phone", json["receiver_phone"]).toString(),
        address: validate("receiver_location", json["receiver_location"]));
  }
  Receiver({required this.name, required this.phone, required this.address});
}
