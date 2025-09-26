class CurrencyModel {
  final String id;
  final String code;
  final String name;
  final String rate;
  final String symbol;
  final String vendor_id;

  factory CurrencyModel.fromJson(Map<String, dynamic> json) {
    return CurrencyModel(
        id: json["id"].toString(),
        code: json["code"].toString(),
        name: json["name"].toString(),
        rate: json["rate"].toString(),
        symbol: json["symbol"].toString(),
        vendor_id: json["vendor_id"].toString());
    //
    // address: json["address"] == null || json["address"].length == 0
    //     ? null
    //     : Address.fromJson(json["address"]));
  }
  CurrencyModel({
    required this.id,
    required this.name,
    required this.code,
    required this.rate,
    required this.symbol,
    required this.vendor_id,
  });
}
