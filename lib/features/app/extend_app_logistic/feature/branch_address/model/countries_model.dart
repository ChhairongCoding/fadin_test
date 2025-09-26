class CountriesModel {
  final String? id;
  final String? name;
  final String? code;
  final String image;
  final String status;
  final String kiloPrice;
  final String volPrice;
  final String? vendorId;
  final String? serviceFee;

  CountriesModel(
      {required this.id,
      required this.code,
      required this.name,
      required this.image,
      required this.status,
      required this.kiloPrice,
      required this.volPrice,
      required this.vendorId,
      required this.serviceFee});

  factory CountriesModel.fromJson(Map<String, dynamic> json) {
    return CountriesModel(
        id: json['id'].toString(),
        code: json['code'].toString(),
        name: json['name'].toString(),
        image: json['image'].toString(),
        status: json['status'].toString(),
        kiloPrice: json['kilo_price'].toString(),
        volPrice: json['vol_price'].toString(),
        vendorId: json['vendor_id'].toString(),
        serviceFee: json['service_fee'].toString());
  }
}
