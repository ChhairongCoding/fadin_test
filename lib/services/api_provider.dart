import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

enum Method { post, get, delete, put }

class ApiProvider {
  static String? accessToken = '';
  final Dio _dio = Dio();

  Future<Response?> post(String url, dynamic body, Options? options) async {
    return _httpServices(
        method: Method.post, url: url, body: body, options: options);
  }

  Future<Response?> get(String url, dynamic body, Options? options) async {
    return _httpServices(
        method: Method.get, url: url, body: body, options: options);
  }

  Future<Response?> put(String url, dynamic body) async {
    return _httpServices(method: Method.put, url: url, body: body);
  }

  Future<Response?> delete(String url, dynamic body) async {
    return _httpServices(method: Method.delete, url: url, body: body);
  }

  Future<Response?> _httpServices(
      {required Method method,
      required String url,
      dynamic body,
      Options? options}) async {
    Response response;
    try {
      if (accessToken != null && accessToken != "") {
        _dio.options.headers["token"] = accessToken;
        _dio.options.headers["Authorization"] = "Bearer $accessToken";
      }

      _dio.options.headers["type"] = "upload";
      _dio.options.headers["accept"] = "application/json";
      response = await ((method == Method.post)
          ? _dio.post(url, data: body, options: options)
          : (method == Method.get)
              ? _dio.get(url, options: options)
              : (method == Method.put)
                  ? _dio.put(url, data: body)
                  : _dio.delete(url, data: body));
    } on DioException catch (e) {
      log(e.error.toString() + url);
      if (e.type == DioExceptionType.cancel) {
        if (e.response!.statusCode == 401) {
          throw e.response!.data["message"];
        }
        throw e.response!.data["message"];
      }
      throw e.response!.data["message"];
    }
    return response;
  }

  Future<String> uploadImage({required File image}) async {
    try {
      Dio _dio = Dio();
      _dio.options.headers["Authorization"] =
          "Bearer " + ApiProvider.accessToken!;
      _dio.options.headers["type"] = "upload";
      String fileName = image.path.split('/').last;
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(image.path, filename: fileName),
      });
      Response response =
          await _dio.post("${dotenv.env['baseUrl']}/upload", data: formData);

      if (response.statusCode == 200 && response.data["image_url"] != null) {
        return response.data["image_url"];
      } else {
        throw Exception("Can't Upload");
      }
    } catch (e) {
      throw e.toString();
    }
  }

  // Future<String> uploadImageCheckout({required File image}) async {
  //   try {
  //     Dio _dio2 = Dio();
  //     _dio2.options.headers["Authorization"] = "anakut";
  //     _dio.options.headers["Accept"] = "application/json";
  //     // _dio.options.headers["Content-Type"] = "multipart/form-data";
  //     // _dio2.options.headers["type"] = "upload";
  //     String fileName = image.path.split('/').last;
  //     FormData formData = FormData.fromMap({
  //       "files": await MultipartFile.fromFile(image.path, filename: fileName),
  //     });
  //     Response response = await _dio2
  //         .post("http://system.anakutapp.com/upload.php", data: formData);

  //     if (response.statusCode == 200) {
  //       return response.data["image_url"].toString();
  //     } else {
  //       throw Exception("Can't Upload");
  //     }
  //   } catch (e) {
  //     throw e.toString();
  //   }
  // }

  Future<String> uploadImageCheckout({required File image}) async {
    var dio = Dio();

    try {
      // Ensure the file exists
      if (!await image.exists()) {
        return "Error: Image file not found";
      }

      // Create form data with the image
      FormData formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(image.path,
            filename: image.path.split('/').last),
      });

      // Send the POST request to the server
      var response = await dio.request(
        'https://system.anakutapp.com/upload.php', // Replace with your API URL
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'anakut', // Add necessary headers
            'Accept': 'application/json',
          },
        ),
      );

      // Check if the request was successful and return the response as String
      if (response.statusCode == 200) {
        // Return the response data as a String
        return response.data["image_url"].toString();
      } else {
        // Return error message
        return "Error: ${response.statusMessage}";
      }
    } catch (e) {
      // Catch and return any error that occurs
      return "Error occurred while uploading: $e";
    }
  }

  Future<String> gTranslate({required String keyword}) async {
    String url =
        "https://fardinexpress.asia/api/translate?text=$keyword&lang=en";
    try {
      Response response = (await (_dio.get(url)));
      if (response.statusCode == 200) {
        var data = response.data;
        return data.toString();
      }
      var data = json.decode(response.data);
      throw Exception(data.toString());
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<dynamic>> fetchRoute(
      {required GeoPoint start, required GeoPoint end}) async {
    final apiKey = '5b3ce3597851110001cf62487c1331c772794ab29193951acf66f2be';
    String url =
        'https://api.openrouteservice.org/v2/directions/driving-car?api_key=$apiKey&start=${start.longitude},${start.latitude}&end=${end.longitude},${end.latitude}';
    try {
      Response response = (await (_dio.get(url)));
      if (response.statusCode == 200) {
        var data = response.data;
        final coordinates =
            data['features'][0]['geometry']['coordinates'] as List;
        return coordinates;
        // coordinates
        //     .map((coord) => GeoPoint(latitude: coord[1], longitude: coord[0]))
        //     .toList();
      }
      var data = json.decode(response.data);
      throw Exception(data.toString());
    } catch (e) {
      throw Exception(e);
    }
  }
}
