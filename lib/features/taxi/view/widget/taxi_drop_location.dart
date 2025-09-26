import 'package:fardinexpress/features/express/controller/express_controller.dart';
import 'package:fardinexpress/features/taxi/view/widget/taxi_map_osm.dart';
import 'package:fardinexpress/features/taxi/view/widget/taxi_picker_location.dart';
import 'package:fardinexpress/utils/component/widget/empty_data_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Location {
  final String name;
  final String address;
  final double distance;

  Location({
    required this.name,
    required this.address,
    required this.distance,
  });
}

class LocationListScreen extends StatefulWidget {
  final String phone;
  const LocationListScreen({Key? key, required this.phone}) : super(key: key);
  @override
  State<LocationListScreen> createState() => _LocationListScreenState();
}

class _LocationListScreenState extends State<LocationListScreen> {
  final taxiController = Get.find<ExpressController>(tag: 'taxi');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    taxiController.getLocationDetailList('Toul Kork');
  }

  // final List<Location> locations = [
  //   Location(
  //     name: 'NA03 Twin Rd Borey Sambour Meas Dangkor',
  //     address: 'Twin Road, Dang Kor, Dang Kor, Phnom Penh, Cambodia, 120501',
  //     distance: 5.9,
  //   ),
  //   Location(
  //     name: 'Store E90 Borey Keila Building E',
  //     address: 'Street 211, Veal Vong, 7 Makara, Phnom Penh, Cambodia, 120307',
  //     distance: 0.7,
  //   ),
  //   Location(
  //     name: 'Barak Recycle Shop Japan',
  //     address: 'Street 56d7, Dang Kor, Dang Kor, Phnom Penh, Cambodia, 120501',
  //     distance: 5.6,
  //   ),
  //   Location(
  //     name: 'Mey Mey Pho and Cafe',
  //     address: 'Street 92, Khmounh, Sen Sok, Phnom Penh, Cambodia, 120803',
  //     distance: 5.9,
  //   ),
  //   Location(
  //     name: 'KSR Construction Materials',
  //     address: 'St Betong, Dang Kor, Dang Kor, Phnom Penh, Cambodia, 120501',
  //     distance: 5.8,
  //   ),
  //   Location(
  //     name: 'Rang Sey Beauty Salon',
  //     address: 'Street 211, Veal Vong, 7 Makara, Phnom Penh, Cambodia, 120307',
  //     distance: 0.7,
  //   ),
  //   Location(
  //     name: 'Sokheng Auto Garage',
  //     address:
  //         'Street 269, Tuek Laak 3, Toul Kouk, Phnom Penh, Cambodia, 120406',
  //     distance: 1.7,
  //   ),
  //   Location(
  //     name: 'N89A St 286 Olympic',
  //     address:
  //         'Street 286, Olympic, Boeng Keng Kang, Phnom Penh, Cambodia, 121304',
  //     distance: 1.6,
  //   ),
  //   Location(
  //     name: 'N89A St 286 Olympic',
  //     address:
  //         'Street 286, Olympic, Boeng Keng Kang, Phnom Penh, Cambodia, 121304',
  //     distance: 1.6,
  //   ),
  //   Location(
  //     name: 'N89A St 286 Olympic',
  //     address:
  //         'Street 286, Olympic, Boeng Keng Kang, Phnom Penh, Cambodia, 121304',
  //     distance: 1.6,
  //   ),
  // ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text(''),
      // ),
      body: SafeArea(
        child: Obx(() {
          final locationList = taxiController.filteredLocationDetailList.isEmpty
              ? taxiController.locationDetailList
              : taxiController.filteredLocationDetailList;

          if (taxiController.isDataProcessing.value) {
            return Center(child: CircularProgressIndicator());
          }
          if (locationList.isEmpty) {
            return EmptyDataWidget();
          } else {
            return Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        // color: Colors.blue,
                        margin: EdgeInsets.only(left: 15),
                        child: IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: Icon(Icons.arrow_back_ios),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 9,
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        // color: Colors.red,
                        width: double.infinity,
                        child: TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                              elevation: 0,
                              backgroundColor: Colors.grey[200],
                              // shape: RoundedRectangleBorder(
                              //     borderRadius: BorderRadius.circular(18)),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 0)),
                          child: TextField(
                            controller: taxiController.searchController,
                            onChanged: (value) async {
                              await Future.delayed(Duration(seconds: 2), () {
                                taxiController.filterLocationByName(value);
                              });
                            },
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.zero,
                              // labelText: "search".tr,
                              hintText: "search".tr,
                              prefixIcon: Icon(Icons.search),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none),
                            ),
                          ),

                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //   children: [
                          //     Row(
                          //       children: [
                          //         Icon(
                          //           Icons.search_outlined,
                          //           color: Colors.black,
                          //         ),
                          //         SizedBox(width: 10),
                          //         Text(
                          //           "search".tr,
                          //           style: TextStyle(color: Colors.grey[700]),
                          //           textScaleFactor: 1,
                          //         ),
                          //       ],
                          //     ),
                          //     // Icon(
                          //     //   CupertinoIcons.camera_fill,
                          //     //   color: Colors.grey[700],
                          //     // ),
                          //   ],
                          // ),
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                    child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 100),
                  itemCount: locationList.length,
                  itemBuilder: (context, index) {
                    final locationDetails = locationList[index];
                    return ListTile(
                      onTap: (){
                        MapPickerScreenState.dropAddress.text = locationDetails.locationDetailData.locationName;
                        MapPickerScreenState.dropLat.text = locationDetails.locationGeometryData.latLng[0].toString();
                        MapPickerScreenState.dropLong.text = locationDetails.locationGeometryData.latLng[1].toString();
                        Get.back();
                      },
                      leading: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.access_time, color: Colors.blue),
                          Text('0.5 km', style: const TextStyle(fontSize: 12)),
                        ],
                      ),
                      title: Text(
                          locationDetails.locationDetailData.locationName,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14)),
                      subtitle: Text(locationDetails.locationDetailData.label,
                          style: TextStyle(
                              color: Colors.grey.shade700, fontSize: 12)),
                      trailing: const Icon(Icons.more_vert),
                    );
                  },
                ))
              ],
            );
          }
        }),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(16),
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () {
            Get.off(() => TaxiPickerLocation(phone: widget.phone
                // _accountController
                //     .accountInfo.phone,
                ));
          },
          icon: const Icon(Icons.map),
          label: const Text("Choose on map"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
        ),
      ),
    );
  }
}
