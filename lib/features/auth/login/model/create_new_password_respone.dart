class CreateNewPasswordResponse {
  final String? name;
  final String? token;
  final String? phone;
  CreateNewPasswordResponse({
    required this.name,
    required this.token,
    required this.phone,
  });

  factory CreateNewPasswordResponse.fromJson(Map<String, dynamic> json) {
    return CreateNewPasswordResponse(
        name: json["user"]["name"].toString(),
        token: json["token"].toString(),
        phone: json["user"]["phone"].toString());
  }
}
