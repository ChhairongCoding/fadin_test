class AddressModel {
  final String? id;
  final String name;
  final String lat;
  final String long;
  final String defaultAddress;
  final String description;
  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
        id: json["id"].toString(),
        name: json["name"].toString(),
        lat: json["lat"].toString(),
        long: json["long"].toString(),
        defaultAddress: json["default"].toString(),
        description: json["description"].toString());
  }
  AddressModel(
      {required this.id,
      required this.name,
      required this.lat,
      required this.long,
      required this.defaultAddress,
      required this.description});
}
