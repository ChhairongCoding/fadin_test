class StoreModel {
  final String? id;
  final String? name;
  final String? image;
  final String country;
  // final String phone;
  // final String status;

  StoreModel(
      {required this.id,
      required this.name,
      required this.image,
      required this.country
      // required this.address,
      // required this.phone,
      // required this.status,
      });

  factory StoreModel.fromJson(Map<String, dynamic> json) {
    return StoreModel(
      id: json['code'].toString(),
      name: json['name'].toString(),
      image: json['image'].toString(),
      country: json['country'].toString(),
      // address: json['address'].toString(),
      // phone: json['phone'].toString(),
      // status: json['status'].toString()
    );
  }
}

// List<Map> storeModelList = [
//   {
//     "id": 1,
//     "image": "https://fardinexpress.asia/images/taobao.png",
//     "name": "Taobao"
//   },
//   {
//     "id": 2,
//     "image": "https://fardinexpress.asia/images/1688.png",
//     "name": "1688"
//   },
//   {
//     "id": 3,
//     "image": "https://fardinexpress.asia/images/amazon.png",
//     "name": "Amazon"
//   },
//   {
//     "id": 4,
//     "image": "https://fardinexpress.asia/images/logo.png",
//     "name": "Fardin Express"
//   }
// ];
