class ConfirmOtpForgotModel {
  final String message;
  final int reference;

  ConfirmOtpForgotModel({required this.message, required this.reference});

  factory ConfirmOtpForgotModel.fromJson(Map<String, dynamic> json) {
    return ConfirmOtpForgotModel(
        message: json['message'].toString(), reference: json['reference']);
  }
}
