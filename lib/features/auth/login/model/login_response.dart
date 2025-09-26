class LoginResponseModel {
  final String? token;
  final String? phone;
  LoginResponseModel({required this.token, required this.phone});

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
        token: json["token"].toString(),
        phone: json["user"]["phone"].toString());
  }
}
