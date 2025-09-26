import 'package:fardinexpress/features/app/extend_app_logistic/utils/helper/data_validator.dart';

class Item {
  final String name;
  final String? type;
  final String? cbm;
  final String? price;
  final String? quantity;
  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      name: validate("name", json["name"]),
      price: json["price"] == null ? null : json["price"].toString(),
      cbm: json["weight_cbm"] == null ? null : json["weight_cbm"].toString(),
      type: json["type"],
      quantity: json["quantity"] == null ? null : json["quantity"].toString(),
    );
  }
  Item(
      {required this.name,
      required this.type,
      required this.cbm,
      required this.price,
      required this.quantity});
}
