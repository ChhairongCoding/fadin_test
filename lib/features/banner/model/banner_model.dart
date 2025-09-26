class BannerModel {
  final int? id;
  final String? name;
  final String? image;
  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
        id: json["id"],
        name: json["name"].toString(),
        image: json["image"].toString());
  }
  BannerModel({
    required this.id,
    required this.name,
    required this.image,
  });
}
