// import 'package:extended_image/extended_image.dart';
// import 'package:fardinexpress/features/express/controller/express_controller.dart';
// import 'package:fardinexpress/features/express/view/widget/package_form.dart';
// import 'package:fardinexpress/features/express/view/widget/sender_detail_form.dart';
// import 'package:fardinexpress/shared/bloc/file_pickup/index.dart';
// import 'package:fardinexpress/utils/bloc/indexing/indexing_bloc.dart';
// import 'package:fardinexpress/utils/bloc/indexing/indexing_event.dart';
// import 'package:fardinexpress/utils/helper/helper.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:get/get.dart';

// class DeliveryCountryPage extends StatefulWidget {
//   final String title;
//   const DeliveryCountryPage({Key? key, required this.title}) : super(key: key);

//   @override
//   State<DeliveryCountryPage> createState() => DeliveryCountryPageState();
// }

// class DeliveryCountryPageState extends State<DeliveryCountryPage> {
//   final _formKey = GlobalKey<FormState>();
//   FilePickupBloc? _filePickupBloc;
//   ExpressController _expressController =
//       Get.put(ExpressController(), tag: "delivery");
//   static TextEditingController deliveryType = TextEditingController();
//   static TextEditingController senderPhone = TextEditingController();
//   static TextEditingController senderAddress = TextEditingController();
//   static TextEditingController senderLat = TextEditingController();
//   static TextEditingController senderLong = TextEditingController();
//   static TextEditingController receiverPhone = TextEditingController();
//   static TextEditingController receiverAddress = TextEditingController();
//   static TextEditingController receiverLat = TextEditingController();
//   static TextEditingController receiverLong = TextEditingController();
//   static TextEditingController note = TextEditingController();
//   static TextEditingController paymentNote = TextEditingController();
//   static TextEditingController total = TextEditingController();

//   @override
//   void initState() {
//     _filePickupBloc = FilePickupBloc();
//     super.initState();
//   }

