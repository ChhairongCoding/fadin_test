import 'package:fardinexpress/features/app/extend_app_logistic/utils/helper/data_validator.dart';

class Operation {
  final String nameKh;
  final String nameEn;
  final String date;
  factory Operation.fromJson(Map<String, dynamic> json) {
    return Operation(
        nameKh: validate("name_kh", json["name_kh"]),
        nameEn: validate("name", json["name"]),
        date: validate("date", json["date"]));
  }
  Operation({required this.nameEn, required this.nameKh, required this.date});
}
