import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:extended_image/extended_image.dart';
import 'package:fardinexpress/features/account/controller/account_controller.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/feature/transport/controller/transport_controller.dart';
import 'package:fardinexpress/features/express/controller/express_controller.dart';
import 'package:fardinexpress/features/taxi/controller/taxi_controller.dart';
import 'package:fardinexpress/features/taxi/view/widget/taxi_drop_location.dart';
import 'package:fardinexpress/utils/bloc/indexing/indexing_bloc.dart';
import 'package:fardinexpress/utils/bloc/indexing/indexing_event.dart';
import 'package:fardinexpress/utils/component/widget/dialog_message_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class MapPickerScreen extends StatefulWidget {
  @override
  MapPickerScreenState createState() => MapPickerScreenState();
}

class MapPickerScreenState extends State<MapPickerScreen> {
  MapController? controller;
  GeoPoint? selectedLocation =
      GeoPoint(latitude: 11.567251825418735, longitude: 104.90324335580355);
  final _formKey = GlobalKey<FormState>();

  TransportController? _transportController;
  final ExpressController _expressController =
      Get.put(ExpressController(), tag: "taxi");
  final AccountController _accountController = Get.find<AccountController>();
  String tranType = "";
  String address = "No address selected";

  /// passanger pick up
  TextEditingController pickupPhone = TextEditingController();
  TextEditingController pickupAddress = TextEditingController();
  TextEditingController pickupLat = TextEditingController();
  TextEditingController pickupLong = TextEditingController();

  TextEditingController mapUrlCtr = TextEditingController();

