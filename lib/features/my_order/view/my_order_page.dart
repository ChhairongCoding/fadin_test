import 'package:fardinexpress/features/my_order/view/widget/order_item_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyOrderPage extends StatefulWidget {
  MyOrderPage({required this.initIndex});
  final int initIndex;

  @override
  State<MyOrderPage> createState() => _MyOrderPageState();
}

class _MyOrderPageState extends State<MyOrderPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
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
        appBar: AppBar(
          // brightness: Theme.of(context).brightness,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          centerTitle: true,
          title: Text(
            "myOrder".tr,
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            textScaleFactor: 1.1,
          ),
          bottom: TabBar(
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
              indicator: BoxDecoration(),
              tabs: List.generate(4, (index) {
                final titles = [
                  "toPay".tr,
                  "paid".tr,
                  "delivering".tr,
                  "completed".tr
                ];
                final isSelected = _tabController.index == index;
                return Tab(
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 14.0, vertical: 5.0),
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
              })
              // [
              //   Tab(
              //     text: "To Pay",
              //   ),
              //   Tab(text: "Paid"),
              //   Tab(text: "On Delivery"),
              //   Tab(text: "Completed"),
              // ],
              ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            OrderItemList(
              status: 'pending',
            ),
            OrderItemList(
              status: 'paid',
            ),
            OrderItemList(
              status: 'delivering',
            ),
            OrderItemList(
              status: 'completed',
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _tabController.dispose();
    super.dispose();
  }
}
