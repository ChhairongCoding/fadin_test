import 'package:fardinexpress/features/my_order/controller/my_order_controller.dart';
import 'package:fardinexpress/features/my_order/view/widget/order_item.tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderItemList extends StatefulWidget {
  final String status;
  const OrderItemList({Key? key, required this.status}) : super(key: key);

  @override
  State<OrderItemList> createState() => _OrderItemListState();
}

class _OrderItemListState extends State<OrderItemList> {
  MyOrderController? _myOrderController;

  @override
  void initState() {
    _myOrderController = Get.put(MyOrderController(), tag: widget.status);
    _myOrderController!.initMyOrderList(widget.status);
    _myOrderController!.paginateMyOrderList(widget.status);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (_myOrderController!.isDataProcessing.value) {
        return Center(child: CircularProgressIndicator());
      } else if (_myOrderController!.orderList.isEmpty) {
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
        return ListView.builder(
            shrinkWrap: true,
            itemCount: _myOrderController!.orderList.length,
            itemBuilder: (context, index) {
              return OrderItemTile(
                  orderModel: _myOrderController!.orderList[index]);
            });
      }
    });
  }
}
