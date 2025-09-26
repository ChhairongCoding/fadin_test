class KHQRResModel {
  final int code;
  final String message;
  final String qrCodeUrl;

  KHQRResModel(
      {required this.code, required this.message, required this.qrCodeUrl});

  factory KHQRResModel.fromJson(Map<String, dynamic> json) {
    return KHQRResModel(
      code: json['code'],
      message: json['message'].toString(),
      qrCodeUrl: json['data']['qr_code_url'].toString(),
    );
  }
}
