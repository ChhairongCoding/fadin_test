// import 'package:fardinexpress/features/checkout/view/widget/payment_option_list.dart';
// import 'package:fardinexpress/features/payment/controller/paymet_control_index_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class BankTransferScreen extends StatelessWidget {
//   BankTransferScreen({Key? key}) : super(key: key);
//   final _controller = Get.find<PaymentControlIndexController>();
//   static TextEditingController paymentImage = TextEditingController();
//   static TextEditingController paymentName = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     paymentImage.text = "assets/img/payment/aba-logo.png";
//     paymentName.text = "ABA Bank";
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Bank Transfer"),
//       ),
//       body: GestureDetector(
//         onTap: () => Get.to(() => PaymentOptionList(
//           cartStoreModel: ,
//         )),
//         child: Container(
//           child: Row(
//             children: [
//               Expanded(
//                 flex: 7,
//                 child: GetBuilder<PaymentControlIndexController>(
//                     init: PaymentControlIndexController(),
//                     builder: (_controller) {
//                       if (_controller.isClick.value) {
//                         return Container();
//                       } else {
//                         return Row(
//                           children: [
//                             Image.asset(
//                               paymentImage.text,
//                               width: 50.0,
//                             ),
//                             Text(
//                               "  ${paymentName.text}",
//                               // _controller.isClick.toString(),
//                               style: TextStyle(
//                                   color: Colors.grey[700],
//                                   fontWeight: FontWeight.bold),
//                             )
//                           ],
//                         );
//                       }
//                     }),
//               ),
//               Expanded(
//                   flex: 3,
//                   child: IconButton(
//                       onPressed: () {
//                         Get.to(() => PaymentOptionList());
//                       },
//                       icon: Icon(Icons.edit)))
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
