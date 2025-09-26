class InfoCategory {
  final String id;
  final String name;

  factory InfoCategory.fromJson(Map<String, dynamic> json) {
    return InfoCategory(
      id: json["id"].toString(),
      name: json["name"],
    );
  }
  InfoCategory({
    required this.id,
    required this.name,
  });
}
