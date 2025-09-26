import 'package:fardinexpress/features/account/controller/account_controller.dart';
import 'package:fardinexpress/features/address/view/address_list.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/feature/price_estimation/screens/price_estimation_page.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/feature/price_estimation/screens/widgets/checkout_country.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/feature/price_estimation/screens/widgets/delivery_mode.dart';
import 'package:fardinexpress/features/cart/model/cart_store_model.dart';
import 'package:fardinexpress/features/checkout/controller/checkout_controller.dart';
import 'package:fardinexpress/features/checkout/view/widget/checkout_item_list.dart';
import 'package:fardinexpress/features/checkout/view/widget/order_summary.dart';
import 'package:fardinexpress/features/checkout/view/widget/payment_option.dart';
import 'package:fardinexpress/features/checkout/view/widget/payment_option_list.dart';
import 'package:fardinexpress/features/checkout/view/widget/shipping_address.dart';
import 'package:fardinexpress/features/payment/controller/paymet_control_index_controller.dart';
import 'package:fardinexpress/features/product/model/product_res_model.dart';
import 'package:fardinexpress/utils/bloc/indexing/indexing_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class CheckoutPage extends StatefulWidget {
  final List<CartStoreItem> cartStoreModel;
  final List<ProductModelRes> productList;
  final String total;
  final String countryId;
  const CheckoutPage(
      {Key? key,
      required this.cartStoreModel,
      required this.productList,
      required this.total,
      required this.countryId})
      : super(key: key);

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  // we have initialized active step to 0 so that
// our stepper widget will start from first step
  IndexingBloc modeIndexBloc = IndexingBloc();
  IndexingBloc countryIndexBloc = IndexingBloc();
  int _activeCurrentStep = 0;
  String selectedTransport = '';
  String selectedWarehouse = '';

  List<Map<String, dynamic>> transports = [
    {"transportType": "Land Transportation (7-10 days)", "price": "1.00\$"},
    {"transportType": "Sea Transportation (3-5 days)", "price": "3.00\$"},
    {"transportType": "Air Transportation (1-3 days)", "price": "5.00\$"}
  ];

  List<Map<String, dynamic>> pickWarehouses = [
    {"warehouse": "Fardin warehouse"},
    {"warehouse": "Directly to Home"},
  ];

  TextEditingController name = TextEditingController();
  CheckoutController _checkoutController = Get.put(CheckoutController());
  AccountController _controller = Get.find<AccountController>();
  final _paymentController = Get.put(PaymentControlIndexController());
  // final AddressController _addressController = Get.put(AddressController());

  initState() {
    super.initState();
    DeliveryModeState.countryId.text = widget.countryId;
    selectedWarehouse = pickWarehouses[0]["warehouse"];
  }

