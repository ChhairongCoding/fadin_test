class WalletTransactionModel {
  final String id;
  final String userId;
  final String requestDate;
  final String? payMethod;
  final String? tranStatus;
  final String? userBalance;
  final String? tranType;
  final String? amount;
  final String? referNo;

  String? verifyStatus;
  factory WalletTransactionModel.fromJson(Map<String, dynamic> json) {
    return WalletTransactionModel(
        id: json["id"].toString(),
        userId: json["user_id"].toString(),
        userBalance: json["user_balance"].toString(),
        requestDate: json["request_date"].toString(),
        payMethod: json["payment_method"].toString(),
        tranStatus: json["transaction_status"].toString(),
        tranType: json["type"].toString(),
        amount: json["amount"].toString(),
        referNo: json["reference_no"].toString());
    //
    // address: json["address"] == null || json["address"].length == 0
    //     ? null
    //     : Address.fromJson(json["address"]));
  }
  WalletTransactionModel(
      {required this.id,
      required this.userBalance,
      required this.requestDate,
      required this.payMethod,
      required this.tranStatus,
      required this.userId,
      required this.tranType,
      required this.amount,
      required this.referNo});
}
