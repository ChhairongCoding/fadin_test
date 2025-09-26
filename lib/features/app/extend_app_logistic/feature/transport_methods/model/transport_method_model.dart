class TransportMothodModel {
  final String name;
  final String description;
  factory TransportMothodModel.fromJson(Map<String, dynamic> json) {
    return TransportMothodModel(
      name: json['name'].toString(),
      description: json['description'].toString(),
    );
  }
  TransportMothodModel({required this.name, required this.description});
}
