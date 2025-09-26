class Info {
  final String id;
  final String link;
  final String title;
  factory Info.fromJson(Map<String, dynamic> json) {
    return Info(
        id: json["id"].toString(),
        title: json["title"].toString(),
        link: json["content"].toString());
  }
  Info({required this.id, required this.link, required this.title});
}
