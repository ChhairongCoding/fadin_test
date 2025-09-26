import 'package:extended_image/extended_image.dart';
import 'package:fardinexpress/features/account/controller/account_controller.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/feature/transport/controller/transport_controller.dart';
import 'package:fardinexpress/features/express/controller/express_controller.dart';
import 'package:fardinexpress/utils/bloc/indexing/indexing_bloc.dart';
import 'package:fardinexpress/utils/bloc/indexing/indexing_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
// import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';

class TaxiBookingPage extends StatelessWidget {
  TaxiBookingPage({Key? key}) : super(key: key);

  final TransportController _transportController =
      Get.put(TransportController("vehicle".toLowerCase()), tag: "taxi");
  final ExpressController _expressController =
      Get.put(ExpressController(), tag: "taxi");
  final AccountController _controller = Get.find<AccountController>();
  String tranType = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   title: Text("Taxi Booking"),
        //   centerTitle: true,
        //   backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        //   elevation: 0,
        // ),
        body: Container(
            height: MediaQuery.of(context).size.height,
            // width: MediaQuery.of(context).size.width,
            child: Obx(() {
              if (_controller.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              } else {
                return Container();
                // return PlacePicker(
                //     region: "KH",
                //     selectInitialPosition: true,
                //     enableMyLocationButton: true,
                //     useCurrentLocation: true,
                //     apiKey: "${dotenv.env['mapApiKey']}",
                //     initialPosition: LatLng(11.564021, 104.913244),
                //     selectedPlaceWidgetBuilder:
                //         (contex, result, searchState, a) {
                //       return Column(
                //         // mainAxisSize: MainAxisSize.min,
                //         // crossAxisAlignment: CrossAxisAlignment.start,
                //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //         children: [
                //           Container(
                //               padding: EdgeInsets.all(15.0),
                //               // color: Colors.blue,
                //               child: transportType(context)),
                //           Column(
                //             mainAxisAlignment: MainAxisAlignment.end,
                //             children: [
                //               Container(
                //                 decoration: BoxDecoration(
                //                     color: Colors.white,
                //                     borderRadius:
                //                         BorderRadius.all(Radius.circular(18))),
                //                 width: double.infinity,
                //                 margin: EdgeInsets.symmetric(
                //                     horizontal: 15, vertical: 10),
                //                 padding: EdgeInsets.all(20),
                //                 child: (searchState == SearchingState.Searching)
                //                     ? Center(child: CircularProgressIndicator())
                //                     : Text(result!.formattedAddress!),
                //               ),
                //               Padding(
                //                 padding: const EdgeInsets.only(
                //                     left: 15, right: 15, bottom: 20),
                //                 child: AspectRatio(
                //                   aspectRatio: 10 / 1.3,
                //                   child: Container(
                //                       width: double.infinity,
                //                       margin: EdgeInsets.symmetric(
                //                           horizontal: 10.0),
                //                       padding: EdgeInsets.only(
                //                           left: 10.0, right: 10.0),
                //                       decoration: BoxDecoration(
                //                           borderRadius:
                //                               BorderRadius.circular(8.0),
                //                           color:
                //                               Theme.of(context).primaryColor),
                //                       child: ElevatedButton(
                //                           onPressed: () {
                //                             _expressController.toRequestPickup(
                //                                 deliveryType: "taxi",
                //                                 senderPhone: _controller
                //                                     .accountInfo.phone,
                //                                 senderAddress: result!
                //                                     .formattedAddress
                //                                     .toString(),
                //                                 senderLat: result
                //                                     .geometry!.location.lat
                //                                     .toString(),
                //                                 senderLong: result
                //                                     .geometry!.location.lng
                //                                     .toString(),
                //                                 receiverLat: "",
                //                                 receiverLong: "",
                //                                 receiverPhone: "",
                //                                 receiverAddress: "",
                //                                 note: "",
                //                                 paymentNote: "yes",
                //                                 total: "0",
                //                                 transportId: tranType,
                //                                 showTransportType: "human");
                //                           },
                //                           style: ElevatedButton.styleFrom(
                //                               backgroundColor:
                //                                   Colors.transparent,
                //                               elevation: 0),
                //                           child: Text(
                //                             "bookNow".tr,
                //                             // AppLocalizations.of(context)!.translate("bookNow")!,
                //                             // AppLocalizations.of(context)!.translate("submission")!,
                //                             // AppLocalizations.of(context)!.translate("deposite")!,
                //                             textScaleFactor: 1.2,
                //                           ))),
                //                 ),
                //               ),
                //             ],
                //           ),
                //         ],
                //       );
                //     });
              }
            })));
  }

  Widget transportType(BuildContext _) {
    return BlocBuilder(
        bloc: selectingBloc,
        builder: (BuildContext context, dynamic state) {
          return Obx(() {
            if (_transportController.isLoading.value) {
              return Center(child: CircularProgressIndicator());
            } else {
              tranType = _transportController.transports[0].id.toString();
              return GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 4 / 4,
                      crossAxisCount: 3,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 5),
                  itemCount: _transportController.transports.length,
                  itemBuilder: (context, index) => GestureDetector(
                        onTap: () {
                          selectingBloc.add(Taped(index: index));
                          tranType = _transportController.transports[index].id
                              .toString();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            // boxShadow: [
                            //   BoxShadow(
                            //       color: Colors.grey[300]!,
                            //       offset: Offset(0.0, 0.5), //(x,y)
                            //       blurRadius: 3.0,
                            //       spreadRadius: 0.0),
                            // ],
                            color: index == state ? Colors.amber : Colors.white,
                            // borderRadius: BorderRadius.circular(8.0)
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 7,
                                child: Container(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Center(),
                                      ),
                                      Expanded(
                                        flex: 8,
                                        child: AspectRatio(
                                          aspectRatio: 1,
                                          child: Container(
                                            padding: EdgeInsets.all(6.0),
                                            // decoration: BoxDecoration(
                                            //     // shape: BoxShape.circle,
                                            //     borderRadius: BorderRadius.circular(8.0),
                                            //     boxShadow: [
                                            //       BoxShadow(
                                            //           color: Colors.grey[300]!,
                                            //           offset: Offset(0.0, 0.5), //(x,y)
                                            //           blurRadius: 3.0,
                                            //           spreadRadius: 0.0),
                                            //     ],
                                            //     color: Colors.white),
                                            child: ExtendedImage.network(
                                              _transportController
                                                  .transports[index].image,
                                              // errorWidget: Image.asset(
                                              //     "assets/img/scooter.png"),
                                              cacheWidth: 50,
                                              cacheHeight: 50,
                                              // enableMemoryCache: true,
                                              clearMemoryCacheWhenDispose: true,
                                              clearMemoryCacheIfFailed: false,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Center(),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Expanded(
                                flex: 3,
                                child: Text(
                                  _transportController.transports[index].name
                                      .toString(),
                                  style: TextStyle(
                                      height: 1.5,
                                      color: index == state
                                          ? Colors.white
                                          : Colors.black,
                                      fontWeight: FontWeight.w600),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textScaleFactor: 1,
                                  softWrap: true,
                                  textAlign: TextAlign.center,
                                ),
                              )
                            ],
                          ),
                        ),
                      ));
            }
          });
        });
  }
}
