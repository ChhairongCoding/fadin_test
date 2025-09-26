import 'package:extended_image/extended_image.dart';
import 'package:fardinexpress/features/account/controller/account_controller.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/feature/transport/controller/transport_controller.dart';
import 'package:fardinexpress/features/express/controller/express_controller.dart';
import 'package:fardinexpress/features/express/view/widget/package_form.dart';
import 'package:fardinexpress/features/express/view/widget/sender_detail_form.dart';
import 'package:fardinexpress/features/zone/controller/zone_controller.dart';
import 'package:fardinexpress/shared/bloc/file_pickup/index.dart';
import 'package:fardinexpress/utils/bloc/indexing/indexing_bloc.dart';
import 'package:fardinexpress/utils/bloc/indexing/indexing_event.dart';
import 'package:fardinexpress/utils/component/widget/dialog_message_widget.dart';
import 'package:fardinexpress/utils/helper/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class DeliveryLocalPage extends StatefulWidget {
  final String title;
  final String transportType;
  const DeliveryLocalPage(
      {Key? key, required this.title, required this.transportType})
      : super(key: key);

  @override
  State<DeliveryLocalPage> createState() => DeliveryLocalPageState();
}

class DeliveryLocalPageState extends State<DeliveryLocalPage> {
  final _formKey = GlobalKey<FormState>();
  FilePickupBloc? _filePickupBloc;
  bool isPicked = false;
  ExpressController _expressController = Get.put(ExpressController());
  TransportController? _transportController;
  static TextEditingController deliveryType = TextEditingController();
  static TextEditingController senderPhone = TextEditingController();
  static TextEditingController senderAddress = TextEditingController();
  static TextEditingController senderLat = TextEditingController();
  static TextEditingController senderLong = TextEditingController();
  static TextEditingController receiverPhone = TextEditingController();
  static TextEditingController receiverAddress = TextEditingController();
  static TextEditingController receiverLat = TextEditingController();
  static TextEditingController receiverLong = TextEditingController();
  static TextEditingController note = TextEditingController();
  static TextEditingController paymentNote = TextEditingController();
  static TextEditingController total = TextEditingController();
  static TextEditingController packagePriceCtr = TextEditingController();
  static TextEditingController provinceCtr = TextEditingController();
  static TextEditingController districtCtr = TextEditingController();
  static TextEditingController zoneCtr = TextEditingController();
  static TextEditingController feeCtr = TextEditingController();
  static TextEditingController currencyIdCtr = TextEditingController();
  static TextEditingController currencySymbolCtr = TextEditingController();
  static TextEditingController currencyTypeCtr = TextEditingController();
  // ZoneController _zoneController = Get.put(ZoneController(), tag: "zone");
  String tranType = "";

