import 'package:fardinexpress/features/express/controller/express_controller.dart';
import 'package:fardinexpress/features/express/view/widget/delivery_item_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TrackingOrderResult extends StatefulWidget {
  TrackingOrderResult({required this.query});
  final String query;
  @override
  _TrackingOrderResultState createState() => _TrackingOrderResultState();
}

class _TrackingOrderResultState extends State<TrackingOrderResult> {
  // var controller = Get.find<ExpressController>(tag: "filter");
  final ExpressController controller =
      Get.find<ExpressController>(tag: 'filter');
  // final RefreshController _refreshController = RefreshController();
  @override
  void initState() {
    controller.trackingDeliveryHistory(id: widget.query);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }
      if (controller.deliveryHistoryModel == null) {
        return Center(
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
                  "noDataFound".tr,
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(color: Colors.grey[500]),
                )
              ]),
        );
      } else {
        return DeliveryItemTile(
            deliveryHistoryModel: controller.deliveryHistoryModel!,
            deliveryType: controller.deliveryHistoryModel!.deliveryType);
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    // searchBloc!.results.clear();
    // controller.deliveryHistoryModel = null;
    super.dispose();
  }
}
