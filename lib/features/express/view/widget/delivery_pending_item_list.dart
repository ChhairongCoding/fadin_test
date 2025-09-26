import 'package:fardinexpress/features/express/controller/express_controller.dart';
import 'package:fardinexpress/features/express/view/widget/delivery_item_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class DeliveryPendingItemList extends StatefulWidget {
  final String transportType;
  const DeliveryPendingItemList({Key? key, required this.transportType})
      : super(key: key);

  @override
  State<DeliveryPendingItemList> createState() =>
      _DeliveryPendingItemListState();
}

class _DeliveryPendingItemListState extends State<DeliveryPendingItemList> {
  ExpressController _expressController =
      Get.put(ExpressController(), tag: "Pending");

  final List<Map<String, dynamic>> deliveryStatusList = [
    {
      "value": "all",
      "label": "All",
    },
    {
      "value": "express",
      "label": "fastExpress",
    },
    {
      "value": "delivery",
      "label": "normalExpress",
    },
    {
      "value": "province",
      "label": "provinceExpress",
    },
    {
      "value": "cargo",
      "label": "cargoExpress",
    },
  ];

  String selectedValue = 'all';

  @override
  void initState() {
    // _expressController = Get.put(ExpressController(), tag: widget.status);
    _expressController.initDeliveryList("Pending", widget.transportType);
    _expressController.paginateDeliveryList("Pending", widget.transportType);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      // crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        SizedBox(
          height: 10,
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Container(
              margin: EdgeInsets.only(right: 20.0),
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                color: Colors.white70,
                borderRadius: BorderRadius.circular(30.0),
                border: Border.all(width: 1, color: Colors.green),
              ),
              child: DropdownButton<String>(
                value: selectedValue,
                // alignment: Alignment.center,
                icon: const Icon(Icons.arrow_drop_down),
                // elevation: 16,
                // style: TextStyle(color: Colors.grey[800]),
                underline: Container(
                    // height: 2,
                    // color: Colors.grey[200],
                    ),
                borderRadius: BorderRadius.circular(8.0),
                menuWidth: Get.width * 0.6,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedValue = newValue!;
                    // _expressController.deliveryHistoryList.clear();
                    _expressController.initDeliveryList(
                        "Pending", selectedValue);
                    _expressController.paginateDeliveryList(
                        "Pending", selectedValue);
                  });
                },
                items: deliveryStatusList.map((Map<String, dynamic> item) {
                  return DropdownMenuItem<String>(
                    value: item["value"],
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      // mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('${item["label"]}'.tr),
                        Divider(
                          thickness: 1,
                          color: Colors.grey.shade300,
                        )
                      ],
                    ),
                  );
                }).toList(),
              )
              // Icon(
              //   Icons.filter_list_alt,
              //   size: 30.0,
              //   color: Colors.grey[800],
              // )
              ),
        ),
        Obx(() {
          if (_expressController.isDataProcessing.value) {
            return Expanded(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: Theme.of(context).primaryColor,
                      strokeWidth: 2,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Loading...",
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall!
                          .copyWith(color: Colors.grey[500]),
                    )
                  ]),
            );
          } else if (_expressController.deliveryHistoryList.isEmpty) {
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
            return Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _expressController.deliveryHistoryList.length,
                  itemBuilder: (context, index) {
                    return DeliveryItemTile(
                      deliveryHistoryModel:
                          _expressController.deliveryHistoryList[index],
                      deliveryType: widget.transportType,
                    );
                  }),
            );
          }
        }),
      ],
    );
  }
}
