// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:get/get.dart';
// import 'package:latlong2/latlong.dart';
// import 'package:location/location.dart';
// import 'package:toggle_switch/toggle_switch.dart';

// class GetLocationPage extends StatefulWidget {
//   // final bool? interactive;
//   // final bool? isAppBar;
//   // final double? lat;
//   // final double? log;
//   GetLocationPage({
//     Key? key,
//     // this.interactive = false,
//     // this.isAppBar = false,
//     // this.lat,
//     // this.log
//   }) : super(key: key);

//   @override
//   _GetLocationPageState createState() {
//     return _GetLocationPageState();
//   }
// }

// class _GetLocationPageState extends State<GetLocationPage> {
//   // final controller = Get.put(LocationController());

//   Future? getLocation;
//   double localLat = 11.567251825418735;
//   double localLog = 104.90324335580355;

//   var location = new Location();
//   late LocationAxis userLocation;
//   bool isLocated = false;
//   double zoom = 16;
//   String mapUrl = "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png";
//   @override
//   void initState() {
//     userLocation = LocationAxis(11.567251825418735, 104.90324335580355);
//     getLocation = _getLocation();

//     ///note here
//     // if (widget.lat != null && widget.log != null) {
//     // localLat = widget.lat;
//     // localLog = widget.log;
//     // userLocation.latitude = localLat;
//     // userLocation.longitude = localLog;
//     // }
//     super.initState();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       future: getLocation,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.done) {
//           // singleton.isLocated = true;
//           isLocated = true;
//           return Stack(
//             children: <Widget>[
//               FlutterMap(
//                 options: MapOptions(
//                     interactionOptions:
//                         InteractionOptions(flags: InteractiveFlag.all),
//                     initialCenter:
//                         LatLng(11.567251825418735, 104.90324335580355),
//                     initialZoom: zoom,
//                     onTap: (tap, LatLng) {
//                       // print('tapped $localLat');
//                       // singleton.isChangeLocation = true;
//                       localLat = LatLng.latitude;
//                       localLog = LatLng.longitude;
//                       setState(() {
//                         // localLat = LatLng.latitude;
//                         // localLog = LatLng.longitude;
//                       });
//                     }),
//                 children: [
//                   TileLayer(
//                     urlTemplate:
//                         "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}",
//                     subdomains: [],
//                     // additionalOptions: {
//                     //   'accessToken':
//                     //       'pk.eyJ1IjoiYmNpbm5vdmF0aW9udGVhbSIsImEiOiJjazVveXBwdzUxZXp0M29wY3djN2xjMmNhIn0.KSQ7lGfLfQW3G91MZoZX0A',
//                     //   'id': 'mapbox.streets',
//                     // },
//                   ),
//                   MarkerLayer(
//                     markers: [
//                       Marker(
//                         width: 200,
//                         height: 200,
//                         point: LatLng(11.567251825418735, 104.90324335580355),
//                         child: Image.asset(
//                           "assets/img/location/marker.png",
//                           scale: 15,
//                         ),
//                       )
//                     ],
//                   ),
//                 ],
//               ),
//               SafeArea(
//                 child: Padding(
//                   padding: EdgeInsets.all(20),
//                   child: Align(
//                       alignment: Alignment.bottomRight,
//                       child: FloatingActionButton(
//                         onPressed: () {
//                           getLocation = _getLocation();
//                           isLocated = false;

//                           setState(() {});
//                           // singleton.isLocated = false;
//                           // singleton.isChangeLocation = false;
//                         },
//                         backgroundColor: Colors.white,
//                         child: Icon(
//                           Icons.my_location,
//                           color: Colors.blue,
//                         ),
//                       )),
//                 ),
//               ),
//             ],
//           );
//         }
//         return Center(
//           child: CircularProgressIndicator(),
//         );
//       },
//     );
//   }

//   /// get current user location
//   Future<bool> _getLocation() async {
//     // Check if location service is enabled
//     bool _serviceEnabled = await location.serviceEnabled();
//     if (!_serviceEnabled) {
//       _serviceEnabled = await location.requestService();
//       if (!_serviceEnabled) {
//         return false; // Service is not enabled
//       }
//     }

//     // Check if location permission is granted
//     PermissionStatus _permissionGranted = await location.hasPermission();
//     if (_permissionGranted == PermissionStatus.denied) {
//       _permissionGranted = await location.requestPermission();
//       if (_permissionGranted != PermissionStatus.granted) {
//         return false; // Permission not granted
//       }
//     }

//     // Get the user location if latitude is null
//     if (userLocation.latitude == null) {
//       try {
//         final locationData = await location.getLocation();
//         userLocation.latitude = locationData.latitude;
//         userLocation.longitude = locationData.longitude;
//       } catch (e) {
//         return false; // Error while getting location
//       }
//     }

//     return true; // Location retrieved successfully
//   }
// }

// class LocationAxis {
//   double? latitude = 0.0;
//   double? longitude = 0.0;
//   LocationAxis(this.latitude, this.longitude);
//   String get latLngString {
//     return latitude.toString() + "," + longitude.toString();
//   }
// }
