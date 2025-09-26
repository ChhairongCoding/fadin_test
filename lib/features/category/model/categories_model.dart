class CategoryModel {
  final int? id;
  final String? code;
  final String? name;
  final String? image;

  CategoryModel({
    required this.id,
    required this.code,
    required this.name,
    required this.image,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      code: json['code'].toString(),
      name: json['name'].toString(),
      image: json['image'].toString(),
    );
  }

  bool userFilterByName(String filter) {
    return this.name.toString().contains(filter);
  }
}


// List<Map> categoriesList = [
//   {
//     "id": 20,
//     "image":
//         "https://system.anakutapp.com/assets/uploads/45813b72f19da998116504c01829c6e8.png",
//     "name": "Fashion"
//   },
//   {
//     "id": 19,
//     "image":
//         "https://system.anakutapp.com/assets/uploads/a5f44354eb431bbfd3bea2c62345e51d.png",
//     "name": "Sport & Outdoor"
//   },
//   {
//     "id": 16,
//     "image":
//         "https://system.anakutapp.com/assets/uploads/c4726938d45a84b8e7bc3b172fe9ca1a.png",
//     "name": "Jewelry & Watch"
//   },
//   {
//     "id": 14,
//     "image":
//         "https://system.anakutapp.com/assets/uploads/64f5ffc22c0bb674e8bea26b910d49ae.png",
//     "name": "Computer & Accessories"
//   },
//   {
//     "id": 13,
//     "image":
//         "https://system.anakutapp.com/assets/uploads/6fdef0558add8743e284ca283bba6975.png",
//     "name": "Toys, Kids & Babies"
//   },
//   {
//     "id": 12,
//     "image":
//         "https://system.anakutapp.com/assets/uploads/f7e5c8bde31b34efdfa5cfdeb8fb2a45.png",
//     "name": "Office & School Supplies"
//   },
//   {
//     "id": 10,
//     "image":
//         "https://system.anakutapp.com/assets/uploads/c871e4c90facea4109ad353a96779674.png",
//     "name": "Beauty & Health"
//   },
//   {
//     "id": 9,
//     "image":
//         "https://system.anakutapp.com/assets/uploads/c6d58cedfc5031f20dad5ec63dfc3f1e.png",
//     "name": "Home Appliances"
//   },
//   {
//     "id": 8,
//     "image":
//         "https://system.anakutapp.com/assets/uploads/7018e98b6c97364d6cb2128b6f7679af.png",
//     "name": "Home & Living"
//   },
//   {
//     "id": 7,
//     "image":
//         "https://system.anakutapp.com/assets/uploads/25ed0f916213df6e459d45bb9acfe529.png",
//     "name": "Book"
//   },
//   {
//     "id": 6,
//     "image":
//         "https://system.anakutapp.com/assets/uploads/c8c99d6aa2908f4fa3a822106ebc77fd.png",
//     "name": "Phone & Tablets"
//   },
//   {
//     "id": 4,
//     "image":
//         "https://system.anakutapp.com/assets/uploads/c0f5279649c9b41a99631ff00dad4d35.png",
//     "name": "Automotive"
//   },
//   {
//     "id": 2,
//     "image":
//         "https://system.anakutapp.com/assets/uploads/813599ec046aa98ab68aa781c9ff9cfa.png",
//     "name": "Pharmacy"
//   }
// ];

