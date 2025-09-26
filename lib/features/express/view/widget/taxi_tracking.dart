import 'package:fardinexpress/features/account/controller/account_controller.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/shared/widget/error_sneakbar.dart';
import 'package:fardinexpress/features/express/controller/express_controller.dart';
import 'package:fardinexpress/features/express/view/widget/trip_summary_dialog.dart';
import 'package:fardinexpress/features/messager/bloc/chat_bloc.dart';
import 'package:fardinexpress/features/messager/bloc/chat_event.dart';
import 'package:fardinexpress/features/messager/bloc/chat_state.dart';
import 'package:fardinexpress/features/messager/model/chat_user_model.dart';
import 'package:fardinexpress/features/messager/screen/messager_page.dart';
import 'package:fardinexpress/features/taxi/controller/taxi_controller.dart';
import 'package:fardinexpress/services/api_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

// enum TranType { newTask, toPickup, onDelivery }

class TrackingLocation extends StatefulWidget {
  final String status;
  const TrackingLocation({Key? key, required this.status}) : super(key: key);

  @override
  _TrackingLocationState createState() => _TrackingLocationState();
}

class _TrackingLocationState extends State<TrackingLocation> {
  String address = "No address selected";
  ApiProvider apiProvider = ApiProvider();
  final ExpressController _expressController =
      Get.put(ExpressController(), tag: "taxi");
  late ChatBloc _chatBloc;
  // MapController? controller;
  // GeoPoint? selectedLocation =
  //     GeoPoint(latitude: 11.567251825418735, longitude: 104.90324335580355);
  List listOfPoints = [];
  List<LatLng> points = [];

  double picLat = 11.56739982648142;
  double picLong = 104.90293622016907;

  double droLat = 11.568105809591117;
  double droLong = 104.91083979606628;

  // Method to consume the OpenRouteService API
  getCoordinates(
      double picLat, double picLong, double drpLat, double drpLong) async {
    // Requesting for openrouteservice api
    var response = await apiProvider.fetchRoute(
        start: GeoPoint(latitude: picLat, longitude: picLong),
        end: GeoPoint(latitude: drpLat, longitude: drpLong));

    setState(() {
      listOfPoints = response;
      points = listOfPoints
          .map((p) => LatLng(p[1].toDouble(), p[0].toDouble()))
          .toList();
      // if (response.statusCode == 200) {
      //   var data = jsonDecode(response.body);
      //   listOfPoints = data['features'][0]['geometry']['coordinates'];
      //   points = listOfPoints
      //       .map((p) => LatLng(p[1].toDouble(), p[0].toDouble()))
      //       .toList();
      // }
    });
  }

