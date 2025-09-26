import 'package:fardinexpress/features/payment/controller/paymet_control_index_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentOption extends StatelessWidget {
  PaymentOption({Key? key}) : super(key: key);
  // static TextEditingController paymentImage = TextEditingController();
  // static TextEditingController paymentName = TextEditingController();
  final _controller = Get.find<PaymentControlIndexController>();
  List<Map> paymentMethods = [
    {
      "name": "cashOnDelivery".tr,
      "image": "assets/img/payment/cash-on-delivery.png",
      "description": "Pay with driver"
    },
    {
      "name": "KHQR",
      "image": "assets/img/payment/khqr.png",
      "description": "Scan to pay with banking app"
    },
    {
      "name": "moneyTransfer".tr,
      "image": "assets/img/payment/phone_transfer.jpg",
      "description": "transferNumber".tr
    },
    {
      "name": "Anakut Cash",
      "image": "assets/img/payment/anakut-cash.png",
      "description": "Get 10% off with Anakut Cash"
    }
  ];

  @override
  Widget build(BuildContext context) {
    // paymentImage.text = "assets/img/payment/aba-logo.png";
    // paymentName.text = "ABA Bank";
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          // color: Theme.of(context).buttonColor,
          borderRadius: BorderRadius.all(Radius.circular(8.0))),
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "paymentOption".tr,
                  style: TextStyle(fontWeight: FontWeight.w500),
                  textScaleFactor: 1.2,
                ),
                SizedBox(
                  height: 10.0,
                ),
                // GestureDetector(
                //   onTap: () => Get.to(() => PaymentOptionList()),
                //   child: Container(
                //     child: Row(
                //       children: [
                //         Expanded(
                //           flex: 7,
                //           child: GetBuilder<PaymentControlIndexController>(
                //               init: PaymentControlIndexController(),
                //               builder: (_controller) {
                //                 if (_controller.isClick.value) {
                //                   return Container();
                //                 } else {
                //                   return Row(
                //                     children: [
                //                       Image.asset(
                //                         paymentImage.text,
                //                         width: 50.0,
                //                       ),
                //                       Text(
                //                         "  ${paymentName.text}",
                //                         // _controller.isClick.toString(),
                //                         style: TextStyle(
                //                             color: Colors.grey[700],
                //                             fontWeight: FontWeight.bold),
                //                       )
                //                     ],
                //                   );
                //                 }
                //               }),
                //         ),
                //         Expanded(
                //             flex: 3,
                //             child: IconButton(
                //                 onPressed: () {
                //                   Get.to(() => PaymentOptionList());
                //                 },
                //                 icon: Icon(Icons.edit)))
                //       ],
                //     ),
                //   ),
                // ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: paymentMethods.length,
                  itemBuilder: (context, index) {
                    return Obx(() => ListTile(
                          contentPadding: EdgeInsets.all(0),
                          onTap:
                              (() => // Update the selected payment method when tapped
                                  _controller.selectMethod(index)),
                          leading: Image.asset(
                            "${paymentMethods[index]["image"]}",
                            width: 50.0,
                          ),
                          title: Text(
                            "${paymentMethods[index]["name"]}",
                            // _controller.isClick.toString(),
                            style: TextStyle(
                                // color: Colors.grey[700],
                                // fontWeight: FontWeight.bold
                                ),
                          ),
                          subtitle: index == 3
                              ? Container(
                                  padding: EdgeInsets.all(4.0),
                                  decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(8.0)),
                                  child: Text(
                                    "${paymentMethods[index]["description"]}",
                                    style: TextStyle(
                                      color: Colors.white,
                                      // fontWeight: FontWeight.bold
                                    ),
                                  ),
                                )
                              : Text(
                                  "${paymentMethods[index]["description"]}",
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    // fontWeight: FontWeight.bold
                                  ),
                                ),
                          trailing: Icon(
                            _controller.selectedMethod.value == index
                                ? Icons.radio_button_checked
                                : Icons.radio_button_unchecked,
                            color: _controller.selectedMethod.value == index
                                ? Theme.of(context).primaryColor
                                : Colors.grey,
                          ),
                        ));
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
