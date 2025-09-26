class DistrictModel {
  final String? disId;
  final String? disNameKH;
  final String? disNameENG;
  final String? disFee;

  DistrictModel({
    required this.disId,
    required this.disNameKH,
    required this.disNameENG,
    required this.disFee,
  });

  factory DistrictModel.fromJson(Map<String, dynamic> json) {
    return DistrictModel(
        disId: json['DisID'].toString(),
        disNameKH: json['DisName_KH'].toString(),
        disNameENG: json['DisName_ENG'].toString(),
        disFee: json['service_fee'].toString());
  }
}
