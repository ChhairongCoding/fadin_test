import 'package:dio/dio.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/feature/price_estimation/models/estimation.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/feature/price_estimation/models/estimation_result.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/feature/price_estimation/models/target_country_list.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/feature/transport_methods/model/transport_method_model.dart';
import 'package:fardinexpress/services/api_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class PriceEstimationRepository {
  ApiProvider apiProvider = ApiProvider();
  Future<EstimationResult> getPrice({required Estimation estimation}) async {
    try {
      String body = '''{
        "warehouse":"${estimation.country}",
        "delivery_mode":"${estimation.mode}",
        "height":"${estimation.height}",
        "width":"${estimation.width}",
        "length":"${estimation.length}",
        "weight":"${estimation.weight}"
        }''';
      Response response = (await apiProvider.post(
          "${dotenv.env['baseUrl']}/price/calculate", body, null))!;

      return EstimationResult.fromJson(response.data["data"]);
    } catch (e) {
      throw e;
    }
  }

  Future<List<TargetCountryModel>> getTargetCountryList() async {
    try {
      Response response = (await apiProvider.get(
          "${dotenv.env['baseUrl']}/countries", null, null))!;

      if (response.statusCode == 200) {
        var data = response.data['data'];
        List<TargetCountryModel> targetCountryList = [];
        data.forEach((item) {
          targetCountryList.add(TargetCountryModel.fromJson(item));
        });
        return targetCountryList;
      } else {
        throw response.data.toString();
      }
    } catch (e) {
      throw e;
    }
  }

  Future<TargetCountryModel> getTargetCountryById(
      {required String countryId}) async {
    try {
      Response response = (await apiProvider.get(
          "${dotenv.env['baseUrl']}/countries", null, null))!;

      if (response.statusCode == 200) {
        var data = response.data['data'];
        // List<TargetCountryModel> targetCountryList = [];
        var getTargetCountry;
        data.forEach((item) {
          // targetCountryList.add(TargetCountryModel.fromJson(item));
          if (countryId == item['id'].toString()) {
            getTargetCountry = TargetCountryModel.fromJson(item);
          }
        });
        return getTargetCountry;
      } else {
        throw response.data.toString();
      }
    } catch (e) {
      throw e;
    }
  }

  Future<List<TransportMothodModel>> getTransportMethodList(String id) async {
    try {
      Response response = (await apiProvider.get(
          "${dotenv.env['baseUrl']}/delivery_modes?country_id=$id",
          null,
          null))!;

      if (response.statusCode == 200) {
        var data = response.data['data'];
        List<TransportMothodModel> transportMethodList = [];
        data.forEach((item) {
          transportMethodList.add(TransportMothodModel.fromJson(item));
        });
        return transportMethodList;
      } else {
        throw response.data.toString();
      }
    } catch (e) {
      throw e;
    }
  }
}