//   void clearTextInput() {
//     senderPhone.clear();
//     senderAddress.clear();
//     senderLat.clear();
//     senderLong.clear();
//     receiverPhone.clear();
//     receiverAddress.clear();
//     receiverLat.clear();
//     receiverLong.clear();
//     note.clear();
//     paymentNote.clear();
//     total.clear();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//         centerTitle: true,
//       ),
//       body: Form(
//         key: _formKey,
//         child: GestureDetector(
//           onTap: () => FocusScope.of(context).unfocus(),
//           child: Column(
//             children: [
//               Expanded(
//                 flex: 11,
//                 child: SingleChildScrollView(
//                   child: Container(
//                     margin: EdgeInsets.symmetric(horizontal: 20),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         SizedBox(
//                           height: 10,
//                         ),
//                         // transportType(),
//                         SizedBox(
//                           height: 10,
//                         ),
//                         Container(
//                           padding: EdgeInsets.symmetric(
//                               horizontal: 8.0, vertical: 10.0),
//                           decoration: BoxDecoration(
//                               color: Colors.grey[200],
//                               borderRadius: BorderRadius.circular(12.0)),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               _formTitle("Sender"
//                                   // AppLocalizations.of(context)!
//                                   //   .translate("sender")!
//                                   ),
//                               IntrinsicHeight(
//                                 child: Row(
//                                   children: [
//                                     Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Expanded(
//                                           child: Align(
//                                               alignment: Alignment.center,
//                                               child: _fieldTitle(
//                                                   Icons.my_location,
//                                                   Theme.of(context).primaryColor
//                                                   // AppLocalizations.of(context)!
//                                                   //     .translate("location")!)
//                                                   )),
//                                         ),
//                                       ],
//                                     ),
//                                     SizedBox(
//                                       width: 15,
//                                     ),
//                                     Expanded(
//                                         child: Column(
//                                       mainAxisSize: MainAxisSize.min,
//                                       children: [
//                                         _senderPhone(context),
//                                         _senderAddress(context)
//                                         // SizedBox(
//                                         //   height: 10,
//                                         // ),
//                                         // _pickupDetailField(),
//                                       ],
//                                     ))
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         SizedBox(
//                           height: 10,
//                         ),
//                         Container(
//                           padding: EdgeInsets.symmetric(
//                               horizontal: 8.0, vertical: 10.0),
//                           decoration: BoxDecoration(
//                               color: Colors.grey[200],
//                               borderRadius: BorderRadius.circular(12.0)),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               _formTitle(
//                                 "Receiver",
//                                 // AppLocalizations.of(context)!
//                                 //   .translate("receiver")!
//                               ),
//                               // SizedBox(
//                               //   height: 20,
//                               // ),
//                               IntrinsicHeight(
//                                 child: Row(
//                                   children: [
//                                     Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Expanded(
//                                           child: Align(
//                                               alignment: Alignment.center,
//                                               child: _fieldTitle(
//                                                   Icons.pin_drop_outlined,
//                                                   Colors.red
//                                                   // AppLocalizations.of(context)!
//                                                   //     .translate("location")!
//                                                   )),
//                                         ),
//                                         // Expanded(
//                                         //   child: Align(
//                                         //       alignment: Alignment.center,
//                                         //       child: _fieldTitle(
//                                         //           Icons.local_phone_outlined,
//                                         //           Colors.blue
//                                         //           // AppLocalizations.of(context)!
//                                         //           //     .translate("phone")!
//                                         //           )),
//                                         // ),
//                                         // Expanded(
//                                         //   child: Align(
//                                         //       alignment: Alignment.center,
//                                         //       child: _fieldTitle(
//                                         //         "Address",
//                                         //         // AppLocalizations.of(context)!
//                                         //         //     .translate("address")!
//                                         //       )),
//                                         // ),
//                                         // Expanded(
//                                         //   child: Align(
//                                         //       alignment: Alignment.center,
//                                         //       child: _fieldTitle(
//                                         //           AppLocalizations.of(context)!
//                                         //               .translate(
//                                         //                   "packagePrice")!)),
//                                         // ),
//                                       ],
//                                     ),
//                                     SizedBox(
//                                       width: 15,
//                                     ),
//                                     Expanded(
//                                         child: Column(
//                                       mainAxisSize: MainAxisSize.min,
//                                       children: [
//                                         _receiverPhone(context),
//                                         _receiverAddress(context),
//                                       ],
//                                     ))
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         SizedBox(
//                           height: 10,
//                         ),
//                         Container(
//                           width: double.infinity,
//                           padding:
//                               EdgeInsets.only(left: 8.0, right: 8.0, top: 10),
//                           decoration: BoxDecoration(
//                               color: Colors.grey[200],
//                               borderRadius: BorderRadius.circular(12.0)),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               _formTitle(
//                                 "Package",
//                                 // AppLocalizations.of(context)!
//                                 //     .translate("packagePrice")!
//                               ),
//                               SizedBox(
//                                 height: 12,
//                               ),
//                               _packagePrice(context),
//                               _note(context)
//                             ],
//                           ),
//                         ),
//                         SizedBox(
//                           height: 10,
//                         ),
//                         _orderPhoto(context)
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               Expanded(
//                   flex: 1,
//                   child: Container(
//                       margin: EdgeInsets.only(bottom: 10.0),
//                       child: _submitBtn(context))),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget transportType(BuildContext _) {
//     return BlocBuilder(
//         bloc: selectingBloc,
//         builder: (BuildContext context, dynamic state) {
//           return GridView.builder(
//               shrinkWrap: true,
//               physics: NeverScrollableScrollPhysics(),
//               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                   childAspectRatio: 4 / 4,
//                   crossAxisCount: 3,
//                   crossAxisSpacing: 15,
//                   mainAxisSpacing: 5),
//               itemCount: 3,
//               itemBuilder: (context, index) => GestureDetector(
//                     onTap: () => selectingBloc.add(Taped(index: index)),
//                     child: Container(
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(8.0),
//                         // boxShadow: [
//                         //   BoxShadow(
//                         //       color: Colors.grey[300]!,
//                         //       offset: Offset(0.0, 0.5), //(x,y)
//                         //       blurRadius: 3.0,
//                         //       spreadRadius: 0.0),
//                         // ],
//                         color: index == state ? Colors.amber : Colors.white,
//                         // borderRadius: BorderRadius.circular(8.0)
//                       ),
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Expanded(
//                             flex: 7,
//                             child: Container(
//                               child: Row(
//                                 children: [
//                                   Expanded(
//                                     flex: 2,
//                                     child: Center(),
//                                   ),
//                                   Expanded(
//                                     flex: 8,
//                                     child: AspectRatio(
//                                       aspectRatio: 1,
//                                       child: Container(
//                                         padding: EdgeInsets.all(6.0),
//                                         // decoration: BoxDecoration(
//                                         //     // shape: BoxShape.circle,
//                                         //     borderRadius: BorderRadius.circular(8.0),
//                                         //     boxShadow: [
//                                         //       BoxShadow(
//                                         //           color: Colors.grey[300]!,
//                                         //           offset: Offset(0.0, 0.5), //(x,y)
//                                         //           blurRadius: 3.0,
//                                         //           spreadRadius: 0.0),
//                                         //     ],
//                                         //     color: Colors.white),
//                                         child: ExtendedImage.network(
//                                           "",
//                                           errorWidget: Image.asset(
//                                               "assets/img/scooter.png"),
//                                           cacheWidth: 50,
//                                           cacheHeight: 50,
//                                           enableMemoryCache: true,
//                                           clearMemoryCacheWhenDispose: true,
//                                           clearMemoryCacheIfFailed: false,
//                                           fit: BoxFit.cover,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                   Expanded(
//                                     flex: 2,
//                                     child: Center(),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           SizedBox(
//                             height: 5,
//                           ),
//                           Expanded(
//                             flex: 3,
//                             child: Text(
//                               "Transport $index",
//                               style: TextStyle(
//                                   height: 1.5,
//                                   color: index == state
//                                       ? Colors.white
//                                       : Colors.black,
//                                   fontWeight: FontWeight.w600),
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                               textScaleFactor: 1,
//                               softWrap: true,
//                               textAlign: TextAlign.center,
//                             ),
//                           )
//                         ],
//                       ),
//                     ),
//                   ));
//         });
//   }

//   Widget _submitBtn(BuildContext _) {
//     return Container(
//         width: double.infinity,
//         margin: EdgeInsets.symmetric(horizontal: 10.0),
//         padding: EdgeInsets.only(left: 10.0, right: 10.0),
//         decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(8.0),
//             color: Theme.of(context).primaryColor),
//         child: ElevatedButton(
//             onPressed: () {
//               // if (_filePickupBloc!.state == null) {
//               //   customDialog(
//               //       context, "", Text("Please choose transfer image"), () {});
//               // } else {
//               //   _onTopup();
//               // }
//               // _onAddPicpup();

//               if (_formKey.currentState!.validate()) {
//                 _expressController.toRequestPickup(
//                     deliveryType: "delivery",
//                     senderPhone: senderPhone.text,
//                     senderAddress: senderAddress.text,
//                     senderLat: senderLat.text,
//                     senderLong: senderLong.text,
//                     receiverLat: receiverLat.text,
//                     receiverLong: receiverLong.text,
//                     receiverPhone: receiverPhone.text,
//                     receiverAddress: receiverAddress.text,
//                     note: note.text,
//                     paymentNote: (paymentNote.text == "Bank" ? "no" : "yes"),
//                     total: total.text);
//               }
//             },
//             style: ElevatedButton.styleFrom(
//                 primary: Colors.transparent, elevation: 0),
//             child: Text(
//               "Book Now",
//               // AppLocalizations.of(context)!.translate("bookNow")!,
//               // AppLocalizations.of(context)!.translate("submission")!,
//               // AppLocalizations.of(context)!.translate("deposite")!,
//               textScaleFactor: 1.2,
//             )));
//   }

//   Widget _orderPhoto(BuildContext _) {
//     return Container(
//         margin: EdgeInsets.only(bottom: 10),
//         decoration: BoxDecoration(
//             color: Colors.white,
//             // color: Theme.of(context).buttonColor,
//             borderRadius: BorderRadius.all(Radius.circular(8.0))),
//         width: double.infinity,
//         padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               "Upload Photo",
//               // AppLocalizations.of(context)!.translate("uploadTranPhoto")!
//             ),
//             SizedBox(
//               height: 10,
//             ),
//             Divider(),
//             GestureDetector(
//               onTap: () {
//                 _showPicker(context);
//                 // uploadPhoto(photo: _image);
//               },
//               child: Container(
//                 alignment: Alignment.center,
//                 height: MediaQuery.of(context).size.width / 3,
//                 child: AspectRatio(
//                     aspectRatio: 1,
//                     child: BlocBuilder(
//                       bloc: _filePickupBloc,
//                       builder: (context, dynamic state) {
//                         return FittedBox(
//                             fit: BoxFit.fitHeight,
//                             child: (state == null)
//                                 ? Icon(
//                                     Icons.add_photo_alternate_outlined,
//                                     color: Colors.grey[300],
//                                   )
//                                 : Image.file(state));
//                       },
//                     )),
//               ),
//             )
//           ],
//         ));
//   }

//   Widget _formTitle(String text) {
//     return Text(
//       text,
//       textScaleFactor: 1.2,
//       style: Theme.of(context)
//           .textTheme
//           .subtitle1!
//           .copyWith(fontWeight: FontWeight.bold),
//     );
//   }

//   Widget _receiverAddress(BuildContext context) {
//     return TextFormField(
//       // key: receiverAddressKey,
//       // enabled: false,
//       onTap: () => Get.to(() => AddressFormPage(
//             addressDertailType: AddressDertailType.receiver,
//           )),
//       readOnly: true,
//       controller: receiverAddress,
//       maxLines: 2,
//       validator: (v) {
//         if (v!.isEmpty) {
//           return "Required";
//           // AppLocalizations.of(context)!.translate("required");
//         } else {
//           return null;
//         }
//       },
//       decoration: InputDecoration(
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(8),
//             borderSide: BorderSide(
//               color: Colors.grey[200]!,
//             ),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(8),
//             borderSide: BorderSide(color: Theme.of(context).primaryColor),
//           ),
//           hintText: "Address",
//           contentPadding: EdgeInsets.all(0),
//           // EdgeInsets.symmetric(vertical: 0, horizontal: 15),
//           filled: true,
//           hintStyle: TextStyle(color: Colors.grey[800]),
//           fillColor: Colors.grey[200]!),
//     );
//     // ListTile(
//     //   title: Text(receiverPhone.text),
//     //   subtitle: Text(
//     //     receiverAddress.text,
//     //     maxLines: 2,
//     //     overflow: TextOverflow.clip,
//     //   ),
//     // );
//   }

//   Widget _receiverPhone(BuildContext context) {
//     return TextFormField(
//       // key: receiverPhoneKey,
//       // enabled: false,
//       onTap: () => Get.to(() => AddressFormPage(
//             addressDertailType: AddressDertailType.receiver,
//           )),
//       readOnly: true,
//       maxLines: 1,
//       style: TextStyle(fontSize: 18),
//       controller: receiverPhone,
//       validator: (v) {
//         if (v!.isEmpty) {
//           return "Required";
//           // AppLocalizations.of(context)!.translate("required");
//         } else {
//           return null;
//         }
//       },
//       decoration: InputDecoration(
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(8),
//             borderSide: BorderSide(
//               color: Colors.grey[200]!,
//             ),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(8),
//             borderSide: BorderSide(color: Theme.of(context).primaryColor),
//           ),
//           hintText: "Phone",
//           contentPadding: EdgeInsets.all(0),
//           // EdgeInsets.symmetric(vertical: 0, horizontal: 15),
//           filled: true,
//           hintStyle: TextStyle(color: Colors.grey[800]),
//           fillColor: Colors.grey[200]!),
//     );
//   }

//   Widget _fieldTitle(var iconTitle, var iconColor) {
//     // return Text(
//     //   text,
//     //   style: Theme.of(context)
//     //       .textTheme
//     //       .subtitle1!
//     //       .copyWith(fontWeight: FontWeight.w400),
//     // );
//     return Icon(iconTitle, color: iconColor);
//   }

//   Widget _senderAddress(BuildContext context) {
//     return TextFormField(
//       // key: _formKey,
//       // enabled: false,
//       onTap: () => Get.to(() => AddressFormPage(
//             addressDertailType: AddressDertailType.sender,
//           )),
//       readOnly: true,
//       controller: senderAddress,
//       maxLines: 2,
//       validator: (v) {
//         if (v!.isEmpty) {
//           return "Required";
//           // AppLocalizations.of(context)!.translate("required");
//         } else {
//           return null;
//         }
//       },
//       decoration: InputDecoration(
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(8),
//             borderSide: BorderSide(
//               color: Colors.grey[200]!,
//             ),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(8),
//             borderSide: BorderSide(color: Theme.of(context).primaryColor),
//           ),
//           hintText: "Address",
//           contentPadding: EdgeInsets.all(0),
//           // EdgeInsets.only(top: 0, left: 15, right: 15, bottom: 10),
//           filled: true,
//           hintStyle: TextStyle(color: Colors.grey[800]),
//           fillColor: Colors.grey[200]!),
//     );
//   }

//   Widget _senderPhone(BuildContext context) {
//     return TextFormField(
//       // key: _formKey,
//       // enabled: false,
//       onTap: () => Get.to(() => AddressFormPage(
//             addressDertailType: AddressDertailType.sender,
//           )),
//       readOnly: true,
//       controller: senderPhone,
//       maxLines: 1,
//       style: TextStyle(fontSize: 18),
//       validator: (v) {
//         if (v!.isEmpty) {
//           return "Required";
//           // AppLocalizations.of(context)!.translate("required");
//         } else {
//           return null;
//         }
//       },
//       decoration: InputDecoration(
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(8),
//             borderSide: BorderSide(
//               color: Colors.grey[200]!,
//             ),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(8),
//             borderSide: BorderSide(color: Theme.of(context).primaryColor),
//           ),
//           hintText: "Phone",
//           contentPadding: EdgeInsets.all(0),
//           // EdgeInsets.only(top: 10, left: 15, right: 15, bottom: 0),
//           filled: true,
//           hintStyle: TextStyle(color: Colors.grey[800]),
//           fillColor: Colors.grey[200]!),
//     );
//   }

//   Widget _packagePrice(BuildContext context) {
//     return TextFormField(
//       // key: _formKey,
//       // enabled: false,
//       onTap: () => Get.to(() => PackageFormPage()),
//       readOnly: true,
//       controller: total,
//       maxLines: 1,
//       style: TextStyle(fontSize: 18, color: Colors.amber[900]),
//       validator: (v) {
//         if (v!.isEmpty) {
//           return "Required";
//           // AppLocalizations.of(context)!.translate("required");
//         } else {
//           return null;
//         }
//       },
//       decoration: InputDecoration(
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(8),
//             borderSide: BorderSide(
//               color: Colors.grey[200]!,
//             ),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(8),
//             borderSide: BorderSide(color: Theme.of(context).primaryColor),
//           ),
//           label: Text("Package Price: "),
//           hintText: "Package Price",
//           contentPadding: EdgeInsets.all(0),
//           // EdgeInsets.only(top: 0, left: 15, right: 15, bottom: 10),
//           filled: true,
//           hintStyle: TextStyle(color: Colors.grey[800]),
//           fillColor: Colors.grey[200]!),
//     );
//   }

//   Widget _note(BuildContext context) {
//     return TextFormField(
//       // key: _receiverAddressKey,
//       // enabled: false,
//       onTap: () => Get.to(() => PackageFormPage()),
//       readOnly: true,
//       controller: note,
//       maxLines: 2,
//       style: TextStyle(color: Colors.grey[600]),
//       // validator: (v) {
//       //   if (v!.isEmpty) {
//       //     return "Required";
//       //     // AppLocalizations.of(context)!.translate("required");
//       //   } else {
//       //     return null;
//       //   }
//       // },
//       decoration: InputDecoration(
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(8),
//             borderSide: BorderSide(
//               color: Colors.grey[200]!,
//             ),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(8),
//             borderSide: BorderSide(color: Theme.of(context).primaryColor),
//           ),
//           label: Text("Note: "),
//           hintText: "Note",
//           contentPadding: EdgeInsets.all(0),
//           // EdgeInsets.only(top: 0, left: 15, right: 15, bottom: 10),
//           filled: true,
//           hintStyle: TextStyle(color: Colors.grey[800]),
//           fillColor: Colors.grey[200]!),
//     );
//   }

//   void _showPicker(context) {
//     showModalBottomSheet(
//         context: context,
//         builder: (BuildContext bc) {
//           return SafeArea(
//             child: Container(
//               child: new Wrap(
//                 children: <Widget>[
//                   new ListTile(
//                       leading: new Icon(Icons.photo_library),
//                       title: new Text('Photo Library'),
//                       onTap: () {
//                         Helper.imgFromGallery((image) {
//                           _filePickupBloc!.add(image);
//                         });
//                         Navigator.of(context).pop();
//                       }),
//                   new ListTile(
//                     leading: new Icon(Icons.photo_camera),
//                     title: new Text('Camera'),
//                     onTap: () {
//                       Helper.imgFromCamera((image) {
//                         _filePickupBloc!.add(image);
//                       });
//                       Navigator.of(context).pop();
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           );
//         });
//   }

//   @override
//   void dispose() {
//     _filePickupBloc!.close();
//     clearTextInput();
//     super.dispose();
//   }
// }
