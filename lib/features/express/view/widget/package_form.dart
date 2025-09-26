import 'package:fardinexpress/features/express/controller/express_controller.dart';
import 'package:fardinexpress/features/express/view/delivery_local.dart';
import 'package:fardinexpress/utils/component/widget/dialog_message_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class PackageFormPage extends StatefulWidget {
  final String transportType;
  const PackageFormPage({Key? key, required this.transportType})
      : super(key: key);
  @override
  PackageFormPageState createState() => PackageFormPageState();
}

class PackageFormPageState extends State<PackageFormPage> {
  // List currency = ["USD", "KHR"];
  List paymentType = ["Bank", "COD"];
  late FocusNode _focusPackagePrice, _focusNode;
  TextEditingController _currencyType = TextEditingController();
  ExpressController _currencyController = Get.put(ExpressController());
  Future<bool?> onSelectCurrencies(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("Select Currency"),
              content: _currencyWidget(context));
        });
  }

  Future<bool?> onSelectPayment(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("Select Payment Type"),
              content: _paymentTypeWidget(context));
        });
  }

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusPackagePrice = FocusNode();
    DeliveryLocalPageState.paymentNote.text = paymentType[1];
    _currencyController.getCurrencies();
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
                  "packageDetail".tr,
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
              // GetBuilder<ExpressController>(
              //   builder: (controller) {

              //   },
              // ),
              Obx(() {
                if (_currencyController.isLoading.value == true &&
                    _currencyController.currencyList.isEmpty) {
                  return Center(child: CircularProgressIndicator());
                }
                if (_currencyController.isLoading.value == false &&
                    _currencyController.currencyList.isNotEmpty) {
                  if (DeliveryLocalPageState.currencySymbolCtr.text.isEmpty &&
                      DeliveryLocalPageState.currencyIdCtr.text.isEmpty) {
                    _currencyType.text =
                        _currencyController.currencyList[0].code.toString();
                    DeliveryLocalPageState.currencyIdCtr.text =
                        _currencyController.currencyList[0].id.toString();
                    DeliveryLocalPageState.currencySymbolCtr.text =
                        _currencyController.currencyList[0].symbol.toString();
                  } else {
                    _currencyType.text =
                        DeliveryLocalPageState.currencyTypeCtr.text;
                  }

                  return Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: AspectRatio(
                          aspectRatio: 9 / 1.6,
                          child: Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Container(
                                  padding: EdgeInsets.only(
                                      top: 14.0, bottom: 14.0, left: 10.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(8.0),
                                      bottomLeft: Radius.circular(8.0),
                                    ),
                                    color: Colors.grey[200],
                                    // borderRadius: BorderRadius.circular(8.0)
                                  ),
                                  child: Text(
                                    "currency".tr + " :",
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(flex: 7, child: _currencyList(context)),
                            ],
                          )));
                } else {
                  return Container();
                }
              }),
              SizedBox(
                height: 10,
              ),
              Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: AspectRatio(
                      aspectRatio: 9 / 1.6, child: _packagePrice(context))),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "notePackagePrice".tr,
                  maxLines: 2,
                  style: TextStyle(color: Colors.orange[800], fontSize: 12),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              widget.transportType == "province" ||
                      widget.transportType == "cargo"
                  ? Container()
                  : Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: AspectRatio(
                          aspectRatio: 9 / 1.6, child: _paymentNote(context))),
              SizedBox(
                height: 10,
              ),
              Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: AspectRatio(
                      aspectRatio: 9 / 1.6, child: _packageNote(context))),
            ],
          ),
        ),
      ),
    );
  }

  Widget _currencyList(BuildContext context) {
    final FocusNode inputNode = FocusNode();
    return Container(
      child: TextFormField(
        focusNode: inputNode,
        readOnly: true,
        onTap: () => onSelectCurrencies(context),
        controller: _currencyType,
        keyboardType: TextInputType.multiline,
        // minLines: 1, //Normal textInputField will be displayed
        maxLines: 1, //
        textAlign: TextAlign.start,
        decoration: InputDecoration(
          // prefixText: "${'currency'.tr}: ",
          // label: Text("currency".tr),
          suffixIcon: Icon(
            Icons.arrow_drop_down,
            color: Colors.grey,
          ),
          border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(8.0),
                bottomRight: Radius.circular(8.0),
              )),
          isDense: true,
          filled: true,
          fillColor: Colors.grey[200],
          alignLabelWithHint: true,
          hintText: "USD",
        ),
      ),
    );
  }

  Widget _paymentNote(BuildContext context) {
    final FocusNode inputNode = FocusNode();
    return Container(
      child: TextFormField(
        // key: DeliveryLocalPageState.formKey,
        focusNode: inputNode,
        onTap: () => onSelectPayment(context),
        readOnly: true,
        controller: DeliveryLocalPageState.paymentNote,
        keyboardType: TextInputType.multiline,
        // minLines: 1, //Normal textInputField will be displayed
        maxLines: 1, //
        textAlign: TextAlign.start,
        decoration: InputDecoration(
            prefix: Text(
              "${'paymentNote'.tr}: ",
            ),
            suffixIcon: Icon(
              Icons.arrow_drop_down,
              color: Colors.grey,
            ),
            border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(8.0)),
            isDense: true,
            filled: true,
            fillColor: Colors.grey[200],
            alignLabelWithHint: true,
            hintText: "COD"),
      ),
    );
  }

  Widget _packagePrice(BuildContext context) {
    final NumberFormat _numberFormat = NumberFormat("###0.00");
    // final FocusNode inputNode = FocusNode();
    return Container(
      child: TextField(
        // key: DeliveryLocalPageState.formKey,
        focusNode: _focusPackagePrice,
        controller: DeliveryLocalPageState.total,
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        // minLines: 1, //Normal textInputField will be displayed
        maxLines: 1, //
        textAlign: TextAlign.start,
        decoration: InputDecoration(
            prefix: Text(
              "${'packagePrice'.tr}: ",
            ),
            floatingLabelStyle: TextStyle(
              color: Colors.transparent,
            ),
            border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(8.0)),
            isDense: true,
            filled: true,
            fillColor: Colors.grey[200],
            alignLabelWithHint: true,
            labelStyle: TextStyle(color: Colors.grey[600]),
            labelText: "packagePrice".tr),

        // onChanged: (value) {
        //    if (value.isNotEmpty) {
        //   try {
        //     double parsedValue = double.parse(value);
        //     total.value = TextEditingValue(
        //       text: NumberFormat("###.00").format(parsedValue),
        //       selection: TextSelection.collapsed(offset: value.length),
        //     );
        //   } catch (e) {
        //     // Handle parse errors if any
        //   }
        // }
        // },
      ),
    );
  }

  Widget _dimensions(BuildContext context) {
    final FocusNode inputNode = FocusNode();
    return Container(
      child: TextField(
        focusNode: inputNode,
        // controller: AddressFormPageState.addressDetailTextController,
        keyboardType: TextInputType.multiline,
        // minLines: 1, //Normal textInputField will be displayed
        maxLines: 1, //
        textAlign: TextAlign.start,
        decoration: InputDecoration(
            border: OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: Colors.grey),
                borderRadius: BorderRadius.circular(8.0)),
            isDense: true,
            fillColor: Colors.grey[100],
            alignLabelWithHint: true,
            hintText: "Dimensions"),
      ),
    );
  }

  Widget _packageNote(BuildContext context) {
    // final FocusNode inputNode = FocusNode();
    return Container(
      child: TextField(
        focusNode: _focusNode,
        controller: DeliveryLocalPageState.note,
        keyboardType: TextInputType.multiline,
        // minLines: 1, //Normal textInputField will be displayed
        maxLines: 1, //
        textAlign: TextAlign.start,
        decoration: InputDecoration(
            prefix: Text(
              "note".tr + ": ",
            ),
            border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(8.0)),
            isDense: true,
            filled: true,
            fillColor: Colors.grey[200],
            floatingLabelStyle: TextStyle(
              color: Colors.transparent,
            ),
            // alignLabelWithHint: false,
            // floatingLabelAlignment: FloatingLabelAlignment.,
            labelStyle: TextStyle(color: Colors.grey[600]),
            labelText: "note".tr),
      ),
    );
  }

  Widget _currencyWidget(BuildContext context) {
    return Obx(() {
      if (_currencyController.isLoading.value) {
        return Center(
          child: CircularProgressIndicator(),
        );
      } else if (_currencyController.currencyList.isEmpty) {
        return Center(
          child: Text("No currency found"),
        );
      } else {
        return Container(
            width: 300,
            height: 300,
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: _currencyController.currencyList.length,
                itemBuilder: (context, index) {
                  var currency = _currencyController.currencyList;
                  return ListTile(
                      onTap: () {
                        _currencyType.text = currency[index].code;
                        DeliveryLocalPageState.currencyIdCtr.text =
                            currency[index].id.toString();
                        DeliveryLocalPageState.currencySymbolCtr.text =
                            currency[index].symbol.toString();
                        Navigator.pop(context);
                      },
                      title: Text(
                        currency[index].name.toString(),
                        // BlocProvider.of<CurrenciesBloc>(context)
                        //     .currenciesList[index]
                        //     .name
                        //     .toString(),
                        style: TextStyle(color: Colors.black),
                      ),
                      subtitle: Text(
                        (currency[index].rate.split('.')[0] +
                            "." +
                            currency[index].rate.split('.')[1].substring(0, 2)),
                      ));
                }));
      }
    });
  }

  Widget _paymentTypeWidget(BuildContext context) {
    return Container(
        width: 300,
        height: 300,
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: paymentType.length,
            itemBuilder: (context, index) {
              return ListTile(
                onTap: () {
                  DeliveryLocalPageState.paymentNote.text = paymentType[index];
                  Navigator.pop(context);
                },
                title: Text(
                  paymentType[index],
                  // BlocProvider.of<CurrenciesBloc>(context)
                  //     .currenciesList[index]
                  //     .name
                  //     .toString(),
                  style: TextStyle(color: Colors.black),
                ),
                // subtitle:
                //     Text((currency[index].toString() == "USD") ? "1" : "4000"),
              );
            }));
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
                onPressed: () {
                  if (DeliveryLocalPageState.total.text == "") {
                    DialogMessageWidget.show(
                      context: context,
                      title: "alert".tr,
                      message: "Please input package price.",
                      success: 2,
                      // onOk: () {},
                    );
                  } else {
                    DeliveryLocalPageState.packagePriceCtr.text =
                        DeliveryLocalPageState.currencySymbolCtr.text +
                            " " +
                            DeliveryLocalPageState.total.text +
                            ",00";
                    DeliveryLocalPageState.currencyTypeCtr.text =
                        _currencyType.text;
                    Navigator.pop(context);
                    // Get.back(result: true);
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
    _focusNode.dispose();
    _focusPackagePrice.dispose();
    _currencyController.currencyList.clear();
    super.dispose();
  }
}
