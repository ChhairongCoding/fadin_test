import 'package:fardinexpress/features/notification/controller/notification_repository.dart';
import 'package:fardinexpress/features/notification/model/notification_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController {
  var isLoading = false.obs;
  // var currentIndex = 0.obs;
  List<NotificationModel> notificationList = <NotificationModel>[].obs;
  NotificationRepository _notificationRepository = NotificationRepository();

  NotificationController() {
    getNotificationList();
  }

  showSnackBar(String title, String message, Color bgColor) {
    Get.snackbar(title, message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: bgColor,
        colorText: Colors.white);
  }

  void getNotificationList() async {
    try {
      isLoading(true);
      var tempList = await _notificationRepository.fetchNotificationList();
      notificationList.addAll(tempList);
      isLoading(false);
    } catch (e) {
      isLoading(false);
      showSnackBar("Exception", e.toString(), Colors.red);
    }
  }
}
