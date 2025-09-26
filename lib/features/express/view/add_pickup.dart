// import 'package:fardinexpress/features/express/view/delivery_country.dart';
// import 'package:fardinexpress/features/express/view/delivery_local.dart';
// import 'package:fardinexpress/utils/bloc/toggle_btn/index.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:get/get.dart';

// class AddPickupPage extends StatefulWidget {
//   const AddPickupPage({Key? key}) : super(key: key);

//   @override
//   State<AddPickupPage> createState() => _AddPickupPageState();
// }

// class _AddPickupPageState extends State<AddPickupPage> {
//   final _formKey = GlobalKey<FormState>();
//   // FilePickupBloc? _filePickupBloc;

//   static TextEditingController senderAddressCtr = TextEditingController();
//   static TextEditingController receiverAddressCtr = TextEditingController();
//   // final _receiverPhoneCtr = TextEditingController();
//   // final _noteCtr = TextEditingController();
//   // final _packagePriceCtr = TextEditingController();
//   // TextEditingController _senderAddressDetailCtr = TextEditingController();
//   // final _receiverAddressDetailCtr = TextEditingController();
//   bool paymentStatus = false;
//   double standardBorderRadius = 18;
//   // int _selectedValue = 1;

//   final _tapNav = <Tab>[
//     Tab(
//         child: Text('ដឹកក្នុងស្រុក',
//             style: TextStyle(
//               fontSize: 16.0,
//             ))),
//     Tab(
//         child: Text(
//       "ដឹកឆ្លងខេត្ត".tr,
//       style: TextStyle(
//         fontSize: 16.0,
//       ),
//     )),
//     Tab(
//         child: Text(
//       'ដឹកឆ្លងប្រទេស'.tr,
//       style: TextStyle(
//         fontSize: 16.0,
//       ),
//     )),
//   ];

//   @override
//   void initState() {
//     BlocProvider.of<ToggleBloc>(context)
//         .add(ClickedIndex(clicked: paymentStatus));
//     // _filePickupBloc = FilePickupBloc();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: _tapNav.length,
//       child: Scaffold(
//           // resizeToAvoidBottomInset: true,
//           appBar: _buildAppBar(context),
//           body: TabBarView(children: [
//             DeliveryLocalPage(),
//             DeliveryCountryPage(),
//             Center(
//               child: Text("data"),
//             )
//           ])
//           // floatingActionButton: _submitBtn(),
//           // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//           ),
//     );
//   }

//   _buildAppBar(BuildContext _) {
//     return AppBar(
//       title: Text("Add Pick Up"),
//       centerTitle: true,
//       bottom: TabBar(
//         isScrollable: true,
//         labelColor: Colors.grey[700],
//         tabs: _tapNav,
//         // indicatorColor: Colors.green,
//         indicator: BoxDecoration(
//             color: Colors.white,
//             border: Border.all(width: 1, color: Colors.green),
//             borderRadius: BorderRadius.circular(8.0)),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     receiverAddressCtr.clear();
//     senderAddressCtr.clear();
//     super.dispose();
//   }
// }
