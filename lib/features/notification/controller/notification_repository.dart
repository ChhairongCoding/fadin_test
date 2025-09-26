import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fardinexpress/features/notification/model/notification_model.dart';
import 'package:fardinexpress/services/api_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class NotificationRepository {
  ApiProvider apiProvider = ApiProvider();
  String baseUrl =
      "${dotenv.env['baseUrl']}/notifications?vendor_code=${dotenv.env['vendor_code']}";
  int rowPerPage = 10;
  Future<List<NotificationModel>> fetchNotificationList() async {
    String url = baseUrl;
    try {
      Response response = (await (apiProvider.get(url, null, null)))!;
      if (response.statusCode == 200) {
        var data = response.data;
        List<NotificationModel> notificationList = [];
        data.forEach((item) {
          notificationList.add(NotificationModel.fromJson(item));
        });
        return notificationList;
      }
      var data = json.decode(response.data);
      throw Exception(data["message"].toString());
    } catch (e) {
      throw Exception(e);
    }
  }
}
