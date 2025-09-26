class SearchHistory {
  final String id;
  final String text;

  SearchHistory({required this.id, required this.text});
  factory SearchHistory.fromJson(Map<String, dynamic> json) {
    return SearchHistory(id: json["id"].toString(), text: json["text"]);
  }
}
