import 'package:fardinexpress/features/express/view/widget/delivery_completed_item_list.dart';
import 'package:fardinexpress/features/express/view/widget/delivery_delivering_item_list.dart';
import 'package:fardinexpress/features/express/view/widget/delivery_pending_item_list.dart';
import 'package:fardinexpress/features/express/view/widget/delivery_pickup_item_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeliveryHistoryPage extends StatefulWidget {
  final String transportType;
  DeliveryHistoryPage({required this.initIndex, required this.transportType});
  final int initIndex;

  @override
  State<DeliveryHistoryPage> createState() => _DeliveryHistoryPageState();
}

class _DeliveryHistoryPageState extends State<DeliveryHistoryPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: 4, vsync: this, initialIndex: widget.initIndex);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: widget.initIndex,
      length: 4,
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            // brightness: Theme.of(context).brightness,
            // backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            title: Text(
              "history".tr,
              // style:
              //     TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            elevation: 0,
            centerTitle: true,
            // bottom: TabBar(
            //   isScrollable: true,
            //   indicatorColor: Theme.of(context).primaryColor,
            //   labelColor: Theme.of(context).primaryColor,
            //   unselectedLabelColor: Colors.black,
            //   tabs: [
            //     Tab(
            //       text: "pending".tr,
            //     ),
            //     Tab(text: "toPickup".tr),
            //     Tab(text: "delivering".tr),
            //     Tab(text: "completed".tr),
            //   ],
            // ),
          ),
          body: DefaultTabController(
            // initialIndex: widget.initIndex,
            length: 4,
            child: Column(
              children: [
                ///--search widget
                // Container(
                //   padding: EdgeInsets.symmetric(horizontal: 15),
                //   // color: Colors.red,
                //   color: Theme.of(context).appBarTheme.backgroundColor,
                //   child: Row(
                //     children: [
                //
                //       Expanded(
                //         child: Container(
                //           child: TextFormField(
                //             style: TextStyle(
                //               fontWeight: FontWeight.w400,
                //               fontSize: 14,
                //               color: Colors.black,
                //             ),
                //             keyboardType: TextInputType.text,
                //             // controller: controller.searchController,
                //             decoration: InputDecoration(
                //               fillColor: Colors.grey[200],
                //               filled: true,
                //               contentPadding: EdgeInsets.symmetric(
                //                   vertical: 10, horizontal: 10),
                //               // labelText: 'search'.tr,
                //               hintText: 'search'.tr,
                //               border: OutlineInputBorder(
                //                 borderRadius: BorderRadius.circular(
                //                     12), // Set the border radius here
                //               ),
                //               enabledBorder: OutlineInputBorder(
                //                 borderRadius: BorderRadius.circular(
                //                     12), // Border radius for the enabled state
                //                 borderSide: BorderSide(
                //                   color: Colors
                //                       .white, // Customize the color of the border
                //                   width: 1.5, // Border width
                //                 ),
                //               ),
                //               focusedBorder: OutlineInputBorder(
                //                 borderRadius: BorderRadius.circular(
                //                     12), // Border radius when the field is focused
                //                 borderSide: BorderSide(
                //                   color:
                //                       Colors.blue, // Border color when focused
                //                   width: 2.0,
                //                 ),
                //               ),
                //             ),
                //             onChanged: (value) {
                //               // controller.searchDevice(value);
                //             },
                //           ),
                //         ),
                //       ),
                //       IconButton(
                //         onPressed: () {
                //           // controller.onClear();
                //         },
                //         icon: Icon(
                //           Icons.replay_circle_filled,
                //           color: Colors.green[300],
                //           size: 35.0,
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  splashFactory: NoSplash.splashFactory,
                  splashBorderRadius: BorderRadius.circular(30.0),
                  indicatorColor: Colors.transparent,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.black,
                  dividerColor: Colors.transparent,
                  indicatorPadding: EdgeInsets.symmetric(horizontal: 0),
                  labelPadding: EdgeInsets.symmetric(horizontal: 8),
                  indicator: BoxDecoration(), // disables all TabBar indicators
                  tabs: List.generate(4, (index) {
                    final titles = [
                      "pending".tr,
                      "toPickup".tr,
                      "delivering".tr,
                      "completed".tr,
                    ];
                    final isSelected = _tabController.index == index;

                    return Tab(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 14.0, vertical: 5.0),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.green : Colors.grey[300],
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: Text(
                          titles[index],
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    );
                  }),

                  // [
                  //   Tab(
                  //     child: Container(
                  //       padding: EdgeInsets.symmetric(
                  //           horizontal: 14.0, vertical: 5.0),
                  //       decoration: BoxDecoration(
                  //           color: Colors.green,
                  //           border: Border.all(width: 1, color: Colors.green),
                  //           borderRadius: BorderRadius.circular(30.0)),
                  //       child: Text("pending".tr),
                  //     ),
                  //     // text: "pending".tr,
                  //   ),
                  //   Tab(text: "toPickup".tr),
                  //   Tab(text: "delivering".tr),
                  //   Tab(text: "completed".tr),
                  // ],
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      DeliveryPendingItemList(
                        transportType: widget.transportType,
                      ),
                      DeliveryPickupItemList(
                        transportType: widget.transportType,
                      ),
                      DeliveryDeliveringItemList(
                        transportType: widget.transportType,
                      ),
                      DeliveryCompletedItemList(
                        transportType: widget.transportType,
                      ),
                    ],
                  ),
                )
              ],
            ),
          )),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _tabController.dispose();
    super.dispose();
  }
}
