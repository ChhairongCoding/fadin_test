// import 'package:dio/dio.dart';
// import 'package:dropdown_search/dropdown_search.dart';
// import 'package:flutter/material.dart';

// class DropdownSearchPage extends StatefulWidget {
//   const DropdownSearchPage({Key? key}) : super(key: key);

//   @override
//   State<DropdownSearchPage> createState() => _DropdownSearchPageState();
// }

// class _DropdownSearchPageState extends State<DropdownSearchPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Dropdown Search"),
//       ),
//       body: DropdownSearch<PersonModel>(
//         dropdownSearchDecoration: InputDecoration(labelText: "Name"),
//         validator: (String filter) async {
//           var response = await Dio().get(
//             "http://5d85ccfb1e61af001471bf60.mockapi.io/user",
//             queryParameters: {"filter": filter},
//           );
//           var models = PersonModel.fromJsonList(response.data);
//           return models;
//         },
//         onChanged: (PersonModel? data) {
//           print(data);
//         },
//       ),
//     );
//   }
// }

// class PersonModel {
//   final String id;
//   final String name;
//   final String avatar;

//   PersonModel({required this.id, required this.name, required this.avatar});

//   factory PersonModel.fromJson(Map<String, dynamic> json) {
//     // if (json.toString() == "null") return [];
//     return PersonModel(
//       id: json["id"],
//       name: json["name"],
//       avatar: json["avatar"],
//     );
//   }

//   static List<PersonModel> fromJsonList(List list) {
//     // if (list == null) return null;
//     return list.map((item) => PersonModel.fromJson(item)).toList();
//   }

//   ///this method will prevent the override of toString
//   String userAsString() {
//     return '#${this.id} ${this.name}';
//   }

//   ///this method will prevent the override of toString
//   // bool userFilterByCreationDate(String filter) {
//   //   return this.createdAt.toString().contains(filter);
//   // }

//   ///custom comparing function to check if two users are equal
//   bool isEqual(PersonModel model) {
//     return this.id == model.id;
//   }

//   @override
//   String toString() => name;
// }
