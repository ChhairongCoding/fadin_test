import 'package:dio/dio.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/feature/blog/models/info_category.dart';
import 'package:fardinexpress/services/api_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class InfoCategoryRepository {
  ApiProvider apiProvider = ApiProvider();
  String baseUrl =
      "${dotenv.env['baseUrl']}/blog_categories?${dotenv.env['vendor_code']}";
  int rowPerPage = 10;
  Future<List<InfoCategory>> getInfoCategory() async {
    String url = baseUrl;
    try {
      Response response = (await apiProvider.get(url, null, null))!;

      if (response.statusCode == 200) {
        var data = response.data;
        List<InfoCategory> infoCategoryList = [];
        data["data"].forEach((infoCategory) {
          infoCategoryList.add(InfoCategory.fromJson(infoCategory));
        });
        return infoCategoryList;
      }
      var data = response.data;
      throw data["message"];
    } catch (error) {
      throw error;
    }
  }
}
