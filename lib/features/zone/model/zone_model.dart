class ZoneModel {
  final String id;
  final String code;
  final String name;
  final String fee;
  final String lat;
  final String long;

  factory ZoneModel.fromJson(Map<String, dynamic> json) {
    return ZoneModel(
        id: json["id"].toString(),
        code: json["code"].toString(),
        name: json["name"].toString(),
        fee: json["service_fee"].toString(),
        lat: json["lat"].toString(),
        long: json["long"].toString());
    //
    // address: json["address"] == null || json["address"].length == 0
    //     ? null
    //     : Address.fromJson(json["address"]));
  }
  ZoneModel({
    required this.id,
    required this.name,
    required this.code,
    required this.fee,
    required this.lat,
    required this.long,
  });
}
