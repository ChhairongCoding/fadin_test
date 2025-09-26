import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/feature/branch_address/model/countries_model.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/feature/branch_address/model/district_model.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/feature/branch_address/model/province_model.dart';
import 'package:fardinexpress/services/api_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class BranchAddressRepository {
  ApiProvider apiProvider = ApiProvider();
  // int rowPerPage = 10;
  Future<List<ProvinceModel>> fetchProvinceList() async {
    String url = "${dotenv.env['baseUrl']}/provinces";
    try {
      Response response = (await (apiProvider.get(url, null, null)))!;
      if (response.statusCode == 200) {
        var data = response.data;
        List<ProvinceModel> addressList = <ProvinceModel>[].obs;
        data["data"].forEach((item) {
          addressList.add(ProvinceModel.fromJson(item));
        });
        return addressList;
      }
      var data = json.decode(response.data);
      throw data["message"];
    } catch (e) {
      throw e;
    }
  }

  Future<List<DistrictModel>> fetchDistrictList(String id) async {
    String url = "${dotenv.env['baseUrl']}/districts?ProID=$id";
    try {
      Response response = (await (apiProvider.get(url, null, null)))!;
      if (response.statusCode == 200) {
        var data = response.data;
        // print(data.toString());
        List<DistrictModel> districtList = <DistrictModel>[].obs;
        data["data"].forEach((item) {
          districtList.add(DistrictModel.fromJson(item));
        });
        return districtList;
      }
      var data = json.decode(response.data);
      throw data["message"];
    } catch (e) {
      throw e;
    }
  }

  Future<List<CountriesModel>> fetchCountryList() async {
    String url = "${dotenv.env['baseUrl']}/countries";
    try {
      Response response = (await (apiProvider.get(url, null, null)))!;
      if (response.statusCode == 200) {
        var data = response.data;
        // print(data.toString());
        List<CountriesModel> countryList = <CountriesModel>[].obs;
        data["data"].forEach((item) {
          countryList.add(CountriesModel.fromJson(item));
        });
        return countryList;
      }
      var data = json.decode(response.data);
      throw data["message"];
    } catch (e) {
      throw e;
    }
  }
}
