class AccountModel {
  final String id;
  final String name;
  final String phone;
  final String profilePic;
  final String total;
  final AddressProfile address;
  String? verifyStatus;
  final String bankNumber;

  factory AccountModel.fromJson(Map<String, dynamic> json) {
    return AccountModel(
      id: json["id"].toString(),
      name: json["name"].toString(),
      phone: json["phone"].toString(),
      total: json["total"].toString(),
      profilePic: json["image"].toString(),
      address: AddressProfile.fromJson(json["address"] as Map<String, dynamic>),
      verifyStatus: json["verify_status"],
      bankNumber: json["account_number"].toString(),
    );
    //
    // address: json["address"] == null || json["address"].length == 0
    //     ? null
    //     : Address.fromJson(json["address"]));
  }
  AccountModel(
      {required this.id,
      required this.name,
      required this.phone,
      required this.address,
      required this.profilePic,
      required this.verifyStatus,
      required this.total,
      required this.bankNumber});
}

class AddressProfile {
  final String id;
  final String name;
  final String lat;
  final String long;
  final String description;

  String? verifyStatus;
  factory AddressProfile.fromJson(Map<String, dynamic> json) {
    return AddressProfile(
        id: json["id"].toString(),
        name: json["name"].toString(),
        lat: json["lat"].toString(),
        long: json["long"].toString(),
        description: json["description"].toString());
    //
    // address: json["address"] == null || json["address"].length == 0
    //     ? null
    //     : Address.fromJson(json["address"]));
  }
  AddressProfile(
      {required this.id,
      required this.name,
      required this.lat,
      required this.long,
      required this.description});
}
