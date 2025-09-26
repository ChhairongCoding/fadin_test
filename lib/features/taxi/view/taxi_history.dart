import 'package:fardinexpress/features/taxi/controller/taxi_controller.dart';
import 'package:fardinexpress/features/taxi/view/widget/taxi_booking_history_item_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TaxiHistoryScreen extends GetView<TaxiController> {
  TaxiHistoryScreen({Key? key}) : super(key: key);

  var controller = Get.put(TaxiController());
  // var _controller = Get.find<TaxiController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("taxiBookingHistory".tr),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isDataProcessing.value == true) {
          return Center(child: CircularProgressIndicator());
        }
        if (controller.isDataProcessing.value == false &&
            controller.taxiHistoryList.isEmpty) {
          return Expanded(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ImageIcon(
                    AssetImage("assets/extend_assets/icons/empty-box.png"),
                    size: 120,
                    color: Colors.grey[400],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    "no_data".tr,
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(color: Colors.grey[500]),
                  )
                ]),
          );
        } else {
          return Container(
            child: ListView.builder(
                itemCount: controller.taxiHistoryList.length,
                itemBuilder: (context, index) {
                  return TaxiBookingHistoryItemTile(
                      taxiHistoryModel: controller.taxiHistoryList[index]);
                }),
          );
        }
      }),
    );
  }
}
