// import 'dart:io';
// import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/feature/branch_address/controller/branch_address_controller.dart';
import 'package:fardinexpress/features/express/view/delivery_local.dart';
import 'package:fardinexpress/features/zone/controller/zone_controller.dart';
import 'package:fardinexpress/utils/component/widget/dialog_message_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_map/flutter_map.dart';
// import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';

enum AddressDertailType { sender, receiver, location }

class AddressFormPage extends StatefulWidget {
  final AddressDertailType addressDertailType;
  final String transportType;
  const AddressFormPage(
      {Key? key, required this.addressDertailType, required this.transportType})
      : super(key: key);
  @override
  AddressFormPageState createState() => AddressFormPageState();
}

class AddressFormPageState extends State<AddressFormPage> {
  // TextEditingController provincesCtr = TextEditingController();
  // TextEditingController districtCtr = TextEditingController();
  late FocusNode _focusAddressDetail, _focusReceiverPhone, _focusSenderPhone;

  BranchAddressController _branchAddressController =
      Get.put(BranchAddressController(), tag: "province");
  BranchAddressController _districtController =
      Get.put(BranchAddressController(), tag: "district");
  ZoneController _zoneController = Get.put(ZoneController(), tag: "zone");
  String? proId;
  MapController controller = MapController();
  LatLng selectedLocation = LatLng(11.567251825418735, 104.90324335580355);
  List<Marker> markers = [];

  TextEditingController addressNote = TextEditingController();

  String address = "No address selected";
  // static AddressFormBloc addressFormBloc = AddressFormBloc();
  @override
  void initState() {
    super.initState();
    _focusAddressDetail = FocusNode();
    _focusReceiverPhone = FocusNode();
    _focusSenderPhone = FocusNode();
    _requestLocationPermission();
    // controller = MapController.withPosition(initPosition: selectedLocation!);
    // controller = MapController.withUserPosition(
    //     trackUserLocation: UserTrackingOption(
    //   enableTracking: false,
    //   unFollowUser: false,
    // ));
    // _setupLocationChangeListener();
    _zoneController.getZoneList();
    _zoneController.paginateZoneList();
  }

  // void _setupLocationChangeListener() {
  //   controller!.listenerMapLongTapping.addListener(() async {
  //     Position position = await Geolocator.getCurrentPosition(
  //         locationSettings: LocationSettings(accuracy: LocationAccuracy.high));
  //     GeoPoint pickedLocation =
  //         GeoPoint(latitude: position.latitude, longitude: position.longitude);
  //     // GeoPoint pickedLocation =
  //     //     await controller!.getCurrentPositionAdvancedPositionPicker();
  //     setState(() {
  //       selectedLocation = pickedLocation;
  //     });
  //   });
  // }

  void _updateSelectedLocation(LatLng newLocation) {
    setState(() {
      selectedLocation = newLocation;
      markers = [
        Marker(
            point: newLocation,
            child: Icon(
              Icons.location_on,
              color: Colors.red,
            )),
      ];
    });

    debugPrint(
        "Updated Location: ${newLocation.latitude}, ${newLocation.longitude}");
  }

