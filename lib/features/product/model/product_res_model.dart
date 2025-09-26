class ProductObjectRes {
  final List<ProductModelRes> data;

  ProductObjectRes({required this.data});

  factory ProductObjectRes.fromJson(Map<String, dynamic> json) {
    var list = json['item'] as List;
    List<ProductModelRes> dataList =
        list.map((e) => ProductModelRes.fromJson(e)).toList();
    return ProductObjectRes(data: dataList);
  }
}

class ProductModelRes {
  final String? id;
  // final String? promoPrice;
  // final String? productStatus;
  // final String? code;
  String? name;
  final String? price;
  List<String>? image;
  final String? description;
  final String? webUrl;
  final String? storeCode;
  final String? countryCode;
  // final List<Photos> photos;
  // final List<VariantOptionType> variantOptionTypeList;
  // final List<OptionalList> optional;

  ProductModelRes({
    this.id,
    // required this.promoPrice,
    // required this.productStatus,
    // required this.code,
    this.name,
    this.price,
    this.image,
    // required this.storeName,
    // required this.storePhone,
    this.description,
    this.webUrl,
    this.storeCode,
    this.countryCode,
    // required this.photos,
    // required this.variantOptionTypeList,
    // required this.optional
  });

  factory ProductModelRes.fromJson(Map<String, dynamic> json) {
    var listPhoto = json['images'] as List;
    // List<Photos> photoIteam = listPhoto.map((e) => Photos.fromJson(e)).toList();
    // var listType = json['variant_option_type'] as List;
    // List<VariantOptionType> typeIteam =
    //     listType.map((e) => VariantOptionType.fromJson(e)).toList();
    // var listOptional = json['optional'] as List;
    // List<OptionalList> optionItem =
    //     listOptional.map((e) => OptionalList.fromJson(e)).toList();
    List<String> photoList = listPhoto.map((e) => e.toString()).toList();
    return ProductModelRes(
      id: json['num_iid'].toString(),
      // promoPrice: json['promo_price'].toString(),
      // productStatus: json['ecom_show'].toString(),
      // code: json['code'].toString(),
      name: json['title'].toString(),
      price: json['price'].toString(),
      image: photoList,
      description: json['description'].toString(),
      webUrl: json['website_url'].toString(),
      storeCode: json['store_code'].toString(),
      countryCode: json['country'].toString(),
      // storeId: json['store_id'].toString()
      // photos: photoIteam,
      // variantOptionTypeList: typeIteam,
      // optional: optionItem
    );
  }
}

class Photos {
  final int id;
  final int productId;
  final String photo;

  Photos({required this.id, required this.productId, required this.photo});

  factory Photos.fromJson(Map<String, dynamic> json) {
    return Photos(
        id: json['id'],
        productId: json['product_id'],
        photo: json['photo'].toString());
  }
}

class VariantOptionType {
  final int id;
  final String type;
  final List<VariantOptionTypeData> variantOptionTypeDataList;
  VariantOptionType(
      {required this.id,
      required this.type,
      required this.variantOptionTypeDataList});

  factory VariantOptionType.fromJson(Map<String, dynamic> json) {
    var listdata = json['data'] as List;
    List<VariantOptionTypeData> dataIteam =
        listdata.map((e) => VariantOptionTypeData.fromJson(e)).toList();
    return VariantOptionType(
        id: json['id'],
        type: json['type'].toString(),
        variantOptionTypeDataList: dataIteam);
  }
}

class VariantOptionTypeData {
  final int id;
  final String name;
  final String variantPrice;
  VariantOptionTypeData(
      {required this.id, required this.name, required this.variantPrice});
  factory VariantOptionTypeData.fromJson(Map<String, dynamic> json) {
    return VariantOptionTypeData(
        id: json['id'],
        name: json['name'].toString(),
        variantPrice: json['price'].toString());
  }
}

class OptionalList {
  final int id;
  final String type;
  final List<OptionalTypeList> optionalTypeList;
  OptionalList(
      {required this.id, required this.type, required this.optionalTypeList});

  factory OptionalList.fromJson(Map<String, dynamic> json) {
    var listdata = json['data'] as List;
    List<OptionalTypeList> dataIteam =
        listdata.map((e) => OptionalTypeList.fromJson(e)).toList();
    return OptionalList(
        id: json['id'],
        type: json['type'].toString(),
        optionalTypeList: dataIteam);
  }
}

class OptionalTypeList {
  final int id;
  final String name;
  final String optionalPrice;
  OptionalTypeList(
      {required this.id, required this.name, required this.optionalPrice});
  factory OptionalTypeList.fromJson(Map<String, dynamic> json) {
    return OptionalTypeList(
        id: json['id'],
        name: json['name'].toString(),
        optionalPrice: json['price'].toString());
  }
}