  @override
  void initState() {
    super.initState();
    // Get.find<TaxiController>().initTaxiRidding("taxi");
    // getCoordinates();
    _expressController.getRiddingDeliveryList(
        status: widget.status, transportType: "taxi");
    // Ensure the data is available before calling getCoordinates
    Future.delayed(Duration(seconds: 2), () {
      if (_expressController.taxiBookingDetail == null) {
        return getCoordinates(
          picLat,
          picLong,
          droLat,
          droLong,
        );
      } else {
        return getCoordinates(
          _expressController.taxiBookingDetail!.pickupLat,
          _expressController.taxiBookingDetail!.pickupLong,
          _expressController.taxiBookingDetail!.receiverLat == 0.0
              ? _expressController.taxiBookingDetail!.pickupLat
              : _expressController.taxiBookingDetail!.receiverLat,
          _expressController.taxiBookingDetail!.receiverLong == 0.0
              ? _expressController.taxiBookingDetail!.pickupLong
              : _expressController.taxiBookingDetail!.receiverLong,
        ).then((value) {
          if (_expressController.taxiBookingDetail!.customerRating.toString() ==
                  "null" &&
              _expressController.taxiBookingDetail!.status == "completed") {
            TripSummaryDialog.show(
                context, _expressController.taxiBookingDetail!);
          }
        });
      }
    });
    _chatBloc = ChatBloc();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text("bookingDetail".tr),
          // backgroundColor: Colors.transparent,
          centerTitle: true,
          elevation: 0,
          actions: [
            // IconButton(
            //     onPressed: () {
            //       TripSummaryDialog.show(
            //           context, _expressController.taxiBookingDetail!);
            //     },
            //     icon: Icon(
            //       Icons.info,
            //       color: Colors.blue,
            //     )),
            IconButton(
                onPressed: () async {
                  await _expressController.getRiddingDeliveryList(
                      status: widget.status, transportType: "taxi");
                  Future.delayed(Duration(milliseconds: 500), () {
                    return getCoordinates(
                      _expressController.taxiBookingDetail!.pickupLat,
                      _expressController.taxiBookingDetail!.pickupLong,
                      _expressController.taxiBookingDetail!.receiverLat,
                      _expressController.taxiBookingDetail!.receiverLong,
                    );
                  });
                  // getCoordinates(getCoordinates(controller.taxiBookingDetail!.pickupLat, controller.taxiBookingDetail!.pickupLong, controller.taxiBookingDetail!.receiverLat, controller.taxiBookingDetail!.receiverLong););
                },
                icon: Icon(
                  Icons.refresh,
                  color: Colors.green,
                ))
          ],
        ),
        body: BlocListener(
          bloc: _chatBloc,
          listener: (context, state) {
            if (state is GettingUsers) {
              EasyLoading.show(
                status: 'Loading...',
              );
            } else if (state is GotUsers) {
              EasyLoading.dismiss(); // close dialog
              if (state.users.isNotEmpty) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => MessengerPage(
                              user: state.users.first,
                              channelId: state.users.first.channelId,
                              userModel:
                                  Get.find<AccountController>().accountInfo,
                            )));
              } else {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => MessengerPage(
                              user: ChatUserModel(
                                id: "0",
                                name: _expressController
                                    .taxiBookingDetail!.driverName,
                                image: _expressController
                                    .taxiBookingDetail!.deliveryImage,
                                channelId: null,
                                lastMessage: "",
                                time: '',
                                fromId: "0",
                                messageId: "0",
                                phone: _expressController
                                    .taxiBookingDetail!.driverPhone,
                                email: _expressController
                                    .taxiBookingDetail!.driverPhone,
                                userType: "user",
                                memberSince: "",
                                attachments: [],
                              ),
                              channelId: null,
                              userModel:
                                  Get.find<AccountController>().accountInfo,
                            )));
              }
            } else if (state is ErrorGetUsers) {
              EasyLoading.dismiss();
              errorSnackBar(text: state.error, context: context);
            }
          },
          child: GetBuilder<ExpressController>(
              init: ExpressController(),
              tag: "taxi",
              builder: (controller) {
                if (controller.isLoading.value == true) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  // getCoordinates(
                  //     controller.taxiBookingDetail!.pickupLat,
                  //     controller.taxiBookingDetail!.pickupLong,
                  //     controller.taxiBookingDetail!.receiverLat,
                  //     controller.taxiBookingDetail!.receiverLong);
                  return Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Stack(
                          children: [
                            FlutterMap(
                              options: MapOptions(
                                initialZoom: 16,
                                initialCenter: LatLng(picLat, picLong),
                              ),
                              children: [
                                // Layer that adds the map
                                TileLayer(
                                  urlTemplate:
                                      "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                                  userAgentPackageName:
                                      'dev.fleaflet.flutter_map.example',
                                ),
                                // Layer that adds points the map
                                MarkerLayer(
                                  markers: [
                                    // First Marker
                                    Marker(
                                        point: LatLng(
                                            _expressController
                                                .taxiBookingDetail!.pickupLat,
                                            _expressController
                                                .taxiBookingDetail!.pickupLong),
                                        width: 80,
                                        height: 80,
                                        child: IconButton(
                                          onPressed: () {},
                                          icon: const Icon(Icons.location_on),
                                          color: Colors.green,
                                          iconSize: 45,
                                        )),
                                    // Second Marker
                                    controller.taxiBookingDetail!.receiverLat ==
                                                0 ||
                                            controller.taxiBookingDetail!
                                                    .receiverLong ==
                                                0
                                        ? Marker(
                                            point: LatLng(0, 0),
                                            child: Container(),
                                          )
                                        : Marker(
                                            point: LatLng(
                                                _expressController
                                                    .taxiBookingDetail!
                                                    .receiverLat,
                                                _expressController
                                                    .taxiBookingDetail!
                                                    .receiverLong),
                                            width: 80,
                                            height: 80,
                                            child: IconButton(
                                              onPressed: () {},
                                              icon:
                                                  const Icon(Icons.location_on),
                                              color: Colors.red,
                                              iconSize: 45,
                                            )),
                                  ],
                                ),

                                // Polylines layer
                                controller.taxiBookingDetail!.receiverLat ==
                                            0 ||
                                        controller.taxiBookingDetail!
                                                .receiverLong ==
                                            0
                                    ? Container()
                                    : PolylineLayer(
                                        // polylineCulling: false,
                                        polylines: [
                                          Polyline(
                                              points: points,
                                              color: Colors.blue,
                                              strokeWidth: 3),
                                        ],
                                      ),
                              ],
                            ),

                            ///note here
                            // OSMFlutter(
                            //   controller: controller!,
                            //   osmOption: OSMOption(
                            //       // userTrackingOption: UserTrackingOption(enableTracking: true),
                            //       showZoomController: true,
                            //       zoomOption: ZoomOption(
                            //         initZoom: 18,
                            //         minZoomLevel: 2,
                            //         maxZoomLevel: 18,
                            //       ),
                            //       isPicker: true,
                            //       markerOption: MarkerOption(
                            //           advancedPickerMarker: MarkerIcon(
                            //         icon: Icon(
                            //           Icons.location_on,
                            //           color: Colors.red,
                            //           size: 100,
                            //         ),
                            //       ))),
                            // ),
                          ],
                        ),
                        Positioned(
                          top: 0,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: Colors.white,
                            ),
                            padding: EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //tran id
                                // Row(
                                //   mainAxisAlignment: MainAxisAlignment.start,
                                //   children: [
                                //     Text(
                                //       'Transaction ID:  ',
                                //       style: TextStyle(
                                //           // fontSize: 18,
                                //           // fontWeight: FontWeight.bold,
                                //           ),
                                //       textAlign: TextAlign.end,
                                //     ),
                                //     Text(
                                //       ' No.${controller.taxiBookingDetail!.id}',
                                //       style: TextStyle(
                                //         // fontSize: 18,
                                //         fontWeight: FontWeight.bold,
                                //       ),
                                //       textAlign: TextAlign.end,
                                //     ),
                                //   ],
                                // ),
                                // SizedBox(height: 18),
                                // Title
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      'No.${controller.taxiBookingDetail!.id}',
                                      style: TextStyle(
                                        // fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.end,
                                    ),
                                    Text(
                                      '${controller.taxiBookingDetail!.date}',
                                      style: TextStyle(
                                        // fontSize: 18,
                                        color: Colors.grey[600],
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.end,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 18),

                                // Pick Location & Drop Location Container
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    _buildLocationCard(
                                        title: 'Pick Location',
                                        location:
                                            '${controller.taxiBookingDetail!.senderAddress}',
                                        time: '23:03 PM',
                                        icon: Icon(
                                          Icons.person_pin,
                                        ),
                                        iconColor: Colors.blue),
                                    // SizedBox(height: 10.0),
                                    Container(
                                      margin: EdgeInsets.only(left: 16.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Icon(
                                            Icons.circle,
                                            size: 8,
                                            color: Colors.grey,
                                          ),
                                          Icon(
                                            Icons.circle,
                                            size: 8,
                                            color: Colors.grey,
                                          ),
                                          Icon(
                                            Icons.circle,
                                            size: 8,
                                            color: Colors.grey,
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Container(
                                    //   margin: EdgeInsets.only(left: 6.0),
                                    //   child: Icon(
                                    //     Icons.arrow_drop_down,
                                    //     size: 20.0,
                                    //     color: Colors.red,
                                    //   ),
                                    // ),
                                    SizedBox(height: 10.0),
                                    // controller.taxiBookingDetail!.receiverLat ==
                                    //             0 ||
                                    //         controller.taxiBookingDetail!
                                    //                 .receiverLong ==
                                    //             0
                                    //     ? SizedBox.shrink()
                                    //     :
                                    _buildLocationCard(
                                        title: 'Drop Location',
                                        location:
                                            '${controller.taxiBookingDetail!.receiverLat == 0 || controller.taxiBookingDetail!.receiverLong == 0 || controller.taxiBookingDetail!.receiverAddress == "null" ? "" : controller.taxiBookingDetail!.receiverAddress}',
                                        time: '23:13 PM',
                                        icon: Icon(
                                          Icons.pin_drop_outlined,
                                        ),
                                        iconColor: Colors.red),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        controller.taxiBookingDetail!.driverName.toString() ==
                                    "none" ||
                                controller.taxiBookingDetail!.driverName
                                        .toString() ==
                                    "" ||
                                controller.taxiBookingDetail!.driverPhone
                                        .toString() ==
                                    "none" ||
                                controller.taxiBookingDetail!.driverPhone
                                        .toString() ==
                                    ""
                            ? Container()
                            : Positioned(
                                bottom: 0,
                                child: GestureDetector(
                                  onTap: () => _travelingDetails(
                                      context: context,
                                      status: widget.status,
                                      driverId: controller
                                          .taxiBookingDetail!.driverId,
                                      driverName: controller
                                          .taxiBookingDetail!.driverName,
                                      driverPhone: controller
                                          .taxiBookingDetail!.driverPhone,
                                      date: controller.taxiBookingDetail!.date!,
                                      duration: controller
                                          .taxiBookingDetail!.duration,
                                      distance: controller
                                          .taxiBookingDetail!.distance,
                                      transportType: controller
                                          .taxiBookingDetail!.transportType),
                                  child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(16.0),
                                          topRight: Radius.circular(16.0),
                                        ),
                                      ),
                                      width: MediaQuery.of(context).size.width,
                                      height: 50,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20.0),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("showDetail".tr,
                                                style: TextStyle(
                                                    color: Colors.blue,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Icon(
                                              Icons.arrow_drop_up_sharp,
                                              color: Colors.blue,
                                            )
                                          ])),
                                )
                                // tranvelDetails(
                                //   status: widget.status,
                                //   driverId:
                                //       controller.taxiBookingDetail!.driverId,
                                //   driverName:
                                //       controller.taxiBookingDetail!.driverName,
                                //   driverPhone:
                                //       controller.taxiBookingDetail!.driverPhone,
                                // )
                                ),
                        Positioned(
                            bottom: 80,
                            left: 10,
                            child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 4.0, vertical: 0.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4.0),
                                  color: Colors.white.withOpacity(0.5),
                                ),
                                child: Text(
                                  "Anakut Map",
                                  style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold),
                                ))),
                      ],
                    ),
                  );
                }
              }),
        ));
  }

  // Location card widget
  Widget _buildLocationCard({
    required String title,
    required String location,
    required String time,
    required Icon icon,
    required Color iconColor,
  }) {
    return Container(
      width: MediaQuery.of(context).size.width,
      // padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        // border: Border.all(color: Colors.grey.shade300),
        // boxShadow: [
        //   BoxShadow(
        //       color: Colors.grey.shade200, blurRadius: 4, offset: Offset(0, 2)),
        // ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title (Pick or Drop)
          Expanded(
            flex: 1,
            child: Icon(
              icon.icon,
              color: iconColor,
            ),
          ),
          SizedBox(width: 8),
          // Location
          Expanded(
            flex: 8,
            child: Text(
              location,
              style: TextStyle(fontSize: 12),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // SizedBox(width: 8),
          // // Time
          // Expanded(
          //   flex: 2,
          //   child: Text(
          //     time,
          //     style: TextStyle(
          //       fontSize: 12,
          //       color: Colors.grey,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  void _travelingDetails(
      {required BuildContext context,
      required String status,
      required String driverId,
      required String driverName,
      required String driverPhone,
      required String date,
      required String duration,
      required String distance,
      required String transportType}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.5, // Adjust height as needed
          child: Container(
            // height: status == "completed" ? 350 : 150,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        // color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            // <-- makes the first section wrap text if needed
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 35,
                                  backgroundColor: Colors.grey[300],
                                  backgroundImage:
                                      AssetImage('assets/img/hint-avatar.png'),
                                ),
                                SizedBox(width: 15.0),
                                Expanded(
                                  // <-- allows text to wrap
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "$driverName - ID$driverId",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        softWrap: true,
                                      ),
                                      Text(
                                        "$transportType",
                                        style: TextStyle(color: Colors.grey),
                                        softWrap: true,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.deepOrange,
                                ),
                                child: IconButton(
                                  padding: EdgeInsets.all(0),
                                  onPressed: () {
                                    _chatBloc.add(GetUsersStart(
                                      formEmail: Get.find<AccountController>()
                                          .accountInfo
                                          .phone,
                                      toEmail: driverPhone,
                                    ));
                                  },
                                  icon: Icon(Icons.chat_outlined,
                                      color: Colors.white),
                                ),
                              ),
                              SizedBox(width: 8),
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.green,
                                ),
                                child: IconButton(
                                  padding: EdgeInsets.all(0),
                                  onPressed: () {
                                    launchUrl(Uri.parse("tel:$driverPhone"));
                                  },
                                  icon: Icon(Icons.phone, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )

                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     Row(
                      //       children: [
                      //         CircleAvatar(
                      //             radius: 35,
                      //             backgroundColor: Colors.grey[300],
                      //             backgroundImage:
                      //                 AssetImage('assets/img/hint-avatar.png')),
                      //         SizedBox(
                      //           width: 15.0,
                      //         ),
                      //         Column(
                      //           crossAxisAlignment: CrossAxisAlignment.start,
                      //           children: [
                      //             Text(
                      //               "${driverName} - ID${driverId}",
                      //               style: TextStyle(
                      //                   fontSize: 16,
                      //                   fontWeight: FontWeight.bold),
                      //             ),
                      //             Text("${transportType}",
                      //                 style: TextStyle(color: Colors.grey)),
                      //           ],
                      //         ),
                      //       ],
                      //     ),
                      //     Row(
                      //       mainAxisSize: MainAxisSize.min,
                      //       children: [
                      //         Container(
                      //           // margin: EdgeInsets.only(right: 8),
                      //           padding: EdgeInsets.all(0),
                      //           decoration: BoxDecoration(
                      //               shape: BoxShape.circle,
                      //               color: Colors.deepOrange),
                      //           child: IconButton(
                      //               padding: EdgeInsets.all(0),
                      //               onPressed: () {
                      //                 // launchUrl(Uri.parse("tel:${driverPhone}"));
                      //                 _chatBloc.add(GetUsersStart(
                      //                     formEmail: '0965203040',
                      //                     toEmail: driverPhone));
                      //               },
                      //               icon: Icon(Icons.chat_outlined,
                      //                   color: Colors.white)),
                      //         ),
                      //         SizedBox(width: 8),
                      //         Container(
                      //           // margin: EdgeInsets.only(right: 8),
                      //           padding: EdgeInsets.all(0),
                      //           decoration: BoxDecoration(
                      //               shape: BoxShape.circle, color: Colors.green),
                      //           child: IconButton(
                      //               padding: EdgeInsets.all(0),
                      //               onPressed: () {
                      //                 launchUrl(Uri.parse("tel:${driverPhone}"));
                      //               },
                      //               icon: Icon(Icons.phone, color: Colors.white)),
                      //         ),
                      //       ],
                      //     )
                      //   ],
                      // ),
                      ),
                  // Container(
                  //   margin: EdgeInsets.only(top: 10.0),
                  //   child: Divider(
                  //     thickness: 0.7,
                  //   ),
                  // ),
                  SizedBox(height: 20.0),
                  status == "completed"
                      ? Container(
                          padding: EdgeInsets.symmetric(vertical: 10.0),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _infoTile("Duration", "${duration}"),
                              _infoTile("Distance", "${distance}"),
                            ],
                          ),
                        )
                      : SizedBox.shrink(),
                  // Container(
                  //   margin: EdgeInsets.symmetric(vertical: 10.0),
                  //   child: Divider(),
                  // ),
                  status == "completed"
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Transaction Date:",
                              style: TextStyle(
                                  fontSize: 18,
                                  // fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                            ),
                            Text(
                              "${date}",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        )
                      : SizedBox.shrink(),
                  status == "completed"
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Total:",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.grey),
                            ),
                            Text(
                              "5,800 KHR",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange),
                            ),
                          ],
                        )
                      : SizedBox.shrink(),
                  // SizedBox(height: 4),
                  // Row(
                  //   children: [
                  //     Icon(Icons.check_circle, color: Colors.orange),
                  //     SizedBox(width: 5),
                  //     Text("Finished and paid",
                  //         style: TextStyle(color: Colors.grey)),
                  //   ],
                  // ),
                  // status == "completed" ? Divider() : SizedBox.shrink(),
                  // Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  //   _sectionTitle("Payment Method"),
                  //   Row(
                  //     children: [
                  //       Icon(Icons.account_balance_wallet, size: 24),
                  //       SizedBox(width: 8),
                  //       Text("Cash", style: TextStyle(fontSize: 16)),
                  //     ],
                  //   ),
                  // ]),
                  // Divider(),
                  // Divider(
                  //   thickness: 0.7,
                  // ),
                  // Text("Report any issue", style: TextStyle(color: Colors.grey)),
                  // _sectionTitle("Tel: +85510601168"),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Widget tranvelDetails({
  //   required String status,
  //   required String driverId,
  //   required String driverName,
  //   required String driverPhone,
  // }) {
  //   return Card(
  //     // margin: EdgeInsets.all(16),
  //     child: Container(
  //       height: status == "completed" ? 350 : 150,
  //       width: MediaQuery.of(context).size.width,
  //       padding: EdgeInsets.all(16),
  //       child: SingleChildScrollView(
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             status == "completed"
  //                 ? Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     children: [
  //                       _infoTile("Duration", "12 m"),
  //                       _infoTile("Distance", "3.46 km"),
  //                     ],
  //                   )
  //                 : SizedBox.shrink(),
  //             Divider(
  //               thickness: 0.7,
  //             ),
  //             status == "completed"
  //                 ? Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     children: [
  //                       Text(
  //                         "Total:",
  //                         style: TextStyle(
  //                             fontSize: 18, fontWeight: FontWeight.bold),
  //                       ),
  //                       Text(
  //                         "5,800 KHR",
  //                         style: TextStyle(
  //                             fontSize: 18,
  //                             fontWeight: FontWeight.bold,
  //                             color: Colors.orange),
  //                       ),
  //                     ],
  //                   )
  //                 : SizedBox.shrink(),
  //             // SizedBox(height: 4),
  //             // Row(
  //             //   children: [
  //             //     Icon(Icons.check_circle, color: Colors.orange),
  //             //     SizedBox(width: 5),
  //             //     Text("Finished and paid",
  //             //         style: TextStyle(color: Colors.grey)),
  //             //   ],
  //             // ),
  //             status == "completed" ? Divider() : SizedBox.shrink(),
  //             // Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
  //             //   _sectionTitle("Payment Method"),
  //             //   Row(
  //             //     children: [
  //             //       Icon(Icons.account_balance_wallet, size: 24),
  //             //       SizedBox(width: 8),
  //             //       Text("Cash", style: TextStyle(fontSize: 16)),
  //             //     ],
  //             //   ),
  //             // ]),
  //             // Divider(),
  //             Row(
  //               children: [
  //                 CircleAvatar(
  //                     radius: 40,
  //                     backgroundColor: Colors.grey[300],
  //                     backgroundImage:
  //                         AssetImage('assets/img/hint-avatar.png')),
  //                 SizedBox(
  //                   width: 20.0,
  //                 ),
  //                 Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     Text(
  //                       "${driverName} - ID${driverId}",
  //                       style: TextStyle(
  //                           fontSize: 16, fontWeight: FontWeight.bold),
  //                     ),
  //                     Text("${driverPhone}",
  //                         style: TextStyle(color: Colors.grey)),
  //                     Text("Rickshaw", style: TextStyle(color: Colors.grey)),
  //                     // SizedBox(height: 4),
  //                     // Row(
  //                     //   children: List.generate(
  //                     //       5,
  //                     //       (index) =>
  //                     //           Icon(Icons.star_border, color: Colors.grey)),
  //                     // ),
  //                   ],
  //                 ),
  //               ],
  //             ),
  //             Divider(
  //               thickness: 0.7,
  //             ),
  //             // Text("Report any issue", style: TextStyle(color: Colors.grey)),
  //             // _sectionTitle("Tel: +85510601168"),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _infoTile(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(value,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Text(title, style: TextStyle(color: Colors.grey)),
      ],
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    // controller!.dispose();
    Get.find<TaxiController>().initTaxiRidding('taxi');
    _chatBloc.close();
    super.dispose();
  }
}
