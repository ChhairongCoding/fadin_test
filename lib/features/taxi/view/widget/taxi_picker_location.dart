import 'package:fardinexpress/features/app/extend_app_logistic/feature/branch_address/controller/branch_address_controller.dart';
import 'package:fardinexpress/features/express/view/delivery_local.dart';
import 'package:fardinexpress/features/taxi/view/widget/taxi_map_osm.dart';
import 'package:fardinexpress/features/zone/controller/zone_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class TaxiPickerLocation extends StatefulWidget {
  final String phone;
  const TaxiPickerLocation({Key? key, required this.phone}) : super(key: key);
  @override
  TaxiPickerLocationState createState() => TaxiPickerLocationState();
}

class TaxiPickerLocationState extends State<TaxiPickerLocation> {
  // TextEditingController provincesCtr = TextEditingController();
  // TextEditingController districtCtr = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late FocusNode _focusAddressDetail, _focusReceiverPhone, _focusSenderPhone;

  MapController? controller;
  GeoPoint? selectedLocation =
      GeoPoint(latitude: 11.567251825418735, longitude: 104.90324335580355);

  TextEditingController addressNote = TextEditingController();
  TextEditingController _receiverPhone = TextEditingController();

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
    controller = MapController.withUserPosition(
        trackUserLocation: UserTrackingOption(
      enableTracking: true,
      unFollowUser: false,
    ));
    _setupLocationChangeListener();
    MapPickerScreenState.dropPhone.text = widget.phone;
  }

  void _setupLocationChangeListener() {
    controller!.listenerMapLongTapping.addListener(() async {
      Position position = await Geolocator.getCurrentPosition(
          locationSettings: LocationSettings(accuracy: LocationAccuracy.high));
      GeoPoint pickedLocation =
          GeoPoint(latitude: position.latitude, longitude: position.longitude);
      // GeoPoint pickedLocation =
      //     await controller!.getCurrentPositionAdvancedPositionPicker();
      setState(() {
        selectedLocation = pickedLocation;
      });
    });
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
    PermissionStatus permission = await Permission.location.request();
    if (permission.isGranted) {
      // _getCurrentLocation();
    } else if (permission.isPermanentlyDenied) {
      // Handle the case where permission is permanently denied
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                "Location permission is permanently denied. Please enable it from settings.")),
      );
    } else {
      // Handle the case where permission is denied temporarily
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text("Location permission is required to use this feature.")),
      );
    }
  }

  Future<void> _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    GeoPoint currentLocation = GeoPoint(
      latitude: position.latitude,
      longitude: position.longitude,
    );

    if (controller != null) {
      setState(() {
        selectedLocation = currentLocation;
        controller!.changeLocation(currentLocation);
        controller!.addMarker(currentLocation);
      });
    }
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
                  "${'address'.tr}",
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
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: _senderPhoneField(context)),
              SizedBox(
                height: 5,
              ),
              Container(
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(flex: 2, child: Center()),
                                      Expanded(
                                          flex: 3,
                                          child: AspectRatio(
                                              aspectRatio: 4 / 4,
                                              child: FittedBox(
                                                  fit: BoxFit.fill,
                                                  child: Icon(
                                                      Icons.location_pin,
                                                      color: Theme.of(context)
                                                          .primaryColor)))),
                                      Expanded(flex: 2, child: Center()),
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
                            OSMFlutter(
                              controller: controller!,
                              onMapMoved: (region) {
                                setState(() {
                                  selectedLocation = region.center;
                                  print(
                                      "Selected Location: ${selectedLocation.toString()}");
                                });
                              },
                              osmOption: OSMOption(
                                // userTrackingOption: UserTrackingOption(enableTracking: true),
                                showDefaultInfoWindow: true,
                                showZoomController: true,
                                zoomOption: ZoomOption(
                                  initZoom: 18,
                                  minZoomLevel: 2,
                                  maxZoomLevel: 18,
                                ),
                                isPicker: true,
                                // markerOption: MarkerOption(
                                //     advancedPickerMarker: MarkerIcon(
                                //   icon: Icon(
                                //     Icons.location_on,
                                //     color: Colors.red,
                                //     size: 100,
                                //   ),
                                // ))
                              ),
                            ),
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
                              bottom: 120,
                              right: 10,
                              child: FloatingActionButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(12),
                                      topRight:
                                          Radius.circular(12)), // Custom radius
                                ),
                                heroTag: "zoomIn",
                                mini: true,
                                backgroundColor: Colors.black.withValues(
                                    red: 0, green: 0, blue: 0, alpha: 0.6),
                                child: Icon(Icons.add),
                                onPressed: () async {
                                  double currentZoom =
                                      await controller!.getZoom();
                                  if (currentZoom < 18)
                                    await controller!
                                        .setZoom(zoomLevel: currentZoom + 1);
                                },
                              ),
                            ),
                            // Zoom Out Button
                            Positioned(
                              bottom: 80,
                              right: 10,
                              child: FloatingActionButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(12),
                                      bottomRight:
                                          Radius.circular(12)), // Custom radius
                                ),
                                heroTag: "zoomOut",
                                mini: true,
                                backgroundColor: Colors.black.withValues(
                                    red: 0, green: 0, blue: 0, alpha: 0.6),
                                child: Icon(Icons.remove),
                                onPressed: () async {
                                  double currentZoom =
                                      await controller!.getZoom();
                                  if (currentZoom > 2)
                                    await controller!
                                        .setZoom(zoomLevel: currentZoom - 1);
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
                                    color: Colors.black.withOpacity(0.6),
                                  ),
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.near_me_rounded,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                    onPressed: () {
                                      controller!.currentLocation();
                                      // _getCurrentLocation();
                                    },
                                  ),
                                )),
                            Positioned(
                                bottom: 20,
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
                          ],
                        ),
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _senderPhoneField(BuildContext context) {
    // final FocusNode inputNode = FocusNode();
    return Form(
        key: _formKey,
        child: Container(
          child: TextFormField(
            focusNode: _focusSenderPhone,
            controller: MapPickerScreenState.dropPhone,
            keyboardType: TextInputType.phone,
            // minLines: 1, //Normal textInputField will be displayed
            maxLines: 1, //
            textAlign: TextAlign.start,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                isDense: false,
                filled: true,
                fillColor: Colors.grey[200],
                alignLabelWithHint: true,
                hintText: "phone".tr),
            validator: (value) {
              if (value!.isEmpty) {
                return "required";
              }
              return null;
            },
          ),
        ));
  }

  // Widget addressDetailField(BuildContext context) {
  //   // final FocusNode inputNode = FocusNode();
  //   return Container(
  //     child: TextField(
  //       focusNode: _focusAddressDetail,
  //       controller: addressNote,
  //       // (widget.addressDertailType == AddressDertailType.sender)
  //       //     ? DeliveryLocalPageState.senderAddress
  //       //     : DeliveryLocalPageState.receiverAddress,
  //       keyboardType: TextInputType.multiline,
  //       // minLines: 1, //Normal textInputField will be displayed
  //       maxLines: 1, //
  //       textAlign: TextAlign.start,
  //       decoration: InputDecoration(
  //           border: OutlineInputBorder(
  //               borderSide: BorderSide.none,
  //               borderRadius: BorderRadius.circular(8.0)),
  //           isDense: true,
  //           filled: true,
  //           fillColor: Colors.grey[200],
  //           alignLabelWithHint: true,
  //           hintText: "addressNote".tr + ", home, floor, room number"),
  //     ),
  //   );
  // }

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
                  if (_formKey.currentState!.validate()) {
                    // GeoPoint pickedLocation = await controller!
                    //     .getCurrentPositionAdvancedPositionPicker();
                    // Position position = await Geolocator.getCurrentPosition(
                    //     desiredAccuracy: LocationAccuracy.high);
                    // GeoPoint pickedLocation = GeoPoint(
                    //     latitude: position.latitude,
                    //     longitude: position.longitude);
                    // setState(() {
                    //   selectedLocation = pickedLocation;
                    // });
                    await _getAddressFromCoordinates(selectedLocation!.latitude,
                        selectedLocation!.longitude);
                    MapPickerScreenState.dropAddress.text = address;
                    MapPickerScreenState.dropLat.text =
                        selectedLocation!.latitude.toString();
                    MapPickerScreenState.dropLong.text =
                        selectedLocation!.longitude.toString();
                    Navigator.of(context).pop();
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

  @override
  void dispose() {
    // addressFormBloc.close();
    _focusAddressDetail.dispose();
    _focusSenderPhone.dispose();
    _focusReceiverPhone.dispose();
    super.dispose();
  }
}
