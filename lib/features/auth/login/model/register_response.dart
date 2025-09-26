class UserResponseModel {
  final String? name;
  final String? token;
  final String? phone;
  UserResponseModel({
    required this.name,
    required this.token,
    required this.phone,
  });

  factory UserResponseModel.fromJson(Map<String, dynamic> json) {
    return UserResponseModel(
        name: json["user"]["name"].toString(),
        token: json["token"].toString(),
        phone: json["user"]["phone"].toString());
  }
}
