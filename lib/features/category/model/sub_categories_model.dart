class SubCategoryModel {
  final int? id;
  final String? code;
  final String? name;
  final String? image;

  SubCategoryModel({
    required this.id,
    required this.code,
    required this.name,
    required this.image,
  });

  factory SubCategoryModel.fromJson(Map<String, dynamic> json) {
    return SubCategoryModel(
      id: json['id'],
      code: json['code'].toString(),
      name: json['name'].toString(),
      image: json['image'].toString(),
    );
  }

  // bool userFilterByName(String filter) {
  //   return this.name.toString().contains(filter);
  // }
}

