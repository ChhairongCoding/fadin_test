class ProvinceModel {
  final String? proId;
  final String? proNameKH;
  final String? proNameENG;
  final String identityCode;

  ProvinceModel(
      {required this.proId,
      required this.proNameKH,
      required this.proNameENG,
      required this.identityCode});

  factory ProvinceModel.fromJson(Map<String, dynamic> json) {
    return ProvinceModel(
        proId: json['ProId'].toString(),
        proNameKH: json['ProName_KH'].toString(),
        proNameENG: json['ProName_ENG'].toString(),
        identityCode: json['identify_code'].toString());
  }
}
