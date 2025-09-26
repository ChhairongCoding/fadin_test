class User {
  final String? id;
  final String name;
  final String phone;
  final String address;
  final String? bankAccount;

  String? verifyStatus;
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json["id"].toString(),
        name: json["name"],
        phone: json["phone"].toString(),
        address: json["address"].toString(),
        verifyStatus: json["verify_status"],
        bankAccount: json["bank_account"].toString());
    //
    // address: json["address"] == null || json["address"].length == 0
    //     ? null
    //     : Address.fromJson(json["address"]));
  }
  User(
      {required this.id,
      required this.name,
      required this.phone,
      required this.address,
      required this.verifyStatus,
      required this.bankAccount});
}
