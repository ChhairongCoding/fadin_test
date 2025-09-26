import 'package:fardinexpress/features/app/extend_app_logistic/feature/branch_address/controller/branch_address_controller.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/feature/delivery/repositories/delivery_listing_repository.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/feature/delivery/screens/widgets/delivery_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeliveryByInternationalPage extends StatelessWidget {
  // final BranchAddressController _countryController =
  //     Get.put(BranchAddressController(), tag: "country");

  @override
  Widget build(BuildContext context) {
    Future<bool?> selectWidgets(Widget dynamicWidget, String title) {
      return showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              // backgroundColor: Theme.of(context).primaryColor,
              title: Container(
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(2.0)),
                width: MediaQuery.of(context).size.width,
                child: Text(
                  title,
                  style: TextStyle(color: Colors.white),
                ),
              ),
              content: dynamicWidget,
              actions: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      // if (_zoneController.zoneList.length != 0) {
                      //   _zoneController.zoneList.clear();
                      // } else {}
                      // Navigator.pop(context);
                    },
                    child: Text("Done"))
              ],
            );
          });
    }

    return new DefaultTabController(
      length: 3,
      child: new Scaffold(
        backgroundColor: Colors.white,
        appBar: new AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          centerTitle: true,
          leading: IconButton(
            color: Colors.white,
            icon: Icon(Icons.arrow_back_outlined),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          actions: [
            // IconButton(
            //     onPressed: () => selectWidgets(countryListWidget(), "Country"),
            //     icon: Icon(
            //       Icons.menu_open_outlined,
            //       color: Colors.white,
            //     ))
          ],
          title: new Text("Foreign Warehouse",
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: Colors.white)),
          // bottom: new TabBar(
          //   indicatorSize: TabBarIndicatorSize.label,
          //   indicatorColor: Colors.white,
          //   labelColor: Colors.white,
          //   labelStyle: TextStyle(color: Colors.white),
          //   tabs: <Widget>[
          //     Tab(
          //       text: "កំពុងរងចាំ",
          //     ),
          //     Tab(
          //       text: "កំពុងដំណើរការ",
          //     ),
          //     Tab(
          //       text: "បានបញ្ចប់",
          //     ),
          //   ],
          // ),
        ),
        body: DeliveryList(
          arrivedLocal: false,
          deliveryListingRepository: DeliveryListByInternationRepo(),
          countryId: "21",
        ),
      ),
    );
  }

  // Widget countryListWidget() {
  //   return Container(
  //       width: 300,
  //       height: 500,
  //       child: Obx(() {
  //         if (_countryController.isLoading.value) {
  //           return Center(child: CircularProgressIndicator());
  //         } else {
  //           return ListView.builder(
  //               shrinkWrap: true,
  //               itemCount: _countryController.countryList.length,
  //               itemBuilder: (context, index) {
  //                 return ListTile(
  //                   onTap: () {
  //                     // receiverLat.text = _zoneController.zoneList[index].lat;
  //                     // receiverLong.text = _zoneController.zoneList[index].long;
  //                     // zoneCtr.text = _zoneController.zoneList[index].name;
  //                     // feeCtr.text =
  //                     //     'Book Now  Total : ${_zoneController.zoneList[index].fee} \$';
  //                     Navigator.pop(context);
  //                   },
  //                   title: Text(
  //                     _countryController.countryList[index].name.toString(),
  //                     style: TextStyle(color: Colors.black),
  //                   ),
  //                   // subtitle: Text(_countryController
  //                   //         .countryList[index].serviceFee
  //                   //         .toString() +
  //                   //     "\$"),
  //                 );
  //               });
  //         }
  //       }));
  // }
}
