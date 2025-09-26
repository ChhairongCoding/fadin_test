class CartStoreModel {
  List<CartStoreItem> taobao;
  List<CartStoreItem> from1688;
  List<CartStoreItem> amazon;
  List<CartStoreItem> lazada;
  List<CartStoreItem> fardin;
  List<CartStoreItem> amazonau;
  List<CartStoreItem> lazadavn;
  List<CartStoreItem> amazonfr;
  List<CartStoreItem> amazonin;
  List<CartStoreItem> amazonit;
  List<CartStoreItem> amazonde;
  List<CartStoreItem> amazonae;
  List<CartStoreItem> amazonjp;
  List<CartStoreItem> lazadath;
  List<CartStoreItem> lazadasg;
  List<CartStoreItem> lazadaid;
  List<CartStoreItem> lazadamy;
  List<CartStoreItem> lazadaph;

  CartStoreModel(
      {required this.taobao,
      required this.from1688,
      required this.amazon,
      required this.lazada,
      required this.fardin,
      required this.amazonau,
      required this.lazadavn,
      required this.amazonfr,
      required this.amazonin,
      required this.amazonit,
      required this.amazonde,
      required this.amazonae,
      required this.amazonjp,
      required this.lazadath,
      required this.lazadasg,
      required this.lazadaid,
      required this.lazadamy,
      required this.lazadaph});

  factory CartStoreModel.fromJson(Map<String, dynamic> json) {
    return CartStoreModel(
      taobao: json['taobao'] == null
          ? []
          : (json['taobao'] as List)
              .map((i) => CartStoreItem.fromJson(i))
              .toList(),
      from1688: json['1688'] == null
          ? []
          : (json['1688'] as List)
              .map((i) => CartStoreItem.fromJson(i))
              .toList(),
      amazon: json['amazon'] == null
          ? []
          : (json['amazon'] as List)
              .map((i) => CartStoreItem.fromJson(i))
              .toList(),
      lazada: json['lazada'] == null
          ? []
          : (json['lazada'] as List)
              .map((i) => CartStoreItem.fromJson(i))
              .toList(),
      fardin: json['fardin'] == null
          ? []
          : (json['fardin'] as List)
              .map((i) => CartStoreItem.fromJson(i))
              .toList(),
      amazonau: json['amazonau'] == null
          ? []
          : (json['amazonau'] as List)
              .map((i) => CartStoreItem.fromJson(i))
              .toList(),
      lazadavn: json['lazadavn'] == null
          ? []
          : (json['lazadavn'] as List)
              .map((i) => CartStoreItem.fromJson(i))
              .toList(),
      amazonfr: json['amazonfr'] == null
          ? []
          : (json['amazonfr'] as List)
              .map((i) => CartStoreItem.fromJson(i))
              .toList(),
      amazonin: json['amazonin'] == null
          ? []
          : (json['amazonin'] as List)
              .map((i) => CartStoreItem.fromJson(i))
              .toList(),
      amazonit: json['amazonit'] == null
          ? []
          : (json['amazonit'] as List)
              .map((i) => CartStoreItem.fromJson(i))
              .toList(),
      amazonde: json['amazonde'] == null
          ? []
          : (json['amazonde'] as List)
              .map((i) => CartStoreItem.fromJson(i))
              .toList(),
      amazonae: json['amazonae'] == null
          ? []
          : (json['amazonae'] as List)
              .map((i) => CartStoreItem.fromJson(i))
              .toList(),
      amazonjp: json['amazonjp'] == null
          ? []
          : (json['amazonjp'] as List)
              .map((i) => CartStoreItem.fromJson(i))
              .toList(),
      lazadath: json['lazadath'] == null
          ? []
          : (json['lazadath'] as List)
              .map((i) => CartStoreItem.fromJson(i))
              .toList(),
      lazadasg: json['lazadasg'] == null
          ? []
          : (json['lazadasg'] as List)
              .map((i) => CartStoreItem.fromJson(i))
              .toList(),
      lazadaid: json['lazadaid'] == null
          ? []
          : (json['lazadaid'] as List)
              .map((i) => CartStoreItem.fromJson(i))
              .toList(),
      lazadamy: json['lazadamy'] == null
          ? []
          : (json['lazadamy'] as List)
              .map((i) => CartStoreItem.fromJson(i))
              .toList(),
      lazadaph: json['lazadaph'] == null
          ? []
          : (json['lazadaph'] as List)
              .map((i) => CartStoreItem.fromJson(i))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'taobao': taobao.map((e) => e.toJson()).toList(),
      // '1688': from1688.map((e) => e.toJson()).toList(),
      '1688': from1688.map((e) => e.toJson()).toList(),
      'amazon': amazon.map((e) => e.toJson()).toList(),
      'lazada': lazada.map((e) => e.toJson()).toList(),
      'fardin': fardin.map((e) => e.toJson()).toList(),
      'amazonau': amazonau.map((e) => e.toJson()).toList(),
      'lazadavn': lazadavn.map((e) => e.toJson()).toList(),
      'amazonfr': amazonfr.map((e) => e.toJson()).toList(),
      'amazonin': amazonin.map((e) => e.toJson()).toList(),
      'amazonit': amazonit.map((e) => e.toJson()).toList(),
      'amazonde': amazonde.map((e) => e.toJson()).toList(),
      'amazonae': amazonae.map((e) => e.toJson()).toList(),
      'amazonjp': amazonjp.map((e) => e.toJson()).toList(),
      'lazadath': lazadath.map((e) => e.toJson()).toList(),
      'lazadasg': lazadasg.map((e) => e.toJson()).toList(),
      'lazadaid': lazadaid.map((e) => e.toJson()).toList(),
      'lazadamy': lazadamy.map((e) => e.toJson()).toList(),
      'lazadaph': lazadaph.map((e) => e.toJson()).toList(),
    };
  }
}

class CartStoreItem {
  int id;
  int customerId;
  String productId;
  int quantity;
  // dynamic updatedAt;
  // dynamic createdAt;
  // dynamic variantId;
  int warehouse;
  String type;
  dynamic productOptionalIds;
  String country_id;

  CartStoreItem({
    required this.id,
    required this.customerId,
    required this.productId,
    required this.quantity,
    // this.updatedAt,
    // this.createdAt,
    // this.variantId,
    required this.warehouse,
    required this.type,
    this.productOptionalIds,
    required this.country_id,
  });

  factory CartStoreItem.fromJson(Map<String, dynamic> json) {
    return CartStoreItem(
      id: json['id'],
      customerId: json['customer_id'],
      productId: json['product_id'],
      quantity: json['quantity'],
      // updatedAt: json['updated_at'],
      // createdAt: json['created_at'],
      // variantId: json['variant_id'],
      warehouse: json['warehouse'],
      type: json['type'],
      productOptionalIds: json['product_optional_ids'],
      country_id: json['country_id'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customer_id': customerId,
      'product_id': productId,
      'quantity': quantity,
      // 'updated_at': updatedAt,
      // 'created_at': createdAt,
      // 'variant_id': variantId,
      'warehouse': warehouse,
      'type': type,
      'product_optional_ids': productOptionalIds,
      'country_id': country_id
    };
  }
}