  var alertStyle = AlertStyle(
    // animationType: AnimationType.grow,
    // isCloseButton: false,
    isOverlayTapDismiss: false,
    // descStyle: TextStyle(fontWeight: FontWeight.bold),
    descTextAlign: TextAlign.start,
    // animationDuration: Duration(milliseconds: 400),
    // alertBorder: RoundedRectangleBorder(
    //   borderRadius: BorderRadius.circular(0.0),
    //   side: BorderSide(
    //     color: Colors.grey,
    //   ),
    // ),
    titleStyle: TextStyle(
      color: Colors.red,
    ),
    // alertAlignment: Alignment.center,
  );

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
                    Navigator.pop(context);
                    // if (_zoneController.zoneList.length != 0) {
                    //   _zoneController.zoneList.clear();
                    // } else {}
                    // Navigator.pop(context);
                  },
                  child: Text("Done"))
            ],
          );
        });
  }

  @override
  void initState() {
    _filePickupBloc = FilePickupBloc();
    senderPhone.text = Get.find<AccountController>().accountInfo.phone;
    senderAddress.text =
        Get.find<AccountController>().accountInfo.address.description;
    senderLat.text = Get.find<AccountController>().accountInfo.address.lat;
    senderLong.text = Get.find<AccountController>().accountInfo.address.long;
    _transportController =
        Get.put(TransportController(widget.transportType), tag: "cargo");
    // _zoneController.getZoneList();
    // _zoneController.paginateZoneList();
    super.initState();
  }

  void clearTextInput() {
    senderPhone.clear();
    senderAddress.clear();
    zoneCtr.clear();
    feeCtr.clear();
    senderLat.clear();
    senderLong.clear();
    receiverPhone.clear();
    receiverAddress.clear();
    receiverLat.clear();
    receiverLong.clear();
    note.clear();
    paymentNote.clear();
    total.clear();
    currencyTypeCtr.clear();
    packagePriceCtr.clear();
    provinceCtr.clear();
    districtCtr.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.green,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Form(
        key: _formKey,
        child: Stack(
          children: [
            widget.transportType == "express"
                ? transportType(context)
                : Container(),
            Container(
              color: Colors.grey[50],
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.3,
            ),
            Column(
              children: [
                Expanded(
                  flex: 11,
                  child: SingleChildScrollView(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          (widget.transportType == "cargo")
                              ? Obx(() {
                                  if (_transportController!.isLoading.value) {
                                    return Container();
                                  } else {
                                    return transportType(context);
                                  }
                                })
                              : Container(),
                          SizedBox(
                            height: 10,
                          ),
                          //Sender widget
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 14.0, vertical: 14.0),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12.0),
                                border: Border.all(
                                  color: Colors.grey[200]!,
                                  width: 1,
                                )),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _formTitle("sender".tr),
                                IntrinsicHeight(
                                  child: Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Align(
                                                alignment: Alignment.center,
                                                child: _fieldTitle(
                                                    Icons.my_location,
                                                    Theme.of(context)
                                                        .primaryColor
                                                    // AppLocalizations.of(context)!
                                                    //     .translate("location")!)
                                                    )),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Expanded(
                                          child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          _senderPhone(context),
                                          _senderAddress(context)
                                          // SizedBox(
                                          //   height: 10,
                                          // ),
                                          // _pickupDetailField(),
                                        ],
                                      ))
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          //Receiver widget
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 14.0, vertical: 14.0),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12.0),
                                border: Border.all(
                                  color: Colors.grey[200]!,
                                  width: 1,
                                )),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _formTitle(
                                  "receiver".tr,
                                  // AppLocalizations.of(context)!
                                  //   .translate("receiver")!
                                ),
                                // SizedBox(
                                //   height: 20,
                                // ),
                                IntrinsicHeight(
                                  child: Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Align(
                                                alignment: Alignment.center,
                                                child: _fieldTitle(
                                                    Icons.pin_drop_outlined,
                                                    Colors.red
                                                    // AppLocalizations.of(context)!
                                                    //     .translate("location")!
                                                    )),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Expanded(
                                          child: (widget.transportType ==
                                                      "express" ||
                                                  widget.transportType ==
                                                      "cargo")
                                              ? Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    _receiverPhone(context),
                                                    // zoneField(context)
                                                    _receiverAddress(context),
                                                  ],
                                                )
                                              : widget.transportType ==
                                                      "delivery"
                                                  ? Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        _receiverPhone(context),
                                                        zoneField(context),
                                                      ],
                                                    )
                                                  : Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        _receiverPhone(context),
                                                        _province(context),
                                                        _district(context)
                                                      ],
                                                    ))
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // SizedBox(
                          //   height: 12,
                          // ),
                          Obx(() {
                            if (_expressController.getDeliveryFee.value == "") {
                              return Container();
                            } else {
                              return Container(
                                width: double.infinity,
                                margin: EdgeInsets.only(top: 10),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 14.0, vertical: 14.0),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12.0),
                                    border: Border.all(
                                      color: Colors.grey[200]!,
                                      width: 1,
                                    )),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _formTitle("deliveryFee".tr),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "${_expressController.getDeliveryFee.value}",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.blue),
                                    )
                                  ],
                                ),
                              );
                            }
                          }),
                          Obx(() {
                            if (_expressController.getZoneFee.value == "") {
                              return Container();
                            } else {
                              return Container(
                                width: double.infinity,
                                margin: EdgeInsets.only(top: 10),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 14.0, vertical: 14.0),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12.0),
                                    border: Border.all(
                                      color: Colors.grey[200]!,
                                      width: 1,
                                    )),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _formTitle("deliveryFee".tr),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "${currencySymbolCtr.text} ${_expressController.getZoneFee.value}",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.blue),
                                    )
                                  ],
                                ),
                              );
                            }
                          }),
                          Obx(() {
                            if (_expressController.getProvinceFee.value == "") {
                              return Container();
                            } else {
                              return Container(
                                width: double.infinity,
                                margin: EdgeInsets.only(top: 10),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 14.0, vertical: 14.0),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12.0),
                                    border: Border.all(
                                      color: Colors.grey[200]!,
                                      width: 1,
                                    )),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _formTitle("deliveryFee".tr),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "${currencySymbolCtr.text} ${_expressController.getProvinceFee.value}",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.blue),
                                    )
                                  ],
                                ),
                              );
                            }
                          }),
                          SizedBox(
                            height: 10,
                          ),
                          //package infor
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.only(
                                left: 14.0, right: 14.0, top: 14),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12.0),
                                border: Border.all(
                                  color: Colors.grey[200]!,
                                  width: 1,
                                )),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _formTitle(
                                  "package".tr,
                                  // AppLocalizations.of(context)!
                                  //     .translate("packagePrice")!
                                ),
                                // SizedBox(
                                //   height: 12,
                                // ),
                                _packagePrice(context, widget.transportType),
                                SizedBox(
                                  height: 12,
                                ),
                                note.text.isEmpty ? Container() : _note(context)
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          _orderPhoto(context)
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                    flex: 1,
                    child: Container(
                        margin: EdgeInsets.only(bottom: 15.0),
                        child: _submitBtn(context, widget.transportType))),
                // SizedBox(
                //   height: 15,
                // )
              ],
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
            if (_transportController!.isLoading.value) {
              return Center(child: CircularProgressIndicator());
            } else {
              if (_transportController!.transports.length > 0) {
                tranType = _transportController!.transports[0].id.toString();
              }
              return GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 4 / 4,
                      crossAxisCount: 3,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 5),
                  itemCount: _transportController!.transports.length,
                  itemBuilder: (context, index) => GestureDetector(
                        onTap: () {
                          selectingBloc.add(Taped(index: index));
                          _transportController!.tempTranId.value =
                              _transportController!.transports[index].id
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
                                              _transportController!
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
                                  _transportController!.transports[index].name
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

  Widget _submitBtn(BuildContext _, String transportName) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          fixedSize: Get.size * 0.9,
          backgroundColor: Colors.green,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            // print("Get Fee: " + feeCtr.text);
            if (isPicked == true) {
              _expressController.toRequestPickup(
                  deliveryType: widget.transportType,
                  senderPhone: senderPhone.text,
                  senderAddress: senderAddress.text,
                  senderLat: senderLat.text,
                  senderLong: senderLong.text,
                  receiverLat: receiverLat.text,
                  receiverLong: receiverLong.text,
                  receiverPhone: receiverPhone.text,
                  receiverAddress: (widget.transportType == "province")
                      ? provinceCtr.text + " ${districtCtr.text}"
                      : receiverAddress.text,
                  note: note.text,
                  paymentNote: (widget.transportType == "province" ||
                          widget.transportType == "cargo")
                      ? "no"
                      : (paymentNote.text == "Bank" ? "no" : "yes"),
                  total: total.text,
                  transportId: _transportController!.tempTranId.value,
                  showTransportType: "items",
                  currencyId: currencyIdCtr.text,
                  deliveryFee: _expressController.getDeliveryFee.value == ""
                      ? feeCtr.text.isEmpty
                          ? "0"
                          : feeCtr.text
                      : _expressController.getDeliveryFee.value,
                  image: _filePickupBloc!.state);
            } else {
              // showDialog(
              //     context: context,
              //     builder: ((context) {
              //       return AlertDialog(
              //         title: Text("alert".tr),
              //         content:
              //             Text("Please select transfer image before booking."),
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
              DialogMessageWidget.show(
                context: context,
                title: "alert".tr,
                message: "Please select transfer image before booking.",
                success: 2,
              );
            }
          }
        },
        // style: ElevatedButton.styleFrom(
        //     primary: Colors.transparent, elevation: 0),
        child: Text(
          'Book Now',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18),
        ));
  }

  Widget _orderPhoto(BuildContext _) {
    return Container(
        margin: EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
            color: Colors.white,
            // color: Theme.of(context).buttonColor,
            borderRadius: BorderRadius.all(Radius.circular(8.0))),
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "uploadTranPhoto".tr,
              // AppLocalizations.of(context)!.translate("uploadTranPhoto")!
            ),
            SizedBox(
              height: 10,
            ),
            Divider(),
            GestureDetector(
              onTap: () {
                _showPicker(context);
                // uploadPhoto(photo: _image);
              },
              child: Container(
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.width / 3,
                child: AspectRatio(
                    aspectRatio: 1,
                    child: BlocBuilder(
                      bloc: _filePickupBloc,
                      builder: (context, dynamic state) {
                        return FittedBox(
                            fit: BoxFit.fitHeight,
                            child: (state == null)
                                ? Icon(
                                    Icons.add_photo_alternate_outlined,
                                    color: Colors.grey[300],
                                  )
                                : Image.file(state));
                      },
                    )),
              ),
            )
          ],
        ));
  }

  Widget _formTitle(String text) {
    return Text(
      text,
      textScaleFactor: 1.2,
      style: Theme.of(context)
          .textTheme
          .titleMedium!
          .copyWith(fontWeight: FontWeight.bold),
    );
  }

  Widget _receiverAddress(BuildContext context) {
    return TextFormField(
      // key: receiverAddressKey,
      // enabled: false,
      onTap: () async {
        // final result = await Get.to(() => AddressFormPage(
        //       addressDertailType: AddressDertailType.receiver,
        //       transportType: widget.transportType,
        //     ));
        // if (result == true && widget.transportType == "express") {
        //   _expressController.toCalculateDeliveryFee(
        //       deliveryType: widget.transportType,
        //       senderPhone: senderPhone.text,
        //       senderAddress: senderAddress.text,
        //       senderLat: senderLat.text,
        //       senderLong: senderLong.text,
        //       receiverLat: receiverLat.text,
        //       receiverLong: receiverLong.text,
        //       receiverPhone: receiverPhone.text,
        //       receiverAddress: (widget.transportType == "province")
        //           ? provinceCtr.text + " ${districtCtr.text}"
        //           : receiverAddress.text,
        //       note: note.text,
        //       paymentNote: (widget.transportType == "province" ||
        //               widget.transportType == "cargo")
        //           ? "no"
        //           : (paymentNote.text == "Bank" ? "no" : "yes"),
        //       total: total.text,
        //       transportId: tranType,
        //       showTransportType: "items",
        //       currencyId: currencyIdCtr.text,
        //       deliveryFee: feeCtr.text.isEmpty ? "0" : feeCtr.text);
        // } else if (result == true && widget.transportType == "delivery") {
        //   _expressController.getZoneFee.value = feeCtr.text;
        // } else if (result == true && widget.transportType == "province") {
        //   _expressController.getProvinceFee.value = feeCtr.text;
        // }
      },
      readOnly: true,
      controller: receiverAddress,
      maxLines: 2,
      validator: (v) {
        if (v!.isEmpty) {
          return "Required";
          // AppLocalizations.of(context)!.translate("required");
        } else {
          return null;
        }
      },
      decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: Colors.white,
            ),
          ),
          focusedBorder: InputBorder.none,
          // focusedBorder: OutlineInputBorder(
          //   borderRadius: BorderRadius.circular(8),
          //   borderSide: BorderSide(color: Theme.of(context).primaryColor),
          // ),
          hintText: "address".tr,
          contentPadding: EdgeInsets.all(0),
          // EdgeInsets.symmetric(vertical: 0, horizontal: 15),
          filled: true,
          hintStyle: TextStyle(color: Colors.grey[800]),
          fillColor: Colors.white),
    );
    // ListTile(
    //   title: Text(receiverPhone.text),
    //   subtitle: Text(
    //     receiverAddress.text,
    //     maxLines: 2,
    //     overflow: TextOverflow.clip,
    //   ),
    // );
  }

  Widget _province(BuildContext context) {
    return TextFormField(
      // key: receiverAddressKey,
      // enabled: false,
      onTap: () {},
      // Get.to(() => AddressFormPage(
      //       addressDertailType: AddressDertailType.receiver,
      //       transportType: widget.transportType,
      //     )),
      readOnly: true,
      controller: provinceCtr,
      maxLines: 2,
      validator: (v) {
        if (v!.isEmpty) {
          return "Required";
          // AppLocalizations.of(context)!.translate("required");
        } else {
          return null;
        }
      },
      decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none),
          focusedBorder: InputBorder.none,
          // focusedBorder: OutlineInputBorder(
          //   borderRadius: BorderRadius.circular(8),
          //   borderSide: BorderSide(color: Theme.of(context).primaryColor),
          // ),
          hintText: "province".tr,
          contentPadding: EdgeInsets.all(0),
          // EdgeInsets.symmetric(vertical: 0, horizontal: 15),
          filled: true,
          hintStyle: TextStyle(color: Colors.grey[800]),
          fillColor: Colors.white),
    );
  }

  Widget _district(BuildContext context) {
    return TextFormField(
      // key: receiverAddressKey,
      // enabled: false,
      onTap: () {},
      // => Get.to(() => AddressFormPage(
      //       addressDertailType: AddressDertailType.receiver,
      //       transportType: widget.transportType,
      //     )),
      readOnly: true,
      controller: districtCtr,
      maxLines: 2,
      validator: (v) {
        if (v!.isEmpty) {
          return "Required";
          // AppLocalizations.of(context)!.translate("required");
        } else {
          return null;
        }
      },
      decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none),
          focusedBorder: InputBorder.none,
          // focusedBorder: OutlineInputBorder(
          //   borderRadius: BorderRadius.circular(8),
          //   borderSide: BorderSide(color: Theme.of(context).primaryColor),
          // ),
          hintText: "district".tr,
          contentPadding: EdgeInsets.all(0),
          // EdgeInsets.symmetric(vertical: 0, horizontal: 15),
          filled: true,
          hintStyle: TextStyle(color: Colors.grey[800]),
          fillColor: Colors.white),
    );
  }

  Widget _receiverPhone(BuildContext context) {
    return TextFormField(
      // key: receiverPhoneKey,
      // enabled: false,
      onTap: () async {
        final result = await Get.to(() => AddressFormPage(
              addressDertailType: AddressDertailType.receiver,
              transportType: widget.transportType,
            ));
        if (result == true && widget.transportType == "express" ||
            result == true && widget.transportType == "cargo") {
          _expressController.toCalculateDeliveryFee(
              deliveryType: widget.transportType,
              senderPhone: senderPhone.text,
              senderAddress: senderAddress.text,
              senderLat: senderLat.text,
              senderLong: senderLong.text,
              receiverLat: receiverLat.text,
              receiverLong: receiverLong.text,
              receiverPhone: receiverPhone.text,
              receiverAddress: (widget.transportType == "province")
                  ? provinceCtr.text + " ${districtCtr.text}"
                  : receiverAddress.text,
              note: note.text,
              paymentNote: (widget.transportType == "province" ||
                      widget.transportType == "cargo")
                  ? "no"
                  : (paymentNote.text == "Bank" ? "no" : "yes"),
              total: total.text,
              transportId: _transportController!.tempTranId.value,
              showTransportType: "items",
              currencyId: currencyIdCtr.text,
              deliveryFee: feeCtr.text.isEmpty ? "0" : feeCtr.text);
        } else if (result == true && widget.transportType == "delivery") {
          _expressController.getZoneFee.value = feeCtr.text;
        } else if (result == true && widget.transportType == "province") {
          _expressController.getProvinceFee.value = feeCtr.text;
        }
      },
      readOnly: true,
      keyboardType: TextInputType.phone,
      maxLines: 1,
      style: TextStyle(fontSize: 18),
      controller: receiverPhone,
      validator: (v) {
        if (v!.isEmpty) {
          return "Required";
          // AppLocalizations.of(context)!.translate("required");
        } else {
          return null;
        }
      },
      decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: Colors.white,
            ),
          ),
          focusedBorder: InputBorder.none,
          // focusedBorder: OutlineInputBorder(
          //   borderRadius: BorderRadius.circular(8),
          //   borderSide: BorderSide(color: Theme.of(context).primaryColor),
          // ),
          hintText: "phone".tr,
          contentPadding: EdgeInsets.all(0),
          // EdgeInsets.symmetric(vertical: 0, horizontal: 15),
          filled: true,
          hintStyle: TextStyle(color: Colors.grey[800]),
          fillColor: Colors.white),
    );
  }

  Widget _fieldTitle(var iconTitle, var iconColor) {
    // return Text(
    //   text,
    //   style: Theme.of(context)
    //       .textTheme
    //       .subtitle1!
    //       .copyWith(fontWeight: FontWeight.w400),
    // );
    return Icon(iconTitle, color: iconColor);
  }

  Widget _senderAddress(BuildContext context) {
    return TextFormField(
      // key: _formKey,
      // enabled: false,
      onTap: () => Get.to(() => AddressFormPage(
          addressDertailType: AddressDertailType.sender,
          transportType: widget.transportType)),
      readOnly: true,
      controller: senderAddress,
      maxLines: 2,
      validator: (v) {
        if (v!.isEmpty) {
          return "Required";
          // AppLocalizations.of(context)!.translate("required");
        } else {
          return null;
        }
      },
      decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: Colors.white,
            ),
          ),
          focusedBorder: InputBorder.none,
          // focusedBorder: OutlineInputBorder(
          //   borderRadius: BorderRadius.circular(8),
          //   borderSide: BorderSide(color: Theme.of(context).primaryColor),
          // ),
          hintText: "address".tr,
          contentPadding: EdgeInsets.all(0),
          // EdgeInsets.only(top: 0, left: 15, right: 15, bottom: 10),
          filled: true,
          hintStyle: TextStyle(color: Colors.grey[800]),
          fillColor: Colors.white),
    );
  }

  Widget _senderPhone(BuildContext context) {
    return TextFormField(
      // key: _formKey,
      // enabled: false,
      onTap: () => Get.to(() => AddressFormPage(
          addressDertailType: AddressDertailType.sender,
          transportType: widget.transportType)),
      readOnly: true,
      controller: senderPhone,
      maxLines: 1,
      style: TextStyle(fontSize: 18),
      validator: (v) {
        if (v!.isEmpty) {
          return "Required";
          // AppLocalizations.of(context)!.translate("required");
        } else {
          return null;
        }
      },
      decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: Colors.white,
            ),
          ),
          focusedBorder: InputBorder.none,
          // focusedBorder: OutlineInputBorder(
          //   borderRadius: BorderRadius.circular(8),
          //   borderSide: BorderSide(color: Theme.of(context).primaryColor),
          // ),
          hintText: "phone".tr,
          contentPadding: EdgeInsets.all(0),
          // EdgeInsets.only(top: 10, left: 15, right: 15, bottom: 0),
          filled: true,
          hintStyle: TextStyle(color: Colors.grey[800]),
          fillColor: Colors.white),
    );
  }

  Widget _packagePrice(BuildContext context, String transportName) {
    return TextFormField(
      // key: _formKey,
      // enabled: false,
      onTap: () async {
        Get.to(() => PackageFormPage(
              transportType: widget.transportType,
            ));
        // if (receiverLat.text.isEmpty && feeCtr.text.isEmpty) {
        //   showDialog(
        //       context: context,
        //       builder: ((context) {
        //         return AlertDialog(
        //           backgroundColor: Colors.white,
        //           actionsAlignment: MainAxisAlignment.center,
        //           shape: RoundedRectangleBorder(
        //               borderRadius: BorderRadius.circular(12.0)),
        //           titlePadding: EdgeInsets.all(0),
        //           title: Container(
        //               padding: EdgeInsets.symmetric(vertical: 14.0),
        //               width: double.infinity,
        //               decoration: BoxDecoration(
        //                   color: Colors.blue,
        //                   borderRadius: BorderRadius.only(
        //                       topLeft: Radius.circular(12.0),
        //                       topRight: Radius.circular(12.0))),
        //               child: Center(
        //                   child: Text("alert".tr,
        //                       style: TextStyle(color: Colors.white)))),
        //           content: Text("Please fill all receiver information first."),
        //           actions: [
        //             ElevatedButton(
        //               style: ElevatedButton.styleFrom(
        //                 backgroundColor: Colors.blue,
        //                 shape: RoundedRectangleBorder(
        //                     borderRadius: BorderRadius.circular(12.0),
        //                     side: BorderSide(color: Colors.blue)),
        //               ),
        //               onPressed: () {
        //                 Navigator.pop(context);
        //               },
        //               child: Text(
        //                 "OK".tr,
        //                 style: TextStyle(color: Colors.white),
        //               ),
        //             )
        //           ],
        //         );
        //       }));
        // } else {
        //   final result = await Get.to(() => PackageFormPage(
        //         transportType: widget.transportType,
        //       ));
        //   if (result == true && widget.transportType == "express") {
        //     _expressController.toCalculateDeliveryFee(
        //         deliveryType: widget.transportType,
        //         senderPhone: senderPhone.text,
        //         senderAddress: senderAddress.text,
        //         senderLat: senderLat.text,
        //         senderLong: senderLong.text,
        //         receiverLat: receiverLat.text,
        //         receiverLong: receiverLong.text,
        //         receiverPhone: receiverPhone.text,
        //         receiverAddress: (widget.transportType == "province")
        //             ? provinceCtr.text + " ${districtCtr.text}"
        //             : receiverAddress.text,
        //         note: note.text,
        //         paymentNote: (widget.transportType == "province" ||
        //                 widget.transportType == "cargo")
        //             ? "no"
        //             : (paymentNote.text == "Bank" ? "no" : "yes"),
        //         total: total.text,
        //         transportId: tranType,
        //         showTransportType: "items",
        //         currencyId: currencyIdCtr.text,
        //         deliveryFee: feeCtr.text.isEmpty ? "0" : feeCtr.text);
        //   } else if (result == true && widget.transportType == "delivery") {
        //     _expressController.getZoneFee.value = feeCtr.text;
        //   } else if (result == true && widget.transportType == "province") {
        //     _expressController.getProvinceFee.value = feeCtr.text;
        //   }
        // }
      },
      readOnly: true,
      controller: packagePriceCtr,
      maxLines: 1,
      style: TextStyle(fontSize: 18, color: Colors.amber[900]),
      validator: (v) {
        if (v!.isEmpty) {
          return "Required";
          // AppLocalizations.of(context)!.translate("required");
        } else {
          return null;
        }
      },
      decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: Colors.white,
            ),
          ),
          // prefix: Text(currencySymbolCtr.text,
          //     style: TextStyle(color: Colors.amber[900])),
          focusedBorder: InputBorder.none,
          // label: Text("${'packagePrice'.tr}: "),
          hintText: "packagePrice".tr,
          contentPadding: EdgeInsets.all(0),
          // EdgeInsets.only(top: 0, left: 15, right: 15, bottom: 10),
          filled: true,
          hintStyle: TextStyle(color: Colors.grey[800]),
          fillColor: Colors.white),
    );
  }

  Widget _note(BuildContext context) {
    return TextFormField(
      // key: _receiverAddressKey,
      // enabled: false,
      onTap: () => Get.to(() => PackageFormPage(
            transportType: widget.transportType,
          )),
      readOnly: true,
      controller: note,
      maxLines: 2,
      style: TextStyle(color: Colors.grey[600]),
      // validator: (v) {
      //   if (v!.isEmpty) {
      //     return "Required";
      //     // AppLocalizations.of(context)!.translate("required");
      //   } else {
      //     return null;
      //   }
      // },
      decoration: InputDecoration(
          prefix: Text(
            "note".tr + ": ",
          ),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none),
          // focusedBorder: InputBorder.none,
          // focusedBorder: OutlineInputBorder(
          //   borderRadius: BorderRadius.circular(8),
          //   borderSide: BorderSide(color: Theme.of(context).primaryColor),
          // ),
          // label: Text("${'note'.tr}: "),
          // hintText: "note".tr,
          contentPadding: EdgeInsets.all(0),
          // EdgeInsets.only(top: 0, left: 15, right: 15, bottom: 10),
          filled: true,
          hintStyle: TextStyle(color: Colors.grey[800]),
          fillColor: Colors.white),
    );
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        Helper.imgFromGallery((image) {
                          _filePickupBloc!.add(image);
                          isPicked = true;
                        });
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      Helper.imgFromCamera((image) {
                        _filePickupBloc!.add(image);
                        isPicked = true;
                      });
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget zoneField(BuildContext context) {
    final FocusNode inputNode = FocusNode();
    return Container(
      child: TextFormField(
        focusNode: inputNode,
        controller: receiverAddress,
        // minLines: 1, //Normal textInputField will be displayed
        readOnly: true,
        onTap: () {},
        // Get.to(() => AddressFormPage(
        //     addressDertailType: AddressDertailType.receiver,
        //     transportType: widget.transportType)),
        maxLines: 1,
        textAlign: TextAlign.start,
        decoration: InputDecoration(
            border: InputBorder.none,
            // border: OutlineInputBorder(
            //     borderSide: BorderSide(width: 1, color: Colors.grey),
            //     borderRadius: BorderRadius.circular(8.0)),
            isDense: true,
            fillColor: Colors.grey[100],
            alignLabelWithHint: true,
            hintText: "Select Zone"),
        validator: (v) {
          if (v!.isEmpty) {
            return "Required";
            // AppLocalizations.of(context)!.translate("required");
          } else {
            return null;
          }
        },
      ),
    );
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
  //               return ListView.builder(
  //                   shrinkWrap: true,
  //                   itemCount: _zoneController.zoneList.length,
  //                   controller: _zoneController.scrollController,
  //                   itemBuilder: (context, index) {
  //                     return ListTile(
  //                       onTap: () {
  //                         // DeliveryLocalPageState.provinceCtr.text =
  //                         //     _branchAddressController
  //                         //         .branchAddressList[index].proNameKH!;
  //                         // proId = _branchAddressController
  //                         //     .branchAddressList[index].proId!;
  //                         receiverLat.text =
  //                             _zoneController.zoneList[index].lat;
  //                         receiverLong.text =
  //                             _zoneController.zoneList[index].long;
  //                         zoneCtr.text = _zoneController.zoneList[index].name;
  //                         feeCtr.text = _zoneController.zoneList[index].fee;
  //                         // 'Book Now  Total : ${_zoneController.zoneList[index].fee} \$';
  //                         Navigator.pop(context);
  //                       },
  //                       title: Text(
  //                         _zoneController.zoneList[index].name.toString(),
  //                         style: TextStyle(color: Colors.black),
  //                       ),
  //                       subtitle:
  //                           Text(_zoneController.zoneList[index].fee + "\$"),
  //                     );
  //                   });
  //             }
  //           }));
  //     }
  //   });
  // }

  @override
  void dispose() {
    _filePickupBloc!.close();
    clearTextInput();
    super.dispose();
  }
}
