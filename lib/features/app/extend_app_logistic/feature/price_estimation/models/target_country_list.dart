class TargetCountryModel {
  final String id;
  final String code;
  final String name;
  factory TargetCountryModel.fromJson(Map<String, dynamic> json) {
    return TargetCountryModel(
      id: json["id"].toString(),
      code: json["code"].toString(),
      name: json["name"].toString(),
    );
  }
  TargetCountryModel(
      {required this.id, required this.code, required this.name});
}
