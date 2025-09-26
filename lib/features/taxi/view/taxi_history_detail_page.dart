import 'package:fardinexpress/features/account/controller/account_controller.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/shared/widget/error_sneakbar.dart';
import 'package:fardinexpress/features/messager/bloc/chat_bloc.dart';
import 'package:fardinexpress/features/messager/bloc/chat_event.dart';
import 'package:fardinexpress/features/messager/bloc/chat_state.dart';
import 'package:fardinexpress/features/messager/model/chat_user_model.dart';
import 'package:fardinexpress/features/messager/screen/messager_page.dart';
import 'package:fardinexpress/features/taxi/model/taxi_history_model.dart';
import 'package:fardinexpress/services/api_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

class TaxiHistoryDetailPage extends StatefulWidget {
  final String status;
  final TaxiHistoryModel taxiHistoryModel;
  const TaxiHistoryDetailPage(
      {Key? key, required this.taxiHistoryModel, required this.status})
      : super(key: key);

  @override
  State<TaxiHistoryDetailPage> createState() => _TaxiHistoryDetailPageState();
}

class _TaxiHistoryDetailPageState extends State<TaxiHistoryDetailPage> {
  String address = "No address selected";
  ApiProvider apiProvider = ApiProvider();

  late ChatBloc _chatBloc;

  List listOfPoints = [];
  List<LatLng> points = [];

  double picLat = 11.56739982648142;
  double picLong = 104.90293622016907;

  double droLat = 11.568105809591117;
  double droLong = 104.91083979606628;