  /// Passenger drop off
  static TextEditingController dropPhone = TextEditingController();
  static TextEditingController dropAddress = TextEditingController();
  static TextEditingController dropLat = TextEditingController();
  static TextEditingController dropLong = TextEditingController();

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
    controller = MapController.withPosition(initPosition: selectedLocation!);
    controller = MapController.withUserPosition(
        trackUserLocation: UserTrackingOption(
      enableTracking: false,
      unFollowUser: false,
    ));
    _setupLocationChangeListener();
    _transportController =
        Get.put(TransportController("vehicle".toLowerCase()), tag: "taxi");
  }

  void _setupLocationChangeListener() {
    controller!.listenerMapSingleTapping.addListener(() async {
      Position position = await Geolocator.getCurrentPosition(
          locationSettings: LocationSettings(accuracy: LocationAccuracy.high));
      GeoPoint pickedLocation =
          GeoPoint(latitude: position.latitude, longitude: position.longitude);
      // print(
      //     'Marker moved to: ${pickedLocation.latitude}, ${pickedLocation.longitude}');
      setState(() {
        selectedLocation = pickedLocation;
      });
    });
    _getAddressFromCoordinates(
        selectedLocation!.latitude, selectedLocation!.longitude);
    print("get Location: " + selectedLocation!.latitude.toString());
  }

  Future<void> _getAddressFromCoordinates(
      double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        setState(() {
          // Constructing a readable address
          address = "${place.street}, ${place.locality}, ${place.country}";
        });
        pickupAddress.text = address;
        pickupLat.text = latitude.toString();
        pickupLong.text = longitude.toString();
      }
    } catch (e) {
      print("Error occurred while getting address: $e");
      if (mounted) {
        setState(() {
          address = "Unable to retrieve address";
        });
      }
    }
  }

  Future<void> _requestLocationPermission() async {
    bool locationServiceEnabled = await Geolocator.isLocationServiceEnabled();
    LocationPermission permission = await Geolocator.checkPermission();

    if (!locationServiceEnabled) {
      AwesomeDialog(
        dismissOnTouchOutside: false,
        dismissOnBackKeyPress: false,
        context: context,
        dialogType: DialogType.noHeader,
        animType: AnimType.scale,
        title: 'Permission Denied',
        desc:
            'Location service is permanently denied. Open settings to enable it.',
        btnOkOnPress: () {
          openAppSettings();
        },
      ).show();
      // await Geolocator.openLocationSettings();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      AwesomeDialog(
        dismissOnTouchOutside: false,
        dismissOnBackKeyPress: false,
        context: context,
        dialogType: DialogType.noHeader,
        animType: AnimType.scale,
        title: 'Permission Denied',
        desc:
            'Location permission is permanently denied. Open settings to enable it.',
        btnOkOnPress: () {
          openAppSettings();
        },
      ).show();
      // await Geolocator.requestPermission();
    } else {
      controller!.currentLocation();
    }
  }

  Future<void> _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    GeoPoint currentLocation = GeoPoint(
      latitude: position.latitude,
      longitude: position.longitude,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "bookNow".tr,
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        // elevation: 0,
        backgroundColor: Colors.green,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Expanded(
              flex: 11,
              child: Stack(
                children: [
                  if (controller != null)
                    OSMFlutter(
                      controller: controller!,
                      onMapMoved: (region) async {
                        selectedLocation = await region.center;
                        print(
                            "Selected Location: ${selectedLocation.toString()}");
                        Future.delayed(Duration(seconds: 3), () {
                          _getAddressFromCoordinates(selectedLocation!.latitude,
                              selectedLocation!.longitude);
                        });
                        // setState(() {
                        //   // print(
                        //   //     "Selected Location: ${selectedLocation.toString()}");
                        //   Future.delayed(Duration(seconds: 5), () {
                        //     _getAddressFromCoordinates(
                        //         selectedLocation!.latitude,
                        //         selectedLocation!.longitude);
                        //   });
                        // });
                      },
                      osmOption: OSMOption(
                        // userTrackingOption: UserTrackingOption(enableTracking: true),
                        showZoomController: true,
                        zoomOption: ZoomOption(
                          initZoom: 16,
                          minZoomLevel: 2,
                          maxZoomLevel: 18,
                        ),
                        isPicker: _expressController.isShowPicker.value,
                        // userTrackingOption: UserTrackingOption(
                        //   enableTracking: true,
                        // )
                        // markerOption: MarkerOption(
                        //   advancedPickerMarker: MarkerIcon(
                        //     icon: Icon(
                        //       Icons.location_on,
                        //       color: Colors.red,
                        //       size: Platform.isIOS ? 40 : 100,
                        //     ),
                        //   ),
                        //   defaultMarker: MarkerIcon(
                        //     icon: Icon(
                        //       Icons.location_on,
                        //       color: Colors.green,
                        //       size: Platform.isIOS ? 40 : 100,
                        //     ),
                        //   ),
                        // ),
                      ),
                    )
                  else
                    Container(),
                  Positioned(
                    top: 20,
                    left: 0,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 100,
                      child: Obx(() {
                        if (_accountController.isLoading.value ||
                            _transportController!.isLoading.value) {
                          return Center(child: CircularProgressIndicator());
                        }
                        return transportType(context);
                      }),
                    ),
                  ),

                  // Zoom In Button
                  Positioned(
                    bottom: 330,
                    right: 10,
                    child: FloatingActionButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12)), // Custom radius
                      ),
                      heroTag: "zoomIn",
                      mini: true,
                      backgroundColor: Colors.black
                          .withValues(red: 0, green: 0, blue: 0, alpha: 0.6),
                      child: Icon(Icons.add),
                      onPressed: () async {
                        double currentZoom = await controller!.getZoom();
                        if (currentZoom < 18)
                          await controller!.setZoom(zoomLevel: currentZoom + 1);
                      },
                    ),
                  ),
                  // Zoom Out Button
                  Positioned(
                    bottom: 290,
                    right: 10,
                    child: FloatingActionButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(12),
                            bottomRight: Radius.circular(12)), // Custom radius
                      ),
                      heroTag: "zoomOut",
                      mini: true,
                      backgroundColor: Colors.black
                          .withValues(red: 0, green: 0, blue: 0, alpha: 0.6),
                      child: Icon(Icons.remove),
                      onPressed: () async {
                        double currentZoom = await controller!.getZoom();
                        if (currentZoom > 2)
                          await controller!.setZoom(zoomLevel: currentZoom - 1);
                      },
                    ),
                  ),
                  Positioned(
                    bottom: 220,
                    right: 10,
                    child: FloatingActionButton(
                      shape: CircleBorder(),
                      backgroundColor: Colors.black.withValues(
                        alpha: 0.6,
                      ),
                      child: Icon(Icons.near_me_rounded, color: Colors.white),
                      onPressed: () async {
                        // _getCurrentLocation();
                        await controller!.currentLocation();
                      },
                    ),
                  ),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.person_pin,
                        color: Colors.blue,
                        size: 40,
                      ),
                    ),
                  ),
                  Positioned(
                      bottom: 220,
                      left: 10,
                      child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 4.0, vertical: 0.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.0),
                            color: Colors.white.withOpacity(0.4),
                          ),
                          child: Text(
                            "Anakut Map",
                            style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold),
                          ))),
                  Positioned(
                    bottom: 0,
                    // right: 20,
                    child: Container(
                      padding: EdgeInsets.only(top: 14.0),
                      width: MediaQuery.of(context).size.width,
                      // height: 350,
                      color: Colors.white,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                flex: 9,
                                child: Container(
                                  margin:
                                      EdgeInsets.symmetric(horizontal: 12.0),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.person_pin,
                                          color: Colors.blue),
                                      SizedBox(width: 8),
                                      Expanded(
                                        child: TextField(
                                          readOnly: true,
                                          controller: pickupAddress,
                                          decoration: InputDecoration(
                                            hintText: "Current Location",
                                            border: InputBorder.none,
                                          ),
                                        ),
                                      ),
                                      // Icon(Icons.camera_alt_outlined,
                                      //     color: Colors.grey),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // SizedBox(height: 12),
                          Icon(Icons.keyboard_double_arrow_down_sharp),
                          Row(
                            children: [
                              Expanded(
                                flex: 9,
                                child: Container(
                                  margin:
                                      EdgeInsets.symmetric(horizontal: 12.0),
                                  padding: EdgeInsets.symmetric(horizontal: 12),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.location_on_rounded,
                                          color: Colors.red),
                                      SizedBox(width: 8),
                                      Expanded(
                                        child: TextField(
                                          readOnly: true,
                                          onTap: () {
                                            // Get.to(() => TaxiPickerLocation(
                                            //       phone: _accountController
                                            //           .accountInfo.phone,
                                            //     ));
                                          },
                                          controller:
                                              MapPickerScreenState.dropAddress,
                                          decoration: InputDecoration(
                                            hintText: "whereTo".tr,
                                            border: InputBorder.none,
                                          ),
                                        ),
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            child: IconButton(
                                              style: IconButton.styleFrom(
                                                elevation: 2,
                                                // border radius 12
                                                backgroundColor: Colors.white,
                                              ),
                                              onPressed: () {
                                                showDialog(
                                                  barrierDismissible: false,
                                                  context: Get.context!,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      // backgroundColor: Color,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                      ),
                                                      title: Text(
                                                          "${'search'.tr} ${'location'.tr}",
                                                          style: TextStyle(
                                                              // color: Colors
                                                              //     .white
                                                              )),
                                                      content: Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.8,
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: <Widget>[
                                                            Container(
                                                              // color: Colors.red,
                                                              child:
                                                                  Image.asset(
                                                                'assets/img/pin-location.jpg',
                                                                width: double
                                                                    .infinity,
                                                                fit: BoxFit
                                                                    .contain,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                                height: 10),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Text(
                                                                    "📍 ${'Paste google map url here'.tr}",
                                                                    style: TextStyle(
                                                                        // color: Colors
                                                                        //     .white
                                                                        )),
                                                                // Replace with the latest app version
                                                              ],
                                                            ),
                                                            Form(
                                                              key: _formKey,
                                                              child: Container(
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        top: 10,
                                                                        bottom:
                                                                            10),
                                                                child:
                                                                    TextFormField(
                                                                        controller:
                                                                            mapUrlCtr,
                                                                        decoration:
                                                                            InputDecoration(
                                                                          border:
                                                                              OutlineInputBorder(
                                                                            borderSide:
                                                                                BorderSide(
                                                                              width: 1,
                                                                              color: Colors.grey,
                                                                            ),
                                                                            borderRadius:
                                                                                BorderRadius.circular(8.0),
                                                                          ),
                                                                          hintStyle:
                                                                              TextStyle(color: Colors.grey),
                                                                          hintText:
                                                                              "https://maps.app.goo.gl/...",
                                                                        ),
                                                                        validator:
                                                                            (value) {
                                                                          if (value!
                                                                              .isEmpty) {
                                                                            return "required".tr;
                                                                          }
                                                                          return null;
                                                                        }),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      actions: <Widget>[
                                                        ElevatedButton(
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                                  side: BorderSide(
                                                                      color: Colors
                                                                          .green)),
                                                          child:
                                                              Text("cancel".tr),
                                                          onPressed: () async {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                        ),
                                                        ElevatedButton(
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            backgroundColor:
                                                                Colors.green,
                                                          ),
                                                          child: Text(
                                                            "Go".tr,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                          onPressed: () async {
                                                            if (_formKey
                                                                .currentState!
                                                                .validate()) {
                                                              Navigator.pop(
                                                                  context);
                                                              _expressController
                                                                  .getLatLngFromGoogleMap(
                                                                      '${mapUrlCtr.text}');
                                                            }
                                                          },
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              },
                                              icon: Icon(
                                                CupertinoIcons.map_pin_ellipse,
                                                color: Colors.red,
                                              ),
                                            ),
                                          ),
                                          // SizedBox(width: 10),
                                          IconButton(
                                            style: IconButton.styleFrom(
                                              elevation: 2,
                                              shape: CircleBorder(),
                                              backgroundColor: Colors.white,
                                            ),
                                            onPressed: () {
                                              Get.to(() => LocationListScreen(
                                                    phone: _accountController
                                                        .accountInfo.phone,
                                                  ));
                                            },
                                            icon: Icon(
                                              Icons.search,
                                              color: Colors.blue,
                                            ),
                                          ),
                                        ],
                                      )
                                      // Icon(Icons.camera_alt_outlined,
                                      //     color: Colors.grey),
                                    ],
                                  ),
                                ),
                              ),
                              // Expanded(
                              //   flex: 1,
                              //   child: IconButton(
                              //     icon: Icon(
                              //       Icons.location_on_rounded,
                              //       color: Colors.red,
                              //     ),
                              //     onPressed: () {
                              //       // _getCurrentLocation();
                              //       // Get.to(() => TaxiPickerLocation());
                              //     },
                              //   ),
                              // )
                            ],
                          ),
                          SizedBox(height: 8),
                          Container(
                            // padding: EdgeInsets.symmetric(
                            //     horizontal:
                            //         MediaQuery.of(context).size.width * 0.1,
                            //     vertical: 10.0),
                            padding: EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 10.0),
                            // padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            width: MediaQuery.of(context).size.width,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 14.0),
                                backgroundColor: Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                              ),
                              onPressed: () async {
                                // Get picked location from the picker
                                // Position position =
                                //     await Geolocator.getCurrentPosition(
                                //         desiredAccuracy: LocationAccuracy.high);
                                // GeoPoint pickedLocation = GeoPoint(
                                //     latitude: position.latitude,
                                //     longitude: position.longitude);
                                /// old code
                                // GeoPoint pickedLocation = await controller!
                                //     .getCurrentPositionAdvancedPositionPicker();

                                // setState(() {
                                //   selectedLocation = pickedLocation;
                                // });

                                // Move the map to the selected location
                                await controller!
                                    .changeLocation(selectedLocation!);

                                // Re-enable picker mode to keep `advancedPickerMarker` visible
                                // await controller!.advancedPositionPicker();
                                await controller!.addMarker(selectedLocation!);

                                // Get and update address
                                await _getAddressFromCoordinates(
                                  selectedLocation!.latitude,
                                  selectedLocation!.longitude,
                                );
                                _expressController.isShowPicker.value = true;
                                // print(
                                //     "Selected Location: ${selectedLocation!.latitude}, ${selectedLocation!.longitude}");
                                if (selectedLocation!.latitude.toString() ==
                                        "0.0" &&
                                    selectedLocation!.longitude.toString() ==
                                        "0.0") {
                                  // AwesomeDialog(
                                  //   dismissOnTouchOutside: false,
                                  //   dismissOnBackKeyPress: false,
                                  //   context: context,
                                  //   dialogType: DialogType.noHeader,
                                  //   animType: AnimType.scale,
                                  //   title: 'Alert',
                                  //   desc:
                                  //       'Location permission is permanently denied. Open settings to enable it.',
                                  //   btnOkOnPress: () {
                                  //     openAppSettings();
                                  //   },
                                  // ).show();
                                  DialogMessageWidget.show(
                                    context: context,
                                    title: "Alert",
                                    message:
                                        "Location permission is permanently denied. Open settings to enable it.",
                                    success: 0,
                                    onOk: () {
                                      openAppSettings();
                                    },
                                  );
                                } else {
                                  // Alert(
                                  //   type: AlertType.info,
                                  //   context: context,
                                  //   closeIcon: Container(),
                                  //   style: AlertStyle(
                                  //     titlePadding: EdgeInsets.all(0),
                                  //     descTextAlign: TextAlign.center,
                                  //     descStyle: TextStyle(
                                  //       fontSize: 18,
                                  //     ),
                                  //   ),
                                  //   title: "",
                                  //   desc: "confirmPickup?".tr,
                                  //   buttons: [
                                  //     DialogButton(
                                  //       child: Text(
                                  //         "cancel".tr,
                                  //         style: TextStyle(
                                  //             color: Colors.white,
                                  //             fontSize: 20),
                                  //       ),
                                  //       onPressed: () {
                                  //         Navigator.pop(context);
                                  //       },
                                  //       color: Colors.red,
                                  //       radius: BorderRadius.circular(8.0),
                                  //     ),
                                  //     DialogButton(
                                  //       child: Text(
                                  //         "confirm".tr,
                                  //         style: TextStyle(
                                  //             color: Colors.white,
                                  //             fontSize: 20),
                                  //       ),
                                  //       onPressed: () {
                                  //         Navigator.pop(context);
                                  //         print(
                                  //             "Transport id1: ${_transportController!.tempTranId.value}");
                                  //         _expressController.toRequestPickup(
                                  //             deliveryType: "taxi",
                                  //             senderPhone: _accountController
                                  //                 .accountInfo.phone,
                                  //             senderAddress: address,
                                  //             senderLat: selectedLocation!
                                  //                 .latitude
                                  //                 .toString(),
                                  //             senderLong: selectedLocation!
                                  //                 .longitude
                                  //                 .toString(),
                                  //             receiverLat: dropLat.text,
                                  //             receiverLong: dropLong.text,
                                  //             receiverPhone: dropPhone.text,
                                  //             receiverAddress: dropAddress.text,
                                  //             note: "",
                                  //             paymentNote: "yes",
                                  //             total: "0",
                                  //             transportId: _transportController!
                                  //                 .tempTranId.value,
                                  //             showTransportType: "human",
                                  //             currencyId: '',
                                  //             deliveryFee: '0');
                                  //       },
                                  //       color: Color.fromRGBO(0, 179, 134, 1.0),
                                  //       radius: BorderRadius.circular(8.0),
                                  //     ),
                                  //   ],
                                  // ).show();
                                  DialogMessageWidget.show(
                                    context: context,
                                    title: "confirmPickup?".tr,
                                    message: "Click OK to confirm pickup.",
                                    success: 2,
                                    onOk: () {
                                      _expressController.toRequestPickup(
                                          deliveryType: "taxi",
                                          senderPhone: _accountController
                                              .accountInfo.phone,
                                          senderAddress: address,
                                          senderLat: selectedLocation!.latitude
                                              .toString(),
                                          senderLong: selectedLocation!
                                              .longitude
                                              .toString(),
                                          receiverLat: dropLat.text,
                                          receiverLong: dropLong.text,
                                          receiverPhone: dropPhone.text,
                                          receiverAddress: dropAddress.text,
                                          note: "",
                                          paymentNote: "yes",
                                          total: "0",
                                          transportId: _transportController!
                                              .tempTranId.value,
                                          showTransportType: "human",
                                          currencyId: '',
                                          deliveryFee: '0');
                                    },
                                  );
                                }
                              },
                              child: Text(
                                "bookNow".tr,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget transportType(BuildContext _) {
    return BlocBuilder(
      bloc: selectingBloc,
      builder: (BuildContext context, dynamic state) {
        return Obx(() {
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _transportController!.transports.length,
            itemBuilder: (context, index) {
              final transport = _transportController!.transports[index];
              if (_transportController!.transports.length > 0) {
                tranType = _transportController!.transports[0].id.toString();
                // _transportController.tempTranId.value =
                //     _transportController.transports[0].id.toString();
              }
              return GestureDetector(
                onTap: () {
                  selectingBloc.add(Taped(index: index));
                  // tranType = _transportController.transports[index].id.toString();
                  _transportController!.tempTranId.value =
                      _transportController!.transports[index].id.toString();
                  print(
                      "Transport id: ${_transportController!.tempTranId.value}");
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 4.0),
                  padding: EdgeInsets.symmetric(horizontal: 5.0),
                  // height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: index == state
                        ? Colors.amber
                        : Colors.white.withOpacity(0.7),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 7,
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: Padding(
                            padding: EdgeInsets.all(6.0),
                            child: ExtendedImage.network(
                              transport.image,
                              cacheWidth: 50,
                              cacheHeight: 50,
                              // enableMemoryCache: true,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      // SizedBox(height: 5),
                      Expanded(
                        flex: 3,
                        child: Text(
                          transport.name.toString(),
                          style: TextStyle(
                            height: 1.5,
                            color: index == state ? Colors.white : Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 8),
                    ],
                  ),
                ),
              );
            },
          );
        });
      },
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    pickupAddress.clear();
    pickupLat.clear();
    pickupLong.clear();
    dropAddress.clear();
    dropLat.clear();
    dropLong.clear();
    dropPhone.clear();
    controller!.dispose();
    Get.find<TaxiController>().initTaxiRidding('taxi');
    super.dispose();
  }
}
