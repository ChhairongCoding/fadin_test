class TransportModel {
  final int? id;
  final String? name;
  final String? price;
  final String image;

  TransportModel(
      {required this.id,
      required this.name,
      required this.price,
      required this.image});

  factory TransportModel.fromJson(Map<String, dynamic> json) {
    return TransportModel(
        id: json['id'],
        name: json['name'].toString(),
        price: json['price'].toString(),
        image: json['image_url'].toString());
  }
}
