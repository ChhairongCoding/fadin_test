// import 'package:fardinexpress/features/express/view/delivery_local.dart';
// import 'package:fardinexpress/features/express/view/widget/sender_detail_form.dart';
// import 'package:flutter/material.dart';

// Widget addressDetailField(BuildContext context) {
//   final FocusNode inputNode = FocusNode();
//   return Container(
//     child: TextField(
//       focusNode: inputNode,
//       controller: (widget.addressDertailType == AddressDertailType.sender)
//           ? DeliveryLocalPageState.senderAddress
//           : DeliveryLocalPageState.receiverAddress,
//       keyboardType: TextInputType.multiline,
//       // minLines: 1, //Normal textInputField will be displayed
//       maxLines: 1, //
//       textAlign: TextAlign.start,
//       decoration: InputDecoration(
//           border: OutlineInputBorder(
//               borderSide: BorderSide(width: 1, color: Colors.grey),
//               borderRadius: BorderRadius.circular(8.0)),
//           isDense: true,
//           fillColor: Colors.grey[100],
//           alignLabelWithHint: true,
//           hintText: "Address Detail"),
//     ),
//   );
// }
