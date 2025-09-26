import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fardinexpress/features/category/model/categories_model.dart';
import 'package:fardinexpress/features/category/model/sub_categories_model.dart';
import 'package:fardinexpress/services/api_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:get/get_rx/src/rx_types/rx_types.dart';

class CategoryRepository {
  ApiProvider apiProvider = ApiProvider();
  String baseUrl =
      "${dotenv.env['baseUrl']}/categories?vendor_code=${dotenv.env['vendor_code']}";
  int rowPerPage = 10;
  Future<List<CategoryModel>> fetchCategoryList() async {
    String url = baseUrl;
    try {
      Response response = (await (apiProvider.get(url, null, null)))!;
      if (response.statusCode == 200) {
        var data = response.data;
        List<CategoryModel> categories = <CategoryModel>[];
        data["data"].forEach((category) {
          categories.add(CategoryModel(
              id: category["id"],
              code: category["code"],
              name: category["name"],
              image: category["image"]));
        });
        return categories;
      }
      var data = json.decode(response.data);
      throw data["message"].toString();
    } catch (e) {
      throw e.toString();
    }
  }

  Future<List<SubCategoryModel>> fetchSubCategoryList(String categoryId) async {
    String url =
        "${dotenv.env['baseUrl']}/subcategories/$categoryId?vendor_code=${dotenv.env['vendor_code']}";
    try {
      Response response = (await (apiProvider.get(url, null, null)))!;
      if (response.statusCode == 200) {
        var data = response.data;
        List<SubCategoryModel> subCategories = <SubCategoryModel>[];
        data["data"].forEach((category) {
          subCategories.add(SubCategoryModel(
              id: category["id"],
              code: category["code"],
              name: category["name"],
              image: category["image"]));
        });
        return subCategories;
      }
      var data = json.decode(response.data);
      throw data["message"].toString();
    } catch (e) {
      throw e.toString();
    }
  }
}