  // Method to consume the OpenRouteService API
  getCoordinates() async {
    // Requesting for openrouteservice api
    var response = await apiProvider.fetchRoute(
        start: GeoPoint(
            latitude: double.parse(widget.taxiHistoryModel.pickupLat),
            longitude: double.parse(widget.taxiHistoryModel.pickupLong)),
        end: GeoPoint(
            latitude: double.parse(widget.taxiHistoryModel.receiveLat),
            longitude: double.parse(widget.taxiHistoryModel.receiveLong)));
    //  var response = await apiProvider.fetchRoute(
    //     start: GeoPoint(
    //         latitude: picLat,
    //         longitude: picLong),
    //     end: GeoPoint(
    //         latitude: droLat,
    //         longitude: droLong));

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
    // TODO: implement initState
    super.initState();
    getCoordinates();
    _chatBloc = ChatBloc();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "bookingDetail".tr,
            style: TextStyle(color: Colors.white),
          ),
          iconTheme: IconThemeData(color: Colors.white),
          centerTitle: true,
          backgroundColor: Colors.green,
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
                                name: widget.taxiHistoryModel.driverName,
                                image: widget.taxiHistoryModel.deliveryImage,
                                channelId: null,
                                lastMessage: "",
                                time: '',
                                fromId: "0",
                                messageId: "0",
                                phone: widget.taxiHistoryModel.driverPhone,
                                email: widget.taxiHistoryModel.driverPhone,
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
              EasyLoading.dismiss(); // close dialog
              errorSnackBar(text: state.error, context: context);
            }
          },
          child: Container(
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
                          // "http://159.65.140.187:8089/styles/basic-preview/512/{z}/{x}/{y}.png",
                          userAgentPackageName:
                              'dev.fleaflet.flutter_map.example',
                        ),
                        // Layer that adds points the map
                        MarkerLayer(
                          markers: [
                            // First Marker
                            Marker(
                                point: LatLng(picLat, picLong),
                                width: 80,
                                height: 80,
                                child: IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.location_on),
                                  color: Colors.green,
                                  iconSize: 45,
                                )),
                            // Second Marker
                            widget.taxiHistoryModel.receiveLat == 0 ||
                                    widget.taxiHistoryModel.receiveLong == 0
                                ? Marker(
                                    point: LatLng(0, 0),
                                    child: Container(),
                                  )
                                : Marker(
                                    point: LatLng(droLat, droLong),
                                    width: 80,
                                    height: 80,
                                    child: IconButton(
                                      onPressed: () {},
                                      icon: const Icon(Icons.location_on),
                                      color: Colors.red,
                                      iconSize: 45,
                                    )),
                          ],
                        ),

                        // Polylines layer
                        widget.taxiHistoryModel.receiveLat == 0 ||
                                widget.taxiHistoryModel.receiveLong == 0 ||
                                points.isEmpty
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
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              'No.${widget.taxiHistoryModel.id}',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.end,
                            ),
                            Text(
                              '${widget.taxiHistoryModel.date}',
                              style: TextStyle(
                                // fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[600],
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
                                    '${widget.taxiHistoryModel.senderAddress}',
                                time: '23:03 PM',
                                icon: Icon(
                                  Icons.person_pin,
                                ),
                                iconColor: Colors.blue),
                            // SizedBox(height: 10.0),
                            Container(
                              margin: EdgeInsets.only(left: 16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                            widget.taxiHistoryModel.receiveLat == 0 ||
                                    widget.taxiHistoryModel.receiveLong == 0
                                ? SizedBox.shrink()
                                : _buildLocationCard(
                                    title: 'Drop Location',
                                    location:
                                        '${widget.taxiHistoryModel.receiverAddress.toString() == "null" ? '' : widget.taxiHistoryModel.receiverAddress}',
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
                widget.taxiHistoryModel.driverName.toString() == "none" ||
                        widget.taxiHistoryModel.driverName.toString() == "" ||
                        widget.taxiHistoryModel.driverPhone.toString() ==
                            "none" ||
                        widget.taxiHistoryModel.driverPhone.toString() == ""
                    ? Container()
                    : Positioned(
                        bottom: 0,
                        child: GestureDetector(
                          onTap: () => _travelingDetails(
                              context: context,
                              status: widget.status,
                              driverId: widget.taxiHistoryModel.driverId,
                              driverName: widget.taxiHistoryModel.driverName,
                              driverPhone: widget.taxiHistoryModel.driverPhone,
                              date: widget.taxiHistoryModel.date!,
                              grandTotal: widget.taxiHistoryModel.grandTotal,
                              currency: widget.taxiHistoryModel.currencySymbol,
                              duration: widget.taxiHistoryModel.duration,
                              distance: widget.taxiHistoryModel.distance,
                              transportType:
                                  widget.taxiHistoryModel.transportType),
                          child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.8),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(16.0),
                                  topRight: Radius.circular(16.0),
                                ),
                              ),
                              width: MediaQuery.of(context).size.width,
                              height: 50,
                              padding: EdgeInsets.symmetric(horizontal: 20.0),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("showDetail".tr,
                                        style: TextStyle(
                                            color: Colors.blue,
                                            fontWeight: FontWeight.bold)),
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
                        )
                // Positioned(
                //     bottom: 0,
                //     child: tranvelDetails(
                //       status: widget.status,
                //       driverId: widget.taxiHistoryModel.driverId,
                //       driverName: widget.taxiHistoryModel.driverName,
                //       driverPhone: widget.taxiHistoryModel.driverPhone,
                //     ))
                // Positioned(
                //     bottom: 50,
                //     // left: 1,
                //     child: GestureDetector(
                //       onTap: () {
                //         // _showConfirmDialog();
                //       },
                //       child: Container(
                //         padding: EdgeInsets.symmetric(
                //             horizontal: 20.0, vertical: 10.0),
                //         decoration: BoxDecoration(
                //             color: Colors.green[900],
                //             borderRadius: BorderRadius.circular(8.0)),
                //         child: Center(
                //           child: Text(
                //             'កំពុងធ្វើដំណើរ'.toUpperCase(),
                //             textScaleFactor: 1.4,
                //             textAlign: TextAlign.center,
                //             style: TextStyle(color: Colors.white),
                //           ),
                //         ),
                //       ),
                //     )
                //     ),
              ],
            ),
          ),
        )

        // Column(
        //   children: [
        //     Expanded(
        //       child: Container(
        //         padding: EdgeInsets.symmetric(horizontal: 20),
        //         child: ListView(
        //           children: [
        //             SizedBox(
        //               height: 25,
        //             ),
        //             _referenceNo(widget.taxiHistoryModel.id.toString(), context),
        //             SizedBox(height: 5),
        //             _date(widget.taxiHistoryModel.date, context),
        //             SizedBox(height: 15),
        //             _customerName(context),
        //             SizedBox(height: 8),
        //             _phone(widget.taxiHistoryModel.receiverPhone, context),
        //             SizedBox(height: 8),
        //             _address(widget.taxiHistoryModel.receiverAddress, context),
        //             SizedBox(height: 8),
        //             _paymentNote(widget.taxiHistoryModel.paymentNote, context),
        //             Divider(
        //               thickness: 1.2,
        //             ),
        //             _deliveryStatus(widget.taxiHistoryModel.status, context),
        //             SizedBox(height: 8),
        //             _note(widget.taxiHistoryModel.note, context),
        //             SizedBox(height: 8),
        //             _packagePrice(
        //                 double.parse(widget.taxiHistoryModel.packagePrice), context),
        //             SizedBox(height: 8),
        //             _deliveryFee(0, context),
        //             SizedBox(height: 8),
        //             _paidAmount(double.parse(widget.taxiHistoryModel.total!), context),
        //             SizedBox(height: 8),
        //             Divider(
        //               thickness: 1.2,
        //             ),
        //             SizedBox(height: 15),
        //             Hero(
        //               tag: widget.taxiHistoryModel.deliveryImage,
        //               child: Image(
        //                 // loadingBuilder:
        //                 //     (context, error, stackTrace) =>
        //                 //         CircularProgressIndicator(),
        //                 errorBuilder: (context, error, stackTrace) =>
        //                     Container(),
        //                 image: NetworkImage(widget.taxiHistoryModel.deliveryImage),
        //               ),
        //             ),
        //           ],
        //         ),
        //       ),
        //     ),
        //   ],
        // )
        );
  }

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
        color: Colors.transparent,
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
      required String grandTotal,
      required String currency,
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
                  SizedBox(height: 4.0),
                  Divider(thickness: 0.7, color: Colors.grey.shade300),
                  SizedBox(height: 4.0),
                  status == "completed"
                      ? Container(
                          padding: EdgeInsets.symmetric(vertical: 10.0),
                          decoration: BoxDecoration(
                              // color: Colors.grey.shade300,
                              // borderRadius: BorderRadius.circular(8),
                              ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _infoTile("duration".tr, "${duration}"),
                              _infoTile("distance".tr, "${distance}"),
                            ],
                          ),
                        )
                      : SizedBox.shrink(),
                  Container(
                    margin: EdgeInsets.only(bottom: 4.0),
                    child: Divider(thickness: 0.7, color: Colors.grey.shade300),
                  ),
                  status == "completed"
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "date".tr + ":",
                              style: TextStyle(
                                  fontSize: 16,
                                  // fontWeight: FontWeight.bold,
                                  color: Colors.grey[800]),
                            ),
                            Text(
                              "${date}",
                              style: TextStyle(
                                fontSize: 16,
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
                              "total".tr + ":",
                              style: TextStyle(
                                  fontSize: 16, color: Colors.grey[800]),
                            ),
                            Text(
                              "${grandTotal} ${currency}",
                              style: TextStyle(
                                  fontSize: 16,
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

  @override
  void dispose() {
    // TODO: implement dispose
    _chatBloc.close();
    super.dispose();
  }
}
