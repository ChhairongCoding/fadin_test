import 'package:dio/dio.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/feature/blog/models/info.dart';
import 'package:fardinexpress/services/api_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

List<Info> parseInfos(responseBody) {
  // final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return responseBody.map<Info>((json) => Info.fromJson(json)).toList();
}

abstract class InfoListingRepository {
  final ApiProvider apiProvider = ApiProvider();
  String url = "";
  Future<List<Info>> getInfoList(
      {required int page, required int rowPerPage, required additionalArg});
  Future<List<Info>> operate(
      {required String urlSuffix,
      required int page,
      required int rowPerPage}) async {
    try {
      url = "${dotenv.env['baseUrl']}/" +
          urlSuffix;
      print(url);
      Response response = (await apiProvider.get(url, null, null))!;

      if (response.statusCode == 200) {
        // return compute(parseInfos, response.data["data"]);
        List<Info> infos = [];
        response.data["data"].forEach((val) {
          infos.add(Info.fromJson(val));
        });
        return infos;
      }
      var data = response.data;
      throw data["message"];
    } catch (e) {
      throw e;
    }
  }
}

class InfoListByCategoryRepo extends InfoListingRepository {
  @override
  Future<List<Info>> getInfoList(
      {required int page,
      required int rowPerPage,
      required additionalArg}) async {
    if (additionalArg is String)
      return await super.operate(
          urlSuffix:
              "blog?row_per_page=$rowPerPage&page=$page&category_id=$additionalArg&${dotenv.env['vendor_code']}",
          page: page,
          rowPerPage: rowPerPage);
    else
      throw "Invalid argument.";
  }
}
