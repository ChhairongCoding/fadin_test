class NotificationModel {
  final String id;
  // final String title;
  final String body;
  final String date;
  // final String? target;
  // final String? targetValue;
  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
        id: json["id"].toString(),
        // title: json["title"].toString(),
        body: json["comment"].toString(),
        date: json["date"]);
    // target: json["target"],
    // targetValue: json["target_value"] == null
    //     ? null
    //     : json["target_value"].toString());
  }
  NotificationModel({
    required this.id,
    // required this.title,
    required this.body,
    required this.date,
    // required this.target,
    // required this.targetValue
  });
}