  Future<void> _getAddressFromCoordinates(
      double latitude, double longitude) async {
    try {
      EasyLoading.show(status: 'loading...', dismissOnTap: false);
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        EasyLoading.dismiss();
        Placemark place = placemarks[0];
        setState(() {
          // Constructing a readable address
          address = "${place.street}, ${place.locality}, ${place.country}";
        });
      }
    } catch (e) {
      EasyLoading.dismiss();
      print("Error occurred while getting address: $e");
      setState(() {
        address = "Unable to retrieve address";
      });
    }
  }

  Future<void> _requestLocationPermission() async {
    bool locationServiceEnabled = await Geolocator.isLocationServiceEnabled();
    LocationPermission permission = await Geolocator.checkPermission();

    if (!locationServiceEnabled) {
      AwesomeDialog(
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
      // controller!.currentLocation();
    }
  }

  void _moveToCurrentLocation() async {
    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    final LatLng currentLatLng = LatLng(position.latitude, position.longitude);

    controller.move(currentLatLng, 16); // zoom to location
  }

  // Future<void> _getCurrentLocation() async {
  //   Position position = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high);

  //   GeoPoint currentLocation = GeoPoint(
  //     latitude: position.latitude,
  //     longitude: position.longitude,
  //   );

  //   if (controller != null) {
  //     setState(() {
  //       selectedLocation = currentLocation;
  //       controller!.changeLocationMarker(
  //           oldLocation: selectedLocation!, newLocation: currentLocation);
  //       // changeLocation(currentLocation);
  //       // controller!.addMarker(currentLocation);
  //     });
  //   }
  // }

  Future<bool?> selectWidgets(Widget dynamicWidget, String title) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: dynamicWidget,
            actions: [
              ElevatedButton(
                  onPressed: () {
                    if (_districtController.districtList.length != 0) {
                      _districtController.districtList.clear();
                    } else {}
                    Navigator.pop(context);
                  },
                  child: Text("Done"))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar:
          PreferredSize(preferredSize: Size.fromHeight(56), child: appBar()),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          // _focusAddressDetail.unfocus();
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Container(
                margin: EdgeInsets.only(left: 20, top: 0),
                alignment: Alignment.topLeft,
                child: Text(
                  (widget.addressDertailType == AddressDertailType.sender)
                      ? "${'address'.tr}${'sender'.tr}"
                      : "${'address'.tr}${'receiver'.tr}",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                  ),
                  textScaleFactor: 1.8,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: AspectRatio(
                      aspectRatio: 9 / 1.6, child: _senderPhoneField(context))),
              SizedBox(
                height: 5,
              ),
              (widget.transportType == "province" &&
                      widget.addressDertailType == AddressDertailType.receiver)
                  ? Column(
                      children: [
                        Container(
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            child: AspectRatio(
                                aspectRatio: 9 / 1.6,
                                child: provincesField(context))),
                        Container(
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            child: AspectRatio(
                                aspectRatio: 9 / 1.6,
                                child: districtField(context))),
                        // Container(
                        //     margin: EdgeInsets.symmetric(horizontal: 20),
                        //     child: AspectRatio(
                        //         aspectRatio: 9 / 1.6, child: zoneField(context))),
                      ],
                    )
                  : Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: AspectRatio(
                          aspectRatio: 9 / 1.6,
                          child: addressDetailField(context))),
              SizedBox(
                height: 5,
              ),
              (widget.transportType == "province" &&
                      widget.addressDertailType == AddressDertailType.receiver)
                  ? Container()
                  : (widget.transportType == "delivery" &&
                          widget.addressDertailType ==
                              AddressDertailType.receiver)
                      ? Container(
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          child: AspectRatio(
                              aspectRatio: 9 / 1.6, child: zoneField(context)))
                      : Container(
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AspectRatio(
                                  aspectRatio: 9 / 1.6,
                                  child: Container(
                                    margin: EdgeInsets.symmetric(vertical: 10),
                                    child: Row(
                                      children: [
                                        AspectRatio(
                                          aspectRatio: 4 / 4,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                  flex: 2, child: Center()),
                                              Expanded(
                                                  flex: 3,
                                                  child: AspectRatio(
                                                      aspectRatio: 4 / 4,
                                                      child: FittedBox(
                                                          fit: BoxFit.fill,
                                                          child: Icon(
                                                              Icons
                                                                  .location_pin,
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColor)))),
                                              Expanded(
                                                  flex: 2, child: Center()),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          "chooseOnMap".tr,
                                          textAlign: TextAlign.left,
                                          textScaleFactor: 1.1,
                                          style: TextStyle(letterSpacing: 0.3),
                                        )
                                      ],
                                    ),
                                  )),
                              AspectRatio(
                                aspectRatio: 22 / 20,
                                child: Stack(
                                  children: [
                                    FlutterMap(
                                      mapController: controller,
                                      options: MapOptions(
                                        initialCenter: LatLng(11.5564,
                                            104.9282), // default Phnom Penh
                                        initialZoom: 18,
                                        minZoom: 2,
                                        maxZoom: 18,
                                        onTap: (tapPosition, latlng) {
                                          _updateSelectedLocation(latlng as LatLng);
                                        },
                                        onMapEvent: (event) {
                                          if (event is MapEventMoveEnd) {
                                            _updateSelectedLocation(
                                                event.camera.center);
                                          }
                                        },
                                      ),
                                      children: [
                                        // Map tiles
                                        TileLayer(
                                          urlTemplate:
                                              "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                                          subdomains: const ['a', 'b', 'c'],
                                        ),

                                        // User selected markers
                                        MarkerLayer(markers: markers),
                                      ],
                                    ),
                                    // OSMFlutter(
                                    //   controller: controller!,
                                    //   onLocationChanged: (location) {
                                    //     setState(() {
                                    //       selectedLocation = location;
                                    //       print(
                                    //           "on location change: ${selectedLocation!.latitude.toString()}");
                                    //     });
                                    //   },
                                    //   onMapMoved: (region) {
                                    //     setState(() {
                                    //       selectedLocation = region.center;
                                    //       print(
                                    //           "Selected Location: ${selectedLocation.toString()}");
                                    //     });
                                    //   },
                                    //   onGeoPointClicked: (location) {
                                    //     setState(() {
                                    //       selectedLocation = location;
                                    //       controller!
                                    //           .addMarker(selectedLocation!);
                                    //       print(
                                    //           "On geo point clicked: ${selectedLocation!.latitude.toString()}");
                                    //     });
                                    //   },
                                    //   osmOption: OSMOption(
                                    //       // userTrackingOption: UserTrackingOption(enableTracking: true),
                                    //       showDefaultInfoWindow: true,
                                    //       showZoomController: true,
                                    //       zoomOption: ZoomOption(
                                    //         initZoom: 18,
                                    //         minZoomLevel: 2,
                                    //         maxZoomLevel: 18,
                                    //       ),
                                    //       isPicker: true,
                                    //       userLocationMarker: UserLocationMaker(
                                    //         personMarker: MarkerIcon(
                                    //           icon: Icon(
                                    //             Icons.location_on,
                                    //             color: Colors.blue,
                                    //             size: Platform.isIOS ? 40 : 100,
                                    //           ),
                                    //         ),
                                    //         directionArrowMarker: MarkerIcon(
                                    //           icon: Icon(
                                    //             Icons.location_on,
                                    //             color: Colors.green,
                                    //             size: Platform.isIOS ? 40 : 100,
                                    //           ),
                                    //         ),
                                    //       )
                                    //       // markerOption: MarkerOption(
                                    //       //     advancedPickerMarker: MarkerIcon(
                                    //       //   icon: Icon(
                                    //       //     Icons.location_on,
                                    //       //     color: Colors.red,
                                    //       //     size: Platform.isIOS ? 40 : 100,
                                    //       //   ),
                                    //       // ))
                                    //       ),
                                    // ),
                                    Positioned.fill(
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Icon(
                                          Icons.location_on,
                                          color: Colors.red,
                                          size: 40,
                                        ),
                                      ),
                                    ),
                                    // Zoom In Button
                                    Positioned(
                                      bottom: 110,
                                      right: 10,
                                      child: FloatingActionButton(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(12),
                                              topRight: Radius.circular(
                                                  12)), // Custom radius
                                        ),
                                        heroTag: "zoomIn",
                                        mini: true,
                                        backgroundColor: Colors.black
                                            .withValues(
                                                red: 0,
                                                green: 0,
                                                blue: 0,
                                                alpha: 0.6),
                                        child: Icon(Icons.add),
                                        onPressed: () async {
                                          // double currentZoom =
                                          //     await controller!.getZoom();
                                          // if (currentZoom < 18)
                                          //   await controller!.setZoom(
                                          //       zoomLevel: currentZoom + 1);
                                        },
                                      ),
                                    ),
                                    // Zoom Out Button
                                    Positioned(
                                      bottom: 70,
                                      right: 10,
                                      child: FloatingActionButton(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(12),
                                              bottomRight: Radius.circular(
                                                  12)), // Custom radius
                                        ),
                                        heroTag: "zoomOut",
                                        mini: true,
                                        backgroundColor: Colors.black
                                            .withValues(
                                                red: 0,
                                                green: 0,
                                                blue: 0,
                                                alpha: 0.6),
                                        child: Icon(Icons.remove),
                                        onPressed: () async {
                                          // double currentZoom =
                                          //     await controller!.getZoom();
                                          // if (currentZoom > 2)
                                          //   await controller!.setZoom(
                                          //       zoomLevel: currentZoom - 1);
                                        },
                                      ),
                                    ),
                                    Positioned(
                                        bottom: 20,
                                        right: 10,
                                        child: Container(
                                          // padding: EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color:
                                                Colors.black.withOpacity(0.6),
                                          ),
                                          child: IconButton(
                                            icon: Icon(
                                              Icons.near_me_rounded,
                                              color: Colors.white,
                                              size: 30,
                                            ),
                                            onPressed: () async {
                                              // await controller!
                                              //     .removeAllShapes();
                                              // controller!
                                              //     .addMarker(selectedLocation!);
                                              // _getCurrentLocation();
                                              // controller!.currentLocation();
                                              _moveToCurrentLocation();
                                            },
                                          ),
                                        )),
                                    Positioned(
                                        bottom: 20,
                                        left: 10,
                                        child: GestureDetector(
                                          onTap: () async {
                                            // await controller!.removeMarker(
                                            //     selectedLocation!);
                                          },
                                          child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 4.0,
                                                  vertical: 0.0),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(4.0),
                                                color: Colors.white
                                                    .withOpacity(0.4),
                                              ),
                                              child: Text(
                                                "Anakut Map",
                                                style: TextStyle(
                                                    color: Colors.green,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )),
                                        )),
                                  ],
                                ),
                              ),
                            ],
                          )),
              // Container(
              //   margin: EdgeInsets.symmetric(horizontal: 20),
              //   child: AspectRatio(
              //     aspectRatio: 22 / 20,
              //     child: LocationPickupPage(),
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }

  Widget _senderPhoneField(BuildContext context) {
    // final FocusNode inputNode = FocusNode();
    return Container(
      child: TextField(
        focusNode: _focusSenderPhone,
        controller: (widget.addressDertailType == AddressDertailType.sender)
            ? DeliveryLocalPageState.senderPhone
            : DeliveryLocalPageState.receiverPhone,
        keyboardType: TextInputType.phone,
        // minLines: 1, //Normal textInputField will be displayed
        maxLines: 1, //
        textAlign: TextAlign.start,
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(8.0),
            ),
            isDense: true,
            filled: true,
            fillColor: Colors.grey[200],
            alignLabelWithHint: true,
            hintText: "phone".tr),
      ),
    );
  }

  Widget addressDetailField(BuildContext context) {
    // final FocusNode inputNode = FocusNode();
    return Container(
      child: TextField(
        focusNode: _focusAddressDetail,
        controller: addressNote,
        // (widget.addressDertailType == AddressDertailType.sender)
        //     ? DeliveryLocalPageState.senderAddress
        //     : DeliveryLocalPageState.receiverAddress,
        keyboardType: TextInputType.multiline,
        // minLines: 1, //Normal textInputField will be displayed
        maxLines: 1, //
        textAlign: TextAlign.start,
        decoration: InputDecoration(
            border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(8.0)),
            isDense: true,
            filled: true,
            fillColor: Colors.grey[200],
            alignLabelWithHint: true,
            hintText: "addressNote".tr + ", home, floor, room number"),
      ),
    );
  }

  Widget provincesField(BuildContext context) {
    final FocusNode inputNode = FocusNode();
    return Container(
      child: TextField(
        focusNode: inputNode,
        controller: DeliveryLocalPageState.provinceCtr,
        // minLines: 1, //Normal textInputField will be displayed
        readOnly: true,
        onTap: () => selectWidgets(provinceListWidget(), "ជ្រើសរើសខេត្ត"),
        maxLines: 1, //
        textAlign: TextAlign.start,
        decoration: InputDecoration(
            border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(8.0)),
            isDense: true,
            filled: true,
            fillColor: Colors.grey[200],
            alignLabelWithHint: true,
            hintText: "ជ្រើសរើសខេត្ត"),
      ),
    );
  }

  Widget districtField(BuildContext context) {
    final FocusNode inputNode = FocusNode();
    return Container(
      child: TextField(
        focusNode: inputNode,
        controller: DeliveryLocalPageState.districtCtr,
        readOnly: true,
        onTap: () {
          if (DeliveryLocalPageState.provinceCtr.text == "") {
            selectWidgets(
                Center(
                  child: Text("ជ្រើសរើសខេត្តមុន"),
                ),
                "ជ្រើសរើសតំបន់");
          } else {
            selectWidgets(districtListWidget(context), "ជ្រើសរើសតំបន់");
          }
        },
        maxLines: 1, //
        textAlign: TextAlign.start,
        decoration: InputDecoration(
            border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(8.0)),
            isDense: true,
            filled: true,
            fillColor: Colors.grey[200],
            alignLabelWithHint: true,
            hintText: "ជ្រើសរើសតំបន់"),
      ),
    );
  }

  Widget zoneField(BuildContext context) {
    final FocusNode inputNode = FocusNode();
    return Container(
      child: TextField(
        focusNode: inputNode,
        controller: DeliveryLocalPageState.zoneCtr,
        // minLines: 1, //Normal textInputField will be displayed
        readOnly: true,
        onTap: () => selectWidgets(zoneListWidget(), "Select Zone"),
        maxLines: 1,
        textAlign: TextAlign.start,
        decoration: InputDecoration(
            border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(8.0)),
            isDense: true,
            filled: true,
            fillColor: Colors.grey[200],
            alignLabelWithHint: true,
            hintText: "Select Zone"),
      ),
    );
  }

  Widget appBar() => Builder(
      builder: (context) => AppBar(
            // brightness: Brightness.light,
            elevation: 0,
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: Icon(
                Icons.clear,
                color: Colors.red[300],
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            actions: [
              IconButton(
                icon: Icon(
                  Icons.check,
                  color: Colors.blue[300],
                ),
                onPressed: () async {
                  if (widget.transportType == "express" ||
                      widget.transportType == "cargo") {
                    await _getAddressFromCoordinates(
                        selectedLocation.latitude, selectedLocation.longitude);
                    if (widget.addressDertailType ==
                        AddressDertailType.sender) {
                      if (
                          // DeliveryLocalPageState.senderAddress.text == "" ||
                          DeliveryLocalPageState.senderPhone.text == "") {
                        DialogMessageWidget.show(
                          context: context,
                          title: "alert".tr,
                          message: "Please filled all the information.",
                          success: 2,
                          // onOk: () {},
                        );
                        // showDialog(
                        //     context: context,
                        //     builder: ((context) {
                        //       return AlertDialog(
                        //         title: Text("alert".tr),
                        //         content:
                        //             Text("Please filled all the information."),
                        //         actions: [
                        //           TextButton(
                        //             onPressed: () {
                        //               Navigator.pop(context);
                        //             },
                        //             child: Text("OK".tr),
                        //           )
                        //         ],
                        //       );
                        //     }));
                      } else {
                        if (addressNote.text.isNotEmpty) {
                          DeliveryLocalPageState.senderAddress.text =
                              '(${addressNote.text}) ${address}';
                        } else {
                          DeliveryLocalPageState.senderAddress.text = address;
                        }
                        DeliveryLocalPageState.senderLat.text =
                            selectedLocation.latitude.toString();
                        DeliveryLocalPageState.senderLong.text =
                            selectedLocation.longitude.toString();
                        // Navigator.of(context).pop();
                        Get.back(result: true);
                      }
                    } else {
                      if (
                          // DeliveryLocalPageState.receiverAddress.text == "" ||
                          DeliveryLocalPageState.receiverPhone.text == "") {
                        DialogMessageWidget.show(
                          context: context,
                          title: "alert".tr,
                          message: "Please filled all the information.",
                          success: 2,
                          // onOk: () {},
                        );
                        // DeliveryLocalPageState.receiverAddress.text =
                        //     provincesCtr.text + district.text;
                      } else {
                        DeliveryLocalPageState.receiverLat.text =
                            selectedLocation.latitude.toString();
                        DeliveryLocalPageState.receiverLong.text =
                            selectedLocation.longitude.toString();
                        if (addressNote.text.isNotEmpty) {
                          DeliveryLocalPageState.receiverAddress.text =
                              '(${addressNote.text}) ${address}';
                        } else {
                          DeliveryLocalPageState.receiverAddress.text = address;
                        }
                        // Navigator.of(context).pop();
                        Get.back(result: true);
                      }
                    }
                  } else if (widget.transportType == "province") {
                    if (widget.addressDertailType ==
                        AddressDertailType.sender) {
                      if (DeliveryLocalPageState.senderAddress.text == "" ||
                          DeliveryLocalPageState.senderPhone.text == "") {
                        DialogMessageWidget.show(
                          context: context,
                          title: "alert".tr,
                          message: "Please filled all the information.",
                          success: 2,
                          // onOk: () {},
                        );
                      } else {
                        // Navigator.of(context).pop();
                        Get.back(result: true);
                      }
                    } else {
                      if (DeliveryLocalPageState.provinceCtr.text == "" ||
                          DeliveryLocalPageState.districtCtr.text == "" ||
                          DeliveryLocalPageState.receiverPhone.text == "") {
                        DialogMessageWidget.show(
                          context: context,
                          title: "alert".tr,
                          message: "Please filled all the information.",
                          success: 2,
                          // onOk: () {},
                        );
                      } else {
                        // Navigator.of(context).pop();
                        Get.back(result: true);
                      }
                    }
                  } else {
                    if (widget.addressDertailType ==
                        AddressDertailType.sender) {
                      if (DeliveryLocalPageState.senderAddress.text == "" ||
                          DeliveryLocalPageState.senderPhone.text == "") {
                        DialogMessageWidget.show(
                          context: context,
                          title: "alert".tr,
                          message: "Please filled all the information.",
                          success: 2,
                          // onOk: () {},
                        );
                      } else {
                        // Navigator.of(context).pop();
                        Get.back(result: true);
                      }
                    } else {
                      if (DeliveryLocalPageState.zoneCtr.text == "" ||
                          DeliveryLocalPageState.receiverPhone.text == "") {
                        DialogMessageWidget.show(
                          context: context,
                          title: "alert".tr,
                          message: "Please filled all the information.",
                          success: 2,
                          // onOk: () {},
                        );
                        // DeliveryLocalPageState.receiverAddress.text =
                        //     provincesCtr.text + " ${districtCtr.text}";
                      } else {
                        if (addressNote.text.isNotEmpty) {
                          DeliveryLocalPageState.receiverAddress.text =
                              '(${addressNote.text}) ${DeliveryLocalPageState.zoneCtr.text}';
                        } else {
                          DeliveryLocalPageState.receiverAddress.text =
                              DeliveryLocalPageState.zoneCtr.text;
                        }
                        // Navigator.of(context).pop();
                        Get.back(result: true);
                      }
                    }
                  }
                },
              )
            ],
          ));

  _showSnackBar(String title, String message, Color bgColor) {
    Get.snackbar(title, message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: bgColor,
        colorText: Colors.white);
  }

  Widget provinceListWidget() {
    return Container(
        width: 300,
        height: 500,
        child: Obx(() {
          if (_branchAddressController.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          } else {
            return ListView.builder(
                shrinkWrap: true,
                itemCount: _branchAddressController.branchAddressList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      DeliveryLocalPageState.provinceCtr.text =
                          _branchAddressController
                              .branchAddressList[index].proNameKH!;
                      proId = _branchAddressController
                          .branchAddressList[index].proId!;
                      Navigator.pop(context);
                    },
                    title: Text(
                      _branchAddressController
                          .branchAddressList[index].proNameKH
                          .toString(),
                      style: TextStyle(color: Colors.black),
                    ),
                    // subtitle: Text(_currenciesBloc.currenciesList[index].rate
                    //     .toString()),
                  );
                });
          }
        }));
  }

  Widget districtListWidget(BuildContext c) {
    _districtController.getDistrictList(proId);
    return Container(
        width: 300,
        height: 500,
        child: Obx(() {
          if (_districtController.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          } else {
            return ListView.builder(
                shrinkWrap: true,
                itemCount: _districtController.districtList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      DeliveryLocalPageState.districtCtr.text =
                          _districtController.districtList[index].disNameKH!;
                      // log(deliveryTypeList[index]);
                      DeliveryLocalPageState.feeCtr.text =
                          "${_districtController.districtList[index].disFee!}";
                      _districtController.districtList.clear();
                      Navigator.pop(context);
                    },
                    title: Text(
                      _districtController.districtList[index].disNameKH!,
                      style: TextStyle(color: Colors.black),
                    ),
                    subtitle: Text(
                        "${_districtController.districtList[index].disFee} \$"),
                  );
                });
          }
        }));
  }

  Widget zoneListWidget() {
    return Obx(() {
      if (_zoneController.isDataProcessing.value) {
        return Center(child: CircularProgressIndicator());
      } else if (_zoneController.zoneList.isEmpty) {
        return Center(child: Text("No Zone Found"));
      } else {
        return Container(
          width: 300,
          height: 500,
          child: Column(
            children: [
              // Search TextField
              TextField(
                controller: _zoneController.searchController,
                onChanged: (value) {
                  _zoneController.filterZoneByName(value);
                },
                decoration: InputDecoration(
                  labelText: 'Search Zone',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
              ),
              Expanded(
                child: Obx(() {
                  // Use the filtered list for display
                  final zoneList = _zoneController.filteredZoneList.isEmpty
                      ? _zoneController.zoneList
                      : _zoneController.filteredZoneList;

                  if (_zoneController.isLoading.value) {
                    return Center(child: CircularProgressIndicator());
                  } else if (zoneList.isEmpty) {
                    return Center(child: Text("No Zones Found"));
                  } else {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: zoneList.length,
                      controller: _zoneController.scrollController,
                      itemBuilder: (context, index) {
                        return ListTile(
                          onTap: () {
                            DeliveryLocalPageState.receiverLat.text =
                                zoneList[index].lat;
                            DeliveryLocalPageState.receiverLong.text =
                                zoneList[index].long;
                            DeliveryLocalPageState.zoneCtr.text =
                                zoneList[index].name;
                            DeliveryLocalPageState.feeCtr.text =
                                zoneList[index].fee;
                            Navigator.pop(context);
                          },
                          title: Text(
                            zoneList[index].name.toString(),
                            style: TextStyle(color: Colors.black),
                          ),
                          subtitle: Text("${zoneList[index].fee}\$"),
                        );
                      },
                    );
                  }
                }),
              ),
            ],
          ),
        );
      }
    });
  }

  // Widget zoneListWidget() {
  //   return Obx(() {
  //     if (_zoneController.isDataProcessing.value) {
  //       return Center(child: CircularProgressIndicator());
  //     } else if (_zoneController.zoneList.isEmpty) {
  //       return Center(child: Text("No Zone Found"));
  //     } else {
  //       return Container(
  //           width: 300,
  //           height: 500,
  //           child: Obx(() {
  //             if (_zoneController.isLoading.value) {
  //               return Center(child: CircularProgressIndicator());
  //             } else {
  //               return Column(
  //                 children: [
  //                   TextField(
  //                     controller: _zoneController.searchController,
  //                     onChanged: (value) {
  //                       _zoneController.filterZoneByName(value);
  //                     },
  //                     decoration: InputDecoration(
  //                       labelText: 'Search Zone',
  //                       prefixIcon: Icon(Icons.search),
  //                       border: OutlineInputBorder(),
  //                     ),
  //                   ),
  //                   Expanded(
  //                     child: ListView.builder(
  //                         shrinkWrap: true,
  //                         itemCount: _zoneController.zoneList.length,
  //                         controller: _zoneController.scrollController,
  //                         itemBuilder: (context, index) {
  //                           return ListTile(
  //                             onTap: () {
  //                               // DeliveryLocalPageState.provinceCtr.text =
  //                               //     _branchAddressController
  //                               //         .branchAddressList[index].proNameKH!;
  //                               // proId = _branchAddressController
  //                               //     .branchAddressList[index].proId!;
  //                               DeliveryLocalPageState.receiverLat.text =
  //                                   _zoneController.zoneList[index].lat;
  //                               DeliveryLocalPageState.receiverLong.text =
  //                                   _zoneController.zoneList[index].long;
  //                               DeliveryLocalPageState.zoneCtr.text =
  //                                   _zoneController.zoneList[index].name;
  //                               DeliveryLocalPageState.feeCtr.text =
  //                                   _zoneController.zoneList[index].fee;
  //                               // 'Book Now  Total : ${_zoneController.zoneList[index].fee} \$';
  //                               Navigator.pop(context);
  //                             },
  //                             title: Text(
  //                               _zoneController.zoneList[index].name.toString(),
  //                               style: TextStyle(color: Colors.black),
  //                             ),
  //                             subtitle: Text(
  //                                 _zoneController.zoneList[index].fee + "\$"),
  //                           );
  //                         }),
  //                   ),
  //                 ],
  //               );
  //             }
  //           }));
  //     }
  //   });
  // }

  @override
  void dispose() {
    // addressFormBloc.close();
    _focusAddressDetail.dispose();
    _focusSenderPhone.dispose();
    _focusReceiverPhone.dispose();
    addressNote.clear();
    if (widget.transportType == "express" || widget.transportType == "cargo") {
      controller!.dispose();
    }
    super.dispose();
  }
}
