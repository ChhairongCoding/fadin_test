class ForgotPasswordResponse {
  final String? message;
  final int? reference;

  ForgotPasswordResponse({required this.message, required this.reference});

  factory ForgotPasswordResponse.fromJson(Map<String, dynamic> json) {
    return ForgotPasswordResponse(
        message: json['message'].toString(), reference: json['reference']);
  }
}