// List<Map> productModelList = [
//   {
//     "num_iid": 604074848445,
//     "pic":
//         "https://img.alicdn.com/bao/uploaded/i1/69927205/O1CN01jhDlxI235wDRPlzYF_!!69927205.jpg",
//     "title": "Foreign trade Brock Goodyear business casual leather shoes",
//     "price": "44.85",
//     "promotion_price": "299",
//     "sales": 55,
//     "desription":
//         "Foreign trade Brock Goodyear business casual leather shoes British handmade men's thick-soled carved men's shoes large size",
//     "seller_id": 69927205,
//     "seller_nick": "sgs81925713",
//     "shop_title": "卡拉SHOES",
//     "user_type": 0,
//     "detail_url": "//item.taobao.com/item.htm?id=604074848445",
//     "delivery_fee": "12.00"
//   },
//   {
//     "num_iid": 600024554882,
//     "pic":
//         "https://img.alicdn.com/bao/uploaded/i1/2201482444412/O1CN01LbwhYR1iSk9hiWNYA_!!0-item_pic.jpg",
//     "title": "Le' Murmure small white shoes women's leather",
//     "price": "73.20",
//     "promotion_price": "488",
//     "sales": 200,
//     "desription":
//         "Le' Murmure small white shoes women's leather all-match   shoes trendy two wear! It's super comfortable to step on shit!",
//     "seller_id": 2201482444412,
//     "seller_nick": "果家有品",
//     "shop_title": "Le' Murmure Shoes",
//     "user_type": 0,
//     "detail_url": "//item.taobao.com/item.htm?id=600024554882",
//     "delivery_fee": "0.00"
//   },
//   {
//     "num_iid": 573972966346,
//     "pic":
//         "https://img.alicdn.com/bao/uploaded/i3/2295718169/O1CN0106so612ADS0QjwC0N_!!0-item_pic.jpg",
//     "title": "Shoes For Crews|Professional",
//     "price": "68.70",
//     "promotion_price": "199",
//     "sales": 42,
//     "desription":
//         "Shoes For Crews|Professional non-slip work shoes men and women hotel chef shoes medical shoes 61582",
//     "seller_id": 2295718169,
//     "seller_nick": "innoways旗舰店",
//     "shop_title": "innoways旗舰店",
//     "user_type": 1,
//     "detail_url": "//detail.tmall.com/item.htm?id=573972966346",
//     "delivery_fee": "0.00"
//   },
//   {
//     "num_iid": 604535530894,
//     "pic":
//         "https://img.alicdn.com/bao/uploaded/i3/69927205/O1CN01ENRkIE235wDXCNsBe_!!69927205.jpg",
//     "title": "Goodyear retro business casual leather",
//     "price": "44.40",
//     "promotion_price": "296",
//     "sales": 59,
//     "desription":
//         "Goodyear retro business casual leather large leather shoes wild British handmade men's solid bottom large size 46",
//     "seller_id": 69927205,
//     "seller_nick": "sgs81925713",
//     "shop_title": "卡拉SHOES",
//     "user_type": 0,
//     "detail_url": "//item.taobao.com/item.htm?id=604535530894",
//     "delivery_fee": "12.00"
//   },
//   {
//     "num_iid": 574862941212,
//     "pic":
//         "https://img.alicdn.com/bao/uploaded/i4/3568646727/TB1JhkkI7CWBuNjy0FaXXXUlXXa_!!0-item_pic.jpg",
//     "title": "Barocco shoes retro vintage",
//     "price": "42.75",
//     "promotion_price": "285",
//     "sales": 24,
//     "desription":
//         "Barocco shoes retro vintage vintage square head car line low heel leather Baotou autumn sandals",
//     "seller_id": 3568646727,
//     "seller_nick": "鞋魔真皮定制",
//     "shop_title": "Barocco shoes",
//     "user_type": 0,
//     "detail_url": "//item.taobao.com/item.htm?id=574862941212",
//     "delivery_fee": "0.00"
//   },
//   {
//     "num_iid": 597653552864,
//     "pic":
//         "https://img.alicdn.com/bao/uploaded/i3/499095250/O1CN01cKAJOm1oeY4IXBocx_!!499095250.jpg",
//     "title": "Flat sandals women's thick-soled fairy style women's shoes",
//     "price": "13.35",
//     "promotion_price": "89",
//     "sales": 100,
//     "desription":
//         "Lady shoes women's shoes [low price sale, no refund, no exchange] flat sandals women's thick-soled fairy style women's shoes",
//     "seller_id": 499095250,
//     "seller_nick": "皇马罗纳尔多",
//     "shop_title": "鞋夫人定制 鞋爱love shoes",
//     "user_type": 0,
//     "detail_url": "//item.taobao.com/item.htm?id=597653552864",
//     "delivery_fee": "0.00"
//   },
// ];
