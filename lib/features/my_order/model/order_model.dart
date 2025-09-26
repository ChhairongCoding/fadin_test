class OrderModel {
  final String? id;
  final String? total;
  final String? date;
  final String address;
  final String status;
  final WarehouseModel warehouseDetail;

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json["id"].toString(),
      total: json["total"].toString(),
      date: json["date"].toString(),
      address: json["address"].toString(),
      status: json["status"].toString(),
      warehouseDetail:
          WarehouseModel.fromJson(json["warehouse"] as Map<String, dynamic>),
    );
  }
  OrderModel({
    required this.id,
    required this.total,
    required this.date,
    required this.address,
    required this.status,
    required this.warehouseDetail,
  });
}

class WarehouseModel {
  final String? id;
  final String? code;
  final String? name;
  final String address;
  final String phone;
  final String email;
  final String status;
  final String image;
  final String map;

  factory WarehouseModel.fromJson(Map<String, dynamic> json) {
    return WarehouseModel(
      id: json["id"].toString(),
      code: json["code"].toString(),
      name: json["name"].toString(),
      address: json["address"].toString(),
      phone: json["phone"].toString(),
      email: json["email"].toString(),
      status: json["status"].toString(),
      image: json["image"].toString(),
      map: json["map"].toString(),
    );
  }
  WarehouseModel(
      {required this.id,
      required this.code,
      required this.name,
      required this.address,
      required this.phone,
      required this.email,
      required this.status,
      required this.image,
      required this.map});
}
