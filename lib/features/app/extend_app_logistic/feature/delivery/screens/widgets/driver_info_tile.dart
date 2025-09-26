// import 'package:chs/src/appLocalizations.dart';
// import 'package:chs/src/features/delivery/models/driver.dart';
// import 'package:flutter/material.dart';
// import 'package:chs/src/utils/constants/app_constant.dart';

// class DriverInfoTile extends StatelessWidget {
//   final Driver driver;
//   DriverInfoTile({required this.driver});
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       padding: EdgeInsets.all(15),
//       decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(standardBorderRadius)),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   AppLocalizations.of(context)!.translate("driver")!,
//                   style:
//                       Theme.of(context).primaryTextTheme.subtitle1!.copyWith(),
//                 ),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 Text(
//                   "${driver.name} | ${driver.phone}",
//                   style:
//                       Theme.of(context).primaryTextTheme.bodyText1!.copyWith(),
//                 ),
//               ],
//             ),
//           ),
//           // IconButton(
//           //   icon: Icon(
//           //     Icons.call,
//           //     color: Theme.of(context).primaryColor,
//           //   ),
//           //   onPressed: () {},
//           // )
//         ],
//       ),
//     );
//   }
// }
