class WarehouseAddress {
  final String name;
  final String phone;
  // final String zipCode;
  final String warehouseAddress;
  // final String? province;
  // final String? subDistrict;
  // final String? note;
  final String? image;
  factory WarehouseAddress.fromJson(Map<String, dynamic> json) {
    return WarehouseAddress(
        name: json["name"].toString(),
        phone: json["phone"].toString(),
        // zipCode: json["zip_code"] == null ? "" : json["zip_code"].toString(),
        warehouseAddress: json["address"].toString(),
        // province: json["province"] == null || json["province"] == ""
        //     ? null
        //     : json["province"].toString(),
        // subDistrict: json["sub_district"] == null || json["sub_district"] == ""
        //     ? null
        //     : json["sub_district"].toString(),
        // note: json["note"].toString(),
        image: json["image"].toString());
  }
  WarehouseAddress(
      {required this.name,
      required this.phone,
      // required this.zipCode,
      required this.warehouseAddress,
      // required this.province,
      // required this.subDistrict,
      // required this.note,
      required this.image});
}
