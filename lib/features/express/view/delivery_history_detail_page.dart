import 'package:fardinexpress/features/express/model/delivery_history_model.dart';
import 'package:fardinexpress/features/express/view/widget/delivery_tracking_step.dart';
import 'package:fardinexpress/services/api_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:qr_flutter/qr_flutter.dart';

class DeliveryHistoryDetailPage extends StatefulWidget {
  final DeliveryHistoryModel deliveryHistoryModel;
  final String deliveryType;
  const DeliveryHistoryDetailPage(
      {Key? key,
      required this.deliveryHistoryModel,
      required this.deliveryType})
      : super(key: key);

  @override
  State<DeliveryHistoryDetailPage> createState() =>
      _DeliveryHistoryDetailPageState();
}

class _DeliveryHistoryDetailPageState extends State<DeliveryHistoryDetailPage> {
  ApiProvider apiProvider = ApiProvider();
  // MapController? controller;
  // GeoPoint? selectedLocation =
  //     GeoPoint(latitude: 11.567251825418735, longitude: 104.90324335580355);
  // Raw coordinates got from  OpenRouteService
  List listOfPoints = [];

  // Conversion of listOfPoints into LatLng(Latitude, Longitude) list of points
  List<LatLng> points = [];

  // Method to consume the OpenRouteService API
  getCoordinates() async {
    // Requesting for openrouteservice api
    var response = await apiProvider.fetchRoute(
        start: GeoPoint(
            latitude: widget.deliveryHistoryModel.pickupLat,
            longitude: widget.deliveryHistoryModel.pickupLong),
        end: GeoPoint(
            latitude: widget.deliveryHistoryModel.receiverLat,
            longitude: widget.deliveryHistoryModel.receiverLong));

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
    getCoordinates();
    print("check lat long : " +
        widget.deliveryHistoryModel.pickupLat.toString() +
        " , " +
        widget.deliveryHistoryModel.receiverLat.toString());
    // getCoordinates();
    // _requestLocationPermission();
    // controller = MapController.withPosition(initPosition: selectedLocation!);
    // _drawRoute();
    // _setupLocationChangeListener();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("bookingDetail".tr),
          centerTitle: true,
          actions: [
            // IconButton(
            //   onPressed: () async {
            //     // latitude: 11.567492951212355, longitude: 104.90509762971581
            //     // destinationLocation = GeoPoint(
            //     //   latitude: 11.567492951212355,
            //     //   longitude: 104.90509762971581,
            //     // );
            //     // await _drawRoute();
            //     // await getCoordinates();
            //   },
            //   icon: Icon(Icons.map_outlined),
            // )
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: ListView(
                  children: [
                    SizedBox(
                      height: 25,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _referenceNo(
                            widget.deliveryHistoryModel.id.toString(), context),
                        _qrcode(
                            widget.deliveryHistoryModel.id.toString(), context)
                      ],
                    ),
                    SizedBox(height: 5),
                    _date(widget.deliveryHistoryModel.date, context),
                    SizedBox(height: 15),
                    _senderName(
                        context,
                        widget.deliveryHistoryModel.senderPhone,
                        widget.deliveryHistoryModel.senderAddress),
                    SizedBox(height: 10),
                    _receiverName(
                        context,
                        widget.deliveryHistoryModel.receiverPhone,
                        widget.deliveryHistoryModel.receiverAddress),
                    // SizedBox(height: 8),
                    Divider(
                      thickness: 0.5,
                    ),
                    // _phone(deliveryHistoryModel.receiverPhone, context),
                    // SizedBox(height: 8),
                    // _address(deliveryHistoryModel.receiverAddress, context),
                    // SizedBox(height: 8),
                    _deliveryType(
                        widget.deliveryHistoryModel.deliveryType, context),
                    SizedBox(height: 5),
                    _deliveryStatus(
                        widget.deliveryHistoryModel.status, context),
                    SizedBox(height: 5),
                    _paymentNote(
                        widget.deliveryHistoryModel.paymentNote, context),
                    SizedBox(height: 5),
                    _note(widget.deliveryHistoryModel.note, context),
                    SizedBox(height: 5),
                    _packagePrice(
                        double.parse(widget.deliveryHistoryModel.total!),
                        widget.deliveryHistoryModel.currency,
                        context),
                    SizedBox(height: 5),
                    _deliveryFee(
                        widget.deliveryHistoryModel.deliveryFee, context),
                    _otherFee(widget.deliveryHistoryModel.otherFee, context),
                    SizedBox(height: 5),
                    SizedBox(height: 5),
                    _paidAmount(
                        double.parse(widget.deliveryHistoryModel.grandTotal),
                        widget.deliveryHistoryModel.currency,
                        context),
                    SizedBox(height: 5),
                    Divider(
                      thickness: 0.5,
                    ),
                    SizedBox(height: 15),
                    widget.deliveryHistoryModel.deliveryType == "delivery" ||
                            widget.deliveryHistoryModel.deliveryType ==
                                "province"
                        ? DeliveryTrackingStep(
                            history: widget.deliveryHistoryModel.operations)
                        : AspectRatio(
                            aspectRatio: 22 / 20,
                            child: Stack(
                              children: [
                                FlutterMap(
                                  options: MapOptions(
                                    initialZoom: 14,
                                    initialCenter: LatLng(
                                        widget.deliveryHistoryModel.pickupLat,
                                        widget.deliveryHistoryModel.pickupLong),
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
                                            point: LatLng(
                                                widget.deliveryHistoryModel
                                                    .pickupLat,
                                                widget.deliveryHistoryModel
                                                    .pickupLong),
                                            width: 80,
                                            height: 80,
                                            child: IconButton(
                                              onPressed: () {},
                                              icon:
                                                  const Icon(Icons.location_on),
                                              color: Colors.green,
                                              iconSize: 45,
                                            )),
                                        // Second Marker
                                        Marker(
                                            point: LatLng(
                                                widget.deliveryHistoryModel
                                                    .receiverLat,
                                                widget.deliveryHistoryModel
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
                                    points.isNotEmpty
                                        ? PolylineLayer(
                                            // polylineCulling: false,
                                            polylines: [
                                              Polyline(
                                                  points: points,
                                                  color: Colors.blue,
                                                  strokeWidth: 3),
                                            ],
                                          )
                                        : Container()
                                  ],
                                ),
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
                          ),
                    SizedBox(height: 15),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  _referenceNo(String ref, BuildContext _) {
    return Row(
      children: [
        Text(
          "#${ref}",
          style: Theme.of(_)
              .textTheme
              .headlineSmall!
              .copyWith(fontWeight: FontWeight.bold, color: Colors.blue),
        ),
        SizedBox(width: 10),
        IconButton(
          onPressed: (() {
            Clipboard.setData(ClipboardData(text: ref));
            ScaffoldMessenger.of(_).showSnackBar(
              SnackBar(content: Text("Copied to clipboard")),
            );
          }),
          icon: Icon(Icons.content_copy_outlined, color: Colors.grey[600]),
        )
      ],
    );
  }

  _qrcode(String ref, BuildContext _) {
    return Container(
      padding: EdgeInsets.all(0.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey[800]!, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        // decoration: BoxDecoration(
        //   color: Colors.white,
        //   borderRadius: BorderRadius.circular(10),
        // ),
        child: QrImageView(
          // dataModuleStyle: QrDataModuleStyle(
          //   color: Colors.grey[800],
          //   dataModuleShape: QrDataModuleShape.square,
          // ),
          // eyeStyle: QrEyeStyle(color: Colors.blue),
          data: "${ref}",
          version: QrVersions.auto,
          size: 100.0,
          gapless: false,
        ),
      ),
    );
  }

  _date(String? date, BuildContext _) {
    return Text(
      ("$date"),
      style:
          Theme.of(_).textTheme.titleSmall!.copyWith(color: Colors.grey[600]),
    );
  }

  _senderName(BuildContext _, String phone, String address) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          child: Text(
            "sender".tr,
            style: Theme.of(_).textTheme.bodyLarge,
            overflow: TextOverflow
                .clip, // This will add '...' if the text is too long
          ),
        ),
        Flexible(
          child: Text(
            "$phone, $address",
            style: Theme.of(_).textTheme.bodyLarge,
            overflow: TextOverflow
                .clip, // This will add '...' if the text is too long
          ),
        ),
      ],
    );
  }

  _receiverName(BuildContext _, String phone, String address) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          child: Text(
            ("receiver".tr),
            style: Theme.of(_).textTheme.bodyLarge,
            overflow: TextOverflow.clip,
          ),
        ),
        Flexible(
          child: Text(
            ("${phone}, ${address} ${phone}"),
            style: Theme.of(_).textTheme.bodyLarge,
            overflow: TextOverflow.clip,
          ),
        ),
      ],
    );
  }

  _phone(String? phone, BuildContext _) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          ("Phone: "),
          style: Theme.of(_).textTheme.bodyLarge,
        ),
        Text(
          phone!.toString() == "null" ? "N/A" : phone,
          style: Theme.of(_).textTheme.bodyLarge,
        ),
      ],
    );
  }

  _address(String? address, BuildContext _) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          ("Address: "),
          style: Theme.of(_).textTheme.bodyLarge,
        ),
        Flexible(
          child: Text(
            address!.toString() == "null" ? "N/A" : address,
            style: Theme.of(_).textTheme.bodyLarge,
            maxLines: 2,
            overflow: TextOverflow.clip,
          ),
        ),
      ],
    );
  }

  _note(String note, BuildContext _) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          ("Note: "),
          style: Theme.of(_).textTheme.bodyLarge,
        ),
        Flexible(
          child: Text(
            note.toString() == "null" ? "" : note,
            style: Theme.of(_).textTheme.bodyLarge,
            overflow: TextOverflow.clip,
          ),
        ),
      ],
    );
  }

  _packagePrice(double packagePrice, String currency, BuildContext _) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Package Price: ",
          style: Theme.of(_).textTheme.bodyLarge,
        ),
        Text(
          "${currency} " + (packagePrice).toStringAsFixed(2),
          style: Theme.of(_).textTheme.bodyLarge,
        ),
      ],
    );
  }

  _paidAmount(double grandTotal, String currencySymbol, BuildContext _) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          ("Paid Amount: "),
          style: Theme.of(_)
              .textTheme
              .bodyLarge!
              .copyWith(color: Colors.orange[700], fontWeight: FontWeight.bold),
        ),
        Text(
          "\$ " + grandTotal.toStringAsFixed(2),
          style: Theme.of(_)
              .textTheme
              .bodyLarge!
              .copyWith(color: Colors.orange[700], fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  _deliveryStatus(String? status, BuildContext _) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          ("Delivery Status: "),
          style: Theme.of(_).textTheme.bodyLarge,
        ),
        Text(
          ("$status"),
          style: Theme.of(_).textTheme.bodyLarge,
        ),
      ],
    );
  }

  _deliveryType(String? deliveryType, BuildContext _) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          ("Delivery Type: "),
          style: Theme.of(_).textTheme.bodyLarge,
        ),
        Text(
          "${deliveryType == 'express' ? 'fastExpress' : deliveryType == 'delivery' ? 'normalExpress' : deliveryType == 'province' ? 'provinceExpress' : 'cargoExpress'}"
              .tr
              .toUpperCase(),
          style: Theme.of(_)
              .textTheme
              .bodyLarge!
              .copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  _paymentNote(String? paymentNote, BuildContext _) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          ("Payment Note: "),
          style: Theme.of(_).textTheme.bodyLarge,
        ),
        Text(
          paymentNote!.toString() == "yes" ? "COD" : "Bank",
          style: Theme.of(_).textTheme.bodyLarge,
        ),
      ],
    );
  }

  _deliveryFee(String deliveryFee, BuildContext _) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            ("Delivery Fee: "),
            style: Theme.of(_).textTheme.bodyLarge,
          ),
          Text(
            "\$ " +
                (deliveryFee == "null" || deliveryFee == ""
                    ? "0.00"
                    : deliveryFee),
            style: Theme.of(_).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }

  _otherFee(String otherFee, BuildContext _) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            ("Other Fee: "),
            style: Theme.of(_).textTheme.bodyLarge,
          ),
          Text(
            "\$ " + (otherFee == "null" || otherFee == "" ? "0.00" : otherFee),
            style: Theme.of(_).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}
