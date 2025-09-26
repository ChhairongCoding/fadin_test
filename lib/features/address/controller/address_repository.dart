import 'package:dio/dio.dart';
import 'package:fardinexpress/features/address/model/address_model.dart';
import 'package:fardinexpress/services/api_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AddressRepository {
  ApiProvider apiProvider = ApiProvider();
  String baseUrl = "${dotenv.env['baseUrl']}/profile/location";
  int rowPerPage = 10;
  Future<List<AddressModel>> fetchAddressList() async {
    String url = baseUrl;
    try {
      Response response = (await (apiProvider.get(url, null, null)))!;
      if (response.statusCode == 200) {
        var data = response.data;
        print(data.toString());
        List<AddressModel> addressList = [];
        data.forEach((item) {
          addressList.add(AddressModel(
              id: item["id"].toString(),
              name: item["name"].toString(),
              lat: item["lat"].toString(),
              long: item["long"].toString(),
              defaultAddress: item["default"].toString(),
              description: item["description"].toString()));
        });
        // List<AddressModel> addressList =
        //     data.map((json) => AddressModel.fromJson(json)).toList();
        return addressList;
      }
      // var data = json.decode(response.data);
      throw Exception("dsf");
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<String> selectAddress({required String addressId}) async {
    try {
      String url = baseUrl;
      // String body =
      //     '{"name":"$name","address":"$address", "account_number": "$accNumber", "image": "$image"}';
      Response response =
          (await apiProvider.post(url + "/$addressId", null, null))!;
      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = response.data;
        return data["message"].toString();
      } else if (response.statusCode == 401) {
        throw response.data["message"].toString();
      }
      throw response.data["message"].toString();
    } catch (e) {
      throw e;
    }
  }

  Future<String> removeAddress({required String addressId}) async {
    try {
      String url = baseUrl + "/delete/$addressId";
      // String body =
      //     '{"name":"$name","address":"$address", "account_number": "$accNumber", "image": "$image"}';
      Response response = (await apiProvider.delete(url, null))!;
      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = response.data;
        return data["message"].toString();
      } else if (response.statusCode == 401) {
        throw response.data["message"].toString();
      }
      throw response.data["message"].toString();
    } catch (e) {
      throw e;
    }
  }

  Future<String> addAddress(
      {required String name,
      required String lat,
      required String long,
      required String description}) async {
    try {
      String url = baseUrl + "/add";
      String body =
          '{"name":"$name","lat":"$lat", "long": "$long", "description": "$description"}';
      Response response = (await apiProvider.post(url, body, null))!;
      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = response.data;
        return data["message"].toString();
      } else if (response.statusCode == 401) {
        throw response.data["message"].toString();
      }
      throw response.data["message"].toString();
    } catch (e) {
      throw e;
    }
  }
}
