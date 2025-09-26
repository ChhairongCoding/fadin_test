import 'package:fardinexpress/features/express/view/widget/sender_detail_form.dart';
import 'package:flutter/material.dart';
// import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';

class LocationPickupPage extends StatelessWidget {
  final AddressDertailType addressDertailType;
  const LocationPickupPage({Key? key, required this.addressDertailType})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container();
    // return PlacePicker(
    //     region: "KH",
    //     selectInitialPosition: true,
    //     enableMyLocationButton: true,
    //     useCurrentLocation: true,
    //     apiKey: "${dotenv.env['mapApiKey']}",
    //     initialPosition: LatLng(11.564021, 104.913244),
    //     selectedPlaceWidgetBuilder: (contex, result, searchState, a) {
    //       return Align(
    //         alignment: Alignment.bottomCenter,
    //         child: Column(
    //           mainAxisAlignment: MainAxisAlignment.end,
    //           children: [
    //             Container(
    //               decoration: BoxDecoration(
    //                   color: Colors.white,
    //                   borderRadius: BorderRadius.all(Radius.circular(18))),
    //               width: double.infinity,
    //               margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
    //               padding: EdgeInsets.all(20),
    //               child: (searchState == SearchingState.Searching)
    //                   ? Center(child: CircularProgressIndicator())
    //                   : Text(result!.formattedAddress!),
    //             ),
    //             Padding(
    //               padding:
    //                   const EdgeInsets.only(left: 15, right: 15, bottom: 20),
    //               child: AspectRatio(
    //                 aspectRatio: 10 / 1.3,
    //                 child: Container(
    //                     width: double.infinity,
    //                     height: 45,
    //                     child: ElevatedButton(
    //                       onPressed: () async {
    //                         if (addressDertailType ==
    //                             AddressDertailType.sender) {
    //                           DeliveryLocalPageState.senderAddress.text =
    //                               result!.formattedAddress.toString();
    //                           DeliveryLocalPageState.senderLat.text =
    //                               result.geometry!.location.lat.toString();
    //                           DeliveryLocalPageState.senderLong.text =
    //                               result.geometry!.location.lng.toString();
    //                         } else if (addressDertailType ==
    //                             AddressDertailType.receiver) {
    //                           DeliveryLocalPageState.receiverAddress.text =
    //                               result!.formattedAddress.toString();
    //                           DeliveryLocalPageState.receiverLat.text =
    //                               result.geometry!.location.lat.toString();
    //                           DeliveryLocalPageState.receiverLong.text =
    //                               result.geometry!.location.lng.toString();
    //                         } else {
    //                           AddAddressFormState.descriptionCtr.text =
    //                               result!.formattedAddress.toString();
    //                           AddAddressFormState.lat.text =
    //                               result.geometry!.location.lat.toString();
    //                           AddAddressFormState.long.text =
    //                               result.geometry!.location.lng.toString();
    //                         }
    //                       },
    //                       style: ElevatedButton.styleFrom(
    //                         backgroundColor: Colors.blue,
    //                         shape: RoundedRectangleBorder(
    //                             borderRadius: BorderRadius.circular(18.0)),
    //                       ),
    //                       child: Container(
    //                         alignment: Alignment.center,
    //                         child: Text(
    //                           "Select",
    //                           // (AppLocalizations.of(context)!
    //                           //     .translate('select')),
    //                           textScaleFactor: 1.2,
    //                           textAlign: TextAlign.center,
    //                           style: TextStyle(
    //                               color: Colors.white, letterSpacing: 1),
    //                         ),
    //                       ),
    //                     )),
    //               ),
    //             ),
    //           ],
    //         ),
    //       );
    //     });
  }
}
