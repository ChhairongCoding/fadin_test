class OrderDetailModel {
  final String? id;
  final String? total;
  final String? date;
  final String address;
  final String status;
  final String? grandTotal;
  final String? shippingFee;
  final String estimateTime;
  final String? paymentType;
  final List<ItemOrderDetailModel> itemDetail;
  final WarehouseOrderDetailModel warehouseDetail;

  factory OrderDetailModel.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List;
    List<ItemOrderDetailModel> itemDetailList =
        list.map((i) => ItemOrderDetailModel.fromJson(i)).toList();
    return OrderDetailModel(
      id: json["id"].toString(),
      total: json["total"].toString(),
      date: json["date"].toString(),
      address: json["address"].toString(),
      status: json["status"].toString(),
      grandTotal: json["grand_total"].toString(),
      shippingFee: json["delivery_fee"].toString(),
      estimateTime: json["estimate_time"].toString(),
      paymentType: json["payment_type"].toString(),
      warehouseDetail: WarehouseOrderDetailModel.fromJson(
          json["warehouse"] as Map<String, dynamic>),
      itemDetail: itemDetailList,
    );
  }
  OrderDetailModel({
    required this.id,
    required this.total,
    required this.date,
    required this.address,
    required this.status,
    required this.grandTotal,
    required this.shippingFee,
    required this.estimateTime,
    required this.paymentType,
    required this.warehouseDetail,
    required this.itemDetail,
  });
}

class WarehouseOrderDetailModel {
  final String? id;
  final String? code;
  final String? name;
  final String address;
  final String phone;
  final String email;
  final String status;
  final String image;
  final String map;

  factory WarehouseOrderDetailModel.fromJson(Map<String, dynamic> json) {
    return WarehouseOrderDetailModel(
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
  WarehouseOrderDetailModel(
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

class ItemOrderDetailModel {
  final String? id;
  final String? productId;
  final String? qty;
  final String? name;
  final String? price;
  final String cost;
  final String image;

  factory ItemOrderDetailModel.fromJson(Map<String, dynamic> json) {
    return ItemOrderDetailModel(
      id: json["id"].toString(),
      productId: json["product_id"].toString(),
      qty: json["quantity"].toString(),
      name: json["product_name"].toString(),
      price: json["product_price"].toString(),
      cost: json["product_cost"].toString(),
      image: json["image"].toString(),
    );
  }
  ItemOrderDetailModel(
      {required this.id,
      required this.productId,
      required this.qty,
      required this.name,
      required this.price,
      required this.cost,
      required this.image});
}
