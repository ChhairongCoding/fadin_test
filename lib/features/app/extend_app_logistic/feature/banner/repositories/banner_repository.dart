import 'package:dio/dio.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/feature/banner/models/banner.dart';
import 'package:fardinexpress/services/api_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class BannerRepository {
  ApiProvider apiProvider = ApiProvider();
  String baseUrl =
      "${dotenv.env['baseUrl']}/banners?vendor_code=${dotenv.env['vendor_code']}";
  int rowPerPage = 10;
  Future<List<Banner>> getBannerImages() async {
    String url = baseUrl;
    try {
      Response response = (await apiProvider.get(url, null, null))!;

      if (response.statusCode == 200) {
        var data = response.data;
        List<Banner> banners = [];
        data["data"].forEach((banner) {
          banners.add(Banner.fromJson(banner));
        });
        return banners;
      }
      throw response.data["message"].toString();
    } catch (error) {
      throw error;
    }
  }
}
