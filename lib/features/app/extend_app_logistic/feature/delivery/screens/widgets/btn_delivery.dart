// import 'package:fardinexpress/features/app/extend_app_logistic/utils/constants/app_constant.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class BtnDelivery extends StatelessWidget {
//   BtnDelivery({required this.deliveryId});
//   final String deliveryId;

//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//         style: ElevatedButton.styleFrom(
//             elevation: 0,
//             padding: EdgeInsets.all(15),
//             shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(standardBorderRadius)),
//             primary: Colors.green[700]),
//         onPressed: () {
//           dialogDeliveryAddress(context);
//         },
//         child: Text(
//           "បញ្ជាដឹកមកដល់ទីកន្លែង",
//           style: TextStyle(color: Colors.white),
//         ));
//   }

//   dialogDeliveryAddress(BuildContext context) async {
//     final _formKey = GlobalKey<FormState>();
//     TextEditingController _textFieldController = TextEditingController();
//     return showDialog(
//         context: context,
//         builder: (contextt) {
//           return BlocBuilder<AccountBloc, AccountState>(
//             builder: (c, state) {
//               if (state is ErrorFetchingAccount) {
//                 return Center(
//                   child: TextButton(
//                     onPressed: () {
//                       BlocProvider.of<AccountBloc>(context)
//                           .add(FetchAccountStarted());
//                     },
//                     child: Text("Retry"),
//                   ),
//                 );
//               } else if (state is FetchedAccount) {
//                 _textFieldController.text = state.user.address;
//                 return AlertDialog(
//                   title:
//                       Text(AppLocalizations.of(context)!.translate("address")!),
//                   content: TextFormField(
//                     validator: (v) {
//                       // if (v!.isEmpty) {
//                       //   return "Please input address.";
//                       // } else {
//                       //   return null;
//                       // }
//                     },
//                     key: _formKey,
//                     maxLines: null,
//                     controller: _textFieldController,
//                     textInputAction: TextInputAction.go,
//                     keyboardType: TextInputType.text,
//                     decoration: InputDecoration(
//                         hintText: AppLocalizations.of(context)!
//                             .translate("enterAddress")!),
//                   ),
//                   actions: <Widget>[
//                     new TextButton(
//                       child: new Text(
//                           AppLocalizations.of(context)!.translate("submit")!),
//                       onPressed: () {
//                         if (_textFieldController.text.isNotEmpty) {
//                           BlocProvider.of<DeliveryBloc>(context).add(
//                               RequestDelivery(
//                                   deliveryId: deliveryId,
//                                   address: _textFieldController.text));
//                         }
//                         Navigator.of(context).pop();
//                       },
//                     )
//                   ],
//                 );
//               } else {
//                 return Center(
//                   child: CircularProgressIndicator(),
//                 );
//               }
//             },
//           );
//         });
//   }
// }
