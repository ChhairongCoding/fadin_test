import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:fardinexpress/features/address/controller/address_controller.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/utils/constants/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class AddAddressForm extends StatefulWidget {
  AddAddressForm({Key? key}) : super(key: key);

  @override
  State<AddAddressForm> createState() => AddAddressFormState();
}

class AddAddressFormState extends State<AddAddressForm> {
  final AddressController _controller = Get.put(AddressController());
  MapController? controller;
  GeoPoint? selectedLocation =
      GeoPoint(latitude: 11.567251825418735, longitude: 104.90324335580355);

  // static TextEditingController descriptionCtr = TextEditingController();
  // static TextEditingController lat = TextEditingController();
  // static TextEditingController long = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameCtr = TextEditingController();
  String address = "No address selected";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _requestLocationPermission();
    // controller = MapController.withPosition(initPosition: selectedLocation!);
    controller = MapController.withUserPosition(
        trackUserLocation: UserTrackingOption(
      enableTracking: false,
      unFollowUser: false,
    ));
    _setupLocationChangeListener();
  }

  void _setupLocationChangeListener() {
    controller!.listenerMapLongTapping.addListener(() async {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
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
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        setState(() {
          // Constructing a readable address
          address = "${place.street}, ${place.locality}, ${place.country}";
        });
      }
    } catch (e) {
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
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
          leading: IconButton(
            color: Colors.black,
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_outlined),
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                SizedBox(height: 20),
                Text(
                  "Add Address",
                  // AppLocalizations.of(context)!.translate("changePassword")!,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                  textScaleFactor: 2,
                ),
                SizedBox(height: 20),
                Form(
                    key: _formKey,
                    child: Column(children: <Widget>[
                      TextFormField(
                        controller: _nameCtr,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(labelText: "Name"),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "required";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      // TextFormField(
                      //   controller: descriptionCtr,
                      //   maxLines: 2,
                      //   keyboardType: TextInputType.text,
                      //   decoration: InputDecoration(labelText: "Address name"),
                      //   validator: (value) {
                      //     if (value!.isEmpty) {
                      //       return "required";
                      //     }
                      //     return null;
                      //   },
                      // ),
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
                                //     size: Platform.isIOS ? 40 : 100,
                                //   ),
                                // ))
                              ),
                              // onMapIsReady: (isReady) {
                              //   if (isReady) {
                              //     // Additional actions when the map is ready
                              //   }
                              // },

                              // onGeoPointClicked: (geoPoint) async {
                              //   setState(() {
                              //     selectedLocation = geoPoint;
                              //   });
                              //   controller!.addMarker(geoPoint);
                              // },
                              // onLocationChanged: (geoPoint) {
                              //   setState(() {
                              //     selectedLocation = geoPoint;
                              //   });
                              //   controller!.changeLocation(geoPoint);
                              // },
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
                              bottom: 110,
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
                              bottom: 70,
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
                                      // _getCurrentLocation();
                                      controller!.currentLocation();
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
                      SizedBox(height: 20),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              backgroundColor: Theme.of(context).primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(standardBorderRadius),
                              ),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                // Position position =
                                //     await Geolocator.getCurrentPosition(
                                //         desiredAccuracy: LocationAccuracy.high);
                                // GeoPoint pickedLocation = GeoPoint(
                                //     latitude: position.latitude,
                                //     longitude: position.longitude);
                                ///old code
                                // GeoPoint pickedLocation = await controller!
                                //     .getCurrentPositionAdvancedPositionPicker();
                                // setState(() {
                                //   selectedLocation = pickedLocation;
                                // });
                                await _getAddressFromCoordinates(
                                    selectedLocation!.latitude,
                                    selectedLocation!.longitude);
                                print(
                                    "Selected Location: ${selectedLocation!.latitude}, ${selectedLocation!.longitude}, ${address}");
                                _controller.toAddLocation(
                                    name: _nameCtr.text,
                                    lat: selectedLocation!.latitude.toString(),
                                    long:
                                        selectedLocation!.longitude.toString(),
                                    description: address);
                              }
                            },
                            // _controller.toAddLocation(
                            //     name: _nameCtr.text,
                            //     lat: lat.text,
                            //     long: long.text,
                            //     description: descriptionCtr.text),
                            child: Text(
                              "Create".toUpperCase(),
                              textScaleFactor: 1.2,
                              style: TextStyle(color: Colors.white),
                            )),
                      ),
                    ])),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller!.dispose();
    // descriptionCtr.clear();
    // lat.clear();
    // long.clear();
    super.dispose();
  }
}