// Here we have created list of steps
// that are required to complete the form
  List<Step> stepList() => [
        // This is step1 which is called Account.
        // Here we will fill our personal details
        Step(
          state:
              _activeCurrentStep <= 0 ? StepState.editing : StepState.complete,
          isActive: _activeCurrentStep >= 0,
          title: Text('information'.tr),
          content: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Overseas purchase",
                  textScaleFactor: 1.2,
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 10,
                ),
                CheckoutItemList(
                  cartStoreModel: widget.cartStoreModel,
                  productList: widget.productList,
                ),
                _buildBottom(widget.cartStoreModel, context)
              ],
            ),
          ),
        ),
        // This is Step2 here we will enter our address
        Step(
            state: _activeCurrentStep <= 1
                ? StepState.editing
                : StepState.complete,
            isActive: _activeCurrentStep >= 1,
            title: Text('shipping'.tr),
            content: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        border:
                            Border.all(width: 1.0, color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(8.0)),
                    child: Column(
                      children: [
                        // ListTile(
                        //   title: Text("thearaz@gmail.com"),
                        //   trailing: IconButton(
                        //       onPressed: () {},
                        //       icon: Icon(
                        //         Icons.edit,
                        //         color: Theme.of(context).primaryColor,
                        //       )),
                        // ),
                        // Padding(
                        //   padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        //   child: Divider(),
                        // ),
                        // ListTile(
                        //   leading: Text("Ship to"),
                        //   title: Text("Phnom Penh, Sangkat Veal Vong"),
                        //   trailing: IconButton(
                        //       onPressed: () {},
                        //       icon: Icon(
                        //         Icons.edit,
                        //         color: Theme.of(context).primaryColor,
                        //       )),
                        // ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    "shipMethod".tr,
                    textScaleFactor: 1.2,
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  BlocProvider(
                    create: (BuildContext context) => countryIndexBloc,
                    child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 0),
                        child: CheckOutCountry(
                          transport_id: widget.countryId,
                        )),
                  ),
                  SizedBox(height: 15),
                  BlocProvider(
                    create: (BuildContext context) => modeIndexBloc,
                    child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 0),
                        child: DeliveryMode()),
                  ),
                  // Container(
                  //   padding: EdgeInsets.all(8.0),
                  //   decoration: BoxDecoration(
                  //     border: Border.all(width: 1.0, color: Colors.grey[300]!),
                  //     borderRadius: BorderRadius.circular(8.0),
                  //   ),
                  //   child: DropdownButton<String>(
                  //     underline: Container(),
                  //     isExpanded:
                  //         true, // Ensures the dropdown takes up the full width
                  //     hint: Text("Select Transportation"),
                  //     value: selectedTransport == ''
                  //         ? '${transports[0]["transportType"]}'
                  //         : selectedTransport,
                  //     onChanged: (String? newValue) {
                  //       setState(() {
                  //         selectedTransport = newValue!;
                  //       });
                  //     },
                  //     items: transports.map<DropdownMenuItem<String>>(
                  //       (Map<String, dynamic> transport) {
                  //         return DropdownMenuItem<String>(
                  //           value: transport["transportType"],
                  //           child: Row(
                  //             children: [
                  //               Expanded(
                  //                 child: Text(
                  //                   "${transport["transportType"]} - ${transport["price"]}",
                  //                   // overflow: TextOverflow
                  //                   //     .ellipsis, // Adds ellipsis for long text
                  //                   softWrap: true, // Prevents line wrapping
                  //                 ),
                  //               ),
                  //             ],
                  //           ),
                  //         );
                  //       },
                  //     ).toList(),
                  //   ),
                  // ),
                  SizedBox(
                    height: 15,
                  ),
                  // Text(
                  //   "pick up warehouse".tr,
                  //   textScaleFactor: 1.2,
                  //   style: TextStyle(fontWeight: FontWeight.w500),
                  // ),
                  Text(
                    "shipAddress".tr,
                    textScaleFactor: 1.2,
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      border: Border.all(width: 1.0, color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: DropdownButton<String>(
                      underline: Container(),
                      isExpanded:
                          true, // Ensures the dropdown takes up the full width
                      hint: Text("Select Warehouse"),
                      value: selectedWarehouse == ''
                          ? pickWarehouses[0]["warehouse"]
                          : selectedWarehouse,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedWarehouse = newValue!;
                        });
                      },
                      items: pickWarehouses.map<DropdownMenuItem<String>>(
                        (Map<String, dynamic> warehouse) {
                          return DropdownMenuItem<String>(
                            value: warehouse["warehouse"],
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "${warehouse["warehouse"]}",
                                    // overflow: TextOverflow
                                    //     .ellipsis, // Adds ellipsis for long text
                                    softWrap: true, // Prevents line wrapping
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ).toList(),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Obx(() {
                    if (_controller.isLoading.value) {
                      return Center(child: CircularProgressIndicator());
                    } else {
                      // Conditionally return widget based on selectedWarehouse
                      if (selectedWarehouse == "Fardin warehouse") {
                        return Container(
                            // padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ListTile(
                              leading: Icon(
                                Icons.pin_drop_outlined,
                                color: Colors.red,
                              ),
                              title: Text(
                                "Fardin warehouse",
                                style: TextStyle(
                                  // color: Colors.blue,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              subtitle: Text("HW6F+448 Phnom Penh, Cambodia",
                                  style: TextStyle(
                                    color: Colors.black54,
                                  )),
                            ));
                      } else if (selectedWarehouse == "Directly to Home") {
                        return shippingAddress(
                          _controller.accountInfo.name,
                          _controller.accountInfo.phone,
                          _controller.addressName.value,
                          () => Get.to(() => AddressList(isCheckout: true)),
                        );
                      } else {
                        return SizedBox(); // Or any placeholder
                      }
                    }
                  }),
                  // Obx(() {
                  //   if (_controller.isLoading.value) {
                  //     return Center(child: CircularProgressIndicator());
                  //   } else {
                  //     return shippingAddress(
                  //         _controller.accountInfo.name,
                  //         _controller.accountInfo.phone,
                  //         _controller.addressName.value,
                  //         () => Get.to(() => AddressList(
                  //               isCheckout: true,
                  //             )));
                  //   }
                  // }),
                  SizedBox(
                    height: 15,
                  ),
                ],
              ),
            )),

        // This is Step3 here we will display all the details
        // that are entered by the user
        Step(
            state: StepState.complete,
            isActive: _activeCurrentStep >= 2,
            title: Text('payment'.tr),
            content: Column(
              children: [
                // Obx(() => Text(
                //     "obs test" + _paymentController.selectedMethod.toString())),
                PaymentOption(),
                SizedBox(
                  height: 10.0,
                ),
                OrderSummary(
                  cartStoreModel: widget.cartStoreModel,
                  total: widget.total,
                )
              ],
            ))
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("checkout".tr),
        centerTitle: true,
      ),
      body: Stepper(
        type: StepperType.horizontal,
        currentStep: _activeCurrentStep,
        steps: stepList(),

        // onStepContinue takes us to the next step
        onStepContinue: () {
          if (_activeCurrentStep < (stepList().length - 1)) {
            setState(() {
              _activeCurrentStep += 1;
            });
          } else {
            if (_paymentController.selectedMethod == 2) {
              Get.to(() => PaymentOptionList(
                    cartStoreModel: widget.cartStoreModel,
                    products: widget.productList,
                    grandTotal: widget.total,
                    type: "${widget.cartStoreModel[0].type}",
                    addressId: _controller.addressId.value,
                    countryId: DeliveryModeState.countryId.text,
                    deliveryMode: PriceEstimationPageState.modeCtl.text,
                  ));
            }
            if (_paymentController.selectedMethod == 1) {
              _checkoutController.generateKhqrCode(
                  "KHQR",
                  widget.total,
                  "${widget.cartStoreModel[0].type}",
                  context,
                  widget.cartStoreModel,
                  widget.productList,
                  _controller.addressId.value,
                  "KHQR",
                  DeliveryModeState.countryId.text,
                  PriceEstimationPageState.modeCtl.text);
              // showABAQRCodeDialog(context);
            }
            if (_paymentController.selectedMethod == 0) {
              // print(
              //     "Country Id: ${DeliveryModeState.countryId.text} Mode Id: ${DeliveryModeState.tranModeId.text} Temp Mode Id: ${DeliveryModeState.tempTranModeId.text}");
              _checkoutController.toCheckout(
                  widget.cartStoreModel,
                  "${widget.cartStoreModel[0].type}",
                  widget.total,
                  widget.productList,
                  selectedWarehouse == "Fardin warehouse"
                      ? ""
                      : _controller.addressId.value,
                  "cash",
                  "",
                  DeliveryModeState.countryId.text,
                  DeliveryModeState.tranModeId.text.isEmpty
                      ? DeliveryModeState.tempTranModeId.text
                      : DeliveryModeState.tranModeId.text,
                  null);
            } else {
              if (_paymentController.selectedMethod == 3) {
                _checkoutController.generateKhqrCode(
                    "anakut",
                    widget.total,
                    "${widget.cartStoreModel[0].type}",
                    context,
                    widget.cartStoreModel,
                    widget.productList,
                    _controller.addressId.value,
                    "anakut",
                    DeliveryModeState.countryId.text,
                    PriceEstimationPageState.modeCtl.text);
              }
            }
          }
        },

        // onStepCancel takes us to the previous step
        onStepCancel: () {
          if (_activeCurrentStep == 0) {
            return;
          }

          setState(() {
            _activeCurrentStep -= 1;
          });
        },

        // onStepTap allows to directly click on the particular step we want
        onStepTapped: (int index) {
          setState(() {
            _activeCurrentStep = index;
          });
        },
        controlsBuilder: (BuildContext context, ControlsDetails details) {
          final isLastStep = _activeCurrentStep == stepList().length - 1;

          return Row(
            children: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  elevation: 0,
                  // padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                  backgroundColor: Colors.green,
                ),
                onPressed: details.onStepContinue,
                child: Text(isLastStep ? 'Checkout' : 'Continue',
                    style: TextStyle(color: Colors.white)),
              ),
              SizedBox(width: 8),
              if (_activeCurrentStep > 0)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0),
                      side: BorderSide(color: Colors.green),
                    ),
                    elevation: 0,
                    // padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                    // backgroundColor: Colors.green,
                  ),
                  onPressed: details.onStepCancel,
                  child: const Text('Back'),
                ),
            ],
          );
        },
      ),
    );
  }

  // void showABAQRCodeDialog(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         // backgroundColor: const Color.fromARGB(255, 35, 35, 56),
  //         backgroundColor: Colors.transparent,
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(20),
  //         ),
  //         contentPadding: EdgeInsets.zero,
  //         content: Container(
  //           width: 300,
  //           decoration: BoxDecoration(
  //             // color: const Color.fromARGB(255, 32, 46, 57),
  //             // color: Colors.black.withOpacity(0.1),
  //             borderRadius: BorderRadius.circular(20),
  //           ),
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             crossAxisAlignment:
  //                 CrossAxisAlignment.start, // Aligns text to left
  //             children: [
  //               // QR Code (Centered)
  //               Align(
  //                 alignment: Alignment.center,
  //                 child: Padding(
  //                   padding: const EdgeInsets.all(12),
  //                   child: Image.network(
  //                     "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTp1DINLlM6OFpZfYYANx-O9J42rhCWnQIt4A&s", // Dynamic QR Code URL
  //                     width: double.infinity,
  //                     // height: 200,
  //                     fit: BoxFit.contain,
  //                   ),
  //                 ),
  //               ),

  //               // Close Button (Centered)
  //               Align(
  //                 alignment: Alignment.center,
  //                 child: TextButton(
  //                   onPressed: () => Navigator.pop(context),
  //                   child: const Text('Close',
  //                       style: TextStyle(color: Colors.white)),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  Widget _buildBottom(List<CartStoreItem> cartStoreModel, var _) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(
        left: 16.0,
        right: 16,
        bottom: 8.0,
        top: 4.0,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "subTotal".tr,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    // "0.00",
                    "\$ ${widget.total}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                  Text(
                    "Subtotal does not include shipping",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
