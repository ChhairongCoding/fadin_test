import 'package:fardinexpress/features/cart/model/cart_store_model.dart';

class CheckoutModel {
  String? type;
  String? grandTotal;
  List<CartStoreItem> item = [];
  CheckoutModel({
    required this.type,
    required this.grandTotal,
    required this.item,
  });

  factory CheckoutModel.fromJson(Map<String, dynamic> json) {
    var list;
    List<CartStoreItem> itemList;
    if (json['items'] == null) {
      list = "";
      itemList = [];
    } else {
      list = json['items'] as List;
      itemList = list.map((e) => CartStoreItem.fromJson(e)).toList();
    }
    return CheckoutModel(
      type: json['type'].toString(),
      grandTotal: json['grand_total'].toString(),
      item: itemList,
    );
  }
}

// class CheckoutItem {
//   final String id;
//   // final String code;
//   final String name;
//   // final String cost;
//   final String price;
//   final String quantity;
//   final String image;
//   final String subTotal;
//   // final CategoryItemList categoryItemList;
//   // final SubCategoryItemList subCategoryItemList;
//   final List<PhotosItemList> photosItemList;

//   CheckoutItem({
//     required this.id,
//     // required this.code,
//     required this.name,
//     // required this.cost,
//     required this.price,
//     required this.quantity,
//     required this.image,
//     required this.subTotal,
//     // required this.categoryItemList,
//     // required this.subCategoryItemList,
//     required this.photosItemList,
//   });

//   factory CheckoutItem.fromJson(Map<String, dynamic> json) {
//      var list;
//     List<PhotosItemList> photoItemList;
//     if (json['photos'] == null) {
//       list = "";
//       photoItemList = [];
//     } else {
//       list = json['photos'] as List;
//       photoItemList = list.map((e) => PhotosItemList.fromJson(e)).toList();
//     }
//     return CheckoutItem(
//         id: json['id'].toString(),
//         // code: json['code'].toString(),
//         name: json['name'].toString(),
//         // cost: json['cost'].toString(),
//         price: json['price'].toString(),
//         quantity: json['quantity'].toString(),
//         image: json['image'].toString(),
//         subTotal: json['grand_total'].toString(),
//         // categoryItemList: json['category'],
//         // subCategoryItemList: json['subcategory_id'],
//         photosItemList: photoItemList);
//   }
// }

// class CategoryItemList {
//   final String id;
//   final String name;

//   CategoryItemList({
//     required this.id,
//     required this.name,
//   });

//   factory CategoryItemList.fromJson(Map<String, dynamic> json) {
//     return CategoryItemList(
//         id: json['id'].toString(), name: json["name"].toString());
//   }
// }

// class SubCategoryItemList {
//   final String id;
//   final String name;

//   SubCategoryItemList({
//     required this.id,
//     required this.name,
//   });

//   factory SubCategoryItemList.fromJson(Map<String, dynamic> json) {
//     return SubCategoryItemList(
//         id: json['id'].toString(), name: json["name"].toString());
//   }
// }

// class PhotosItemList {
//   final String id;
//   final String name;
//   final String image;

//   PhotosItemList({required this.id, required this.name, required this.image});

//   factory PhotosItemList.fromJson(Map<String, dynamic> json) {
//     return PhotosItemList(
//         id: json['id'].toString(),
//         name: json["name"].toString(),
//         image: json["image"]);
//   }
// }
