import 'package:extended_image/extended_image.dart';
import 'package:fardinexpress/features/notification/controller/notification_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';

enum NotificationType {
  page,
  widget,
}

class NotificationPage extends StatelessWidget {
  final NotificationType notificationType;
  NotificationPage({Key? key, required this.notificationType})
      : super(key: key);

  late final NotificationController _notificationController =
      Get.put(NotificationController());

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    // appBar: AppBar(
    //   title: Text("notification".tr),
    //   centerTitle: true,
    // ),
    // body:
    return Obx(() {
      if (_notificationController.isLoading.value) {
        return Center(child: CircularProgressIndicator());
      } else if (_notificationController.isLoading.value == false &&
          _notificationController.notificationList.isEmpty) {
        return Center(child: Text("No item found"));
      } else {
        return Column(
          children: [
            this.notificationType == NotificationType.page
                ? AppBar(
                    title: Text("notification".tr),
                    centerTitle: true,
                  )
                : Container(),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(10.0),
                child: ListView.builder(
                    itemCount: _notificationController.notificationList.length,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: EdgeInsets.all(10.0),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.0),
                              color: Colors.green[100]),
                          child: ListTile(
                            leading: Container(
                                // margin: const EdgeInsets.symmetric(vertical: 10.0),
                                // padding: EdgeInsets.symmetric(vertical: 6.0),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        width: 1.0, color: Colors.white)),
                                child: Container(
                                  child: CircleAvatar(
                                    radius: 30.0,
                                    child: ClipOval(
                                        child: ExtendedImage.network(
                                      "assets/img/fardin-logo.png",
                                      // errorWidget:
                                      //     Image.asset("assets/img/fardin-logo.png"),
                                      cacheWidth: 300,
                                      cacheHeight: 300,
                                      // enableMemoryCache: true,
                                      clearMemoryCacheWhenDispose: true,
                                      clearMemoryCacheIfFailed: false,
                                      fit: BoxFit.cover,
                                      // width: double.infinity,
                                      // height: double.infinity,
                                    )),
                                    backgroundColor: Colors.transparent,
                                  ),
                                )),
                            isThreeLine: true,
                            title: Text("Fardin Express"),
                            subtitle: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Html(
                                    data: _notificationController
                                                .notificationList[index].body
                                                .toString() ==
                                            "null"
                                        ? ""
                                        : _notificationController
                                            .notificationList[index].body
                                            .toString(),
                                    style: {
                                      "p": Style(
                                          color: Colors.black,
                                          fontSize: FontSize(13.0))
                                    }),
                                Text(_notificationController
                                    .notificationList[index].date)
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            ),
          ],
        );
      }
    });
    // );
  }
}
