import 'package:fardinexpress/features/app/extend_app_logistic/feature/home/screens/home_logistic_wrapper.dart';
import 'package:fardinexpress/features/auth/bloc/auth_bloc.dart';
import 'package:fardinexpress/features/auth/bloc/auth_state.dart';
import 'package:fardinexpress/features/auth/login/view/auth_page.dart';
import 'package:fardinexpress/features/taxi/controller/taxi_controller.dart';
import 'package:fardinexpress/features/taxi/view/taxi_wrapper_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class ExpressHomeMenu extends GetView<TaxiController> {
  const ExpressHomeMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
          // color: Colors.white,
          // gradient: RadialGradient(
          //   center: Alignment.topRight,
          //   radius: 10.0,
          //   colors: [
          //     Colors.green[400]!,
          //     Colors.green,
          //   ],
          // ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 2,
              offset: Offset(1, 0.5), // changes position of shadow
            ),
          ],
          // color: Colors.white,
          borderRadius: BorderRadius.circular(8.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text(
          //   "express".tr,
          //   textScaleFactor: 1.2,
          //   style:
          //       TextStyle(fontWeight: FontWeight.w600, color: Colors.grey[900]),
          // ),
          // SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  flex: 14,
                  child: GestureDetector(
                    onTap: () {
                      if (BlocProvider.of<AuthenticationBloc>(context).state
                          is Authenticated) {
                        Get.to(() => TaxiWrapperPage());
                        // if (controller.status.toLowerCase() == "pending" &&
                        //     Get.find<TaxiController>().taxiRiddingList.length !=
                        //         0) {
                        //   print("check status1: " +
                        //       controller.status.toLowerCase());
                        //   Get.to(() => TaxiWrapperPage());
                        // } else {
                        //   print("check status2: " +
                        //       controller.status.toLowerCase());
                        //   // Get.to(() => TaxiBookingPage());
                        //   Get.to(() => MapPickerScreen());
                        // }
                      } else {
                        Get.to(() => AuthPage(
                              isLogin: true,
                            ));
                      }
                      // Get.to(() => TrackingLocation());
                    },
                    child: Container(
                        padding: EdgeInsets.symmetric(vertical: 4.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          color: Colors.green[200],
                          // boxShadow: [
                          //   BoxShadow(
                          //     color: Colors.grey.withOpacity(0.2),
                          //     spreadRadius: 1,
                          //     blurRadius: 2,
                          //     offset:
                          //         Offset(0, 0.5), // changes position of shadow
                          //   ),
                          // ],
                          // gradient: LinearGradient(
                          //   begin: Alignment.topRight,
                          //   end: Alignment.bottomLeft,
                          //   colors: [
                          //     Color(0xffa8ff78),
                          //     Color(0xff78ffd6),
                          //   ],
                          // )
                        ),
                        child: Column(
                          // alignment: AlignmentDirectional.center,
                          children: [
                            Container(
                              color: Colors.green[200],
                              child: Image(
                                image: AssetImage(
                                    "assets/img/features/tuk-tuk.png"),
                                fit: BoxFit.cover,
                                // width: MediaQuery.of(context).size.width / 10,
                                height: 40.0,
                              ),
                            ),
                            SizedBox(height: 5.0),
                            Text(
                              "taxi".tr,
                              textScaleFactor: 1.0,
                              style: TextStyle(
                                color: Colors.grey[800],
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        )),
                  )),
              Expanded(flex: 1, child: SizedBox()),
              Expanded(
                  flex: 14,
                  child: GestureDetector(
                    onTap: () {
                      if (BlocProvider.of<AuthenticationBloc>(context).state
                          is Authenticated) {
                        Get.to(() => LogisticHomeWrapper()
                            // LogisticHomePage()
                            );
                      } else {
                        Get.to(() => AuthPage(
                              isLogin: true,
                            ));
                      }
                    },
                    child: Container(
                        padding: EdgeInsets.symmetric(vertical: 4.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          color: Colors.green[200],
                          boxShadow: [
                            // BoxShadow(
                            //   color: Colors.grey.withOpacity(0.2),
                            //   spreadRadius: 1,
                            //   blurRadius: 2,
                            //   offset:
                            //       Offset(0, 0.5), // changes position of shadow
                            // ),
                          ],
                          // gradient: LinearGradient(
                          //   begin: Alignment.topRight,
                          //   end: Alignment.bottomLeft,
                          //   colors: [
                          //     Color(0xffa8ff78),
                          //     Color(0xff78ffd6),
                          //   ],
                          // )
                        ),
                        child: Column(
                          // alignment: AlignmentDirectional.center,
                          children: [
                            Container(
                              // color: Colors.red,
                              child: Image(
                                image: AssetImage("assets/img/box.png"),
                                fit: BoxFit.cover,
                                // width: MediaQuery.of(context).size.width / 10,
                                height: 40.0,
                              ),
                            ),
                            SizedBox(height: 5.0),
                            Text(
                              "transportation".tr,
                              textScaleFactor: 1.0,
                              style: TextStyle(
                                color: Colors.grey[800],
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        )),
                  )),

              ///new service like grab
              // Expanded(
              //     flex: 14,
              //     child: GestureDetector(
              //       onTap: () {
              //         if (BlocProvider.of<AuthenticationBloc>(context).state
              //             is Authenticated) {
              //           if (controller.status.toLowerCase() == "pending" &&
              //               Get.find<TaxiController>().taxiHistoryList.length !=
              //                   0) {
              //             print("check status: " +
              //                 controller.status.toLowerCase());
              //             Get.to(() => TrackingLocation());
              //           } else {
              //             print("check status: " +
              //                 controller.status.toLowerCase());
              //             // Get.to(() => TaxiBookingPage());
              //             Get.to(() => MapPickerScreen());
              //           }
              //         } else {
              //           Get.to(() => AuthPage(
              //                 isLogin: true,
              //               ));
              //         }
              //         // Get.to(() => TrackingLocation());
              //       },
              //       child: Container(
              //           padding: EdgeInsets.symmetric(vertical: 4.0),
              //           decoration: BoxDecoration(
              //             borderRadius: BorderRadius.circular(8.0),
              //             // color: Colors.white,
              //             // Colors.green[200],
              //             // boxShadow: [
              //             //   BoxShadow(
              //             //     color: Colors.grey.withOpacity(0.2),
              //             //     spreadRadius: 1,
              //             //     blurRadius: 2,
              //             //     offset:
              //             //         Offset(0, 0.5), // changes position of shadow
              //             //   ),
              //             // ],
              //             // gradient: LinearGradient(
              //             //   begin: Alignment.topRight,
              //             //   end: Alignment.bottomLeft,
              //             //   colors: [
              //             //     Color(0xffa8ff78),
              //             //     Color(0xff78ffd6),
              //             //   ],
              //             // )
              //           ),
              //           child: Column(
              //             // alignment: AlignmentDirectional.center,
              //             children: [
              //               ClipOval(
              //                 // Colors.green[200],
              //                 child: Material(
              //                   color: Theme.of(context)
              //                       .primaryColor
              //                       .withAlpha(30),
              //                   child: Container(
              //                     margin: EdgeInsets.all(8.0),
              //                     child: Image(
              //                       image: AssetImage(
              //                           "assets/img/features/tuk-tuk.png"),
              //                       fit: BoxFit.cover,
              //                       // width: MediaQuery.of(context).size.width / 10,
              //                       height: 50.0,
              //                     ),
              //                   ),
              //                 ),
              //               ),
              //               SizedBox(
              //                 height: 8.0,
              //               ),
              //               Text(
              //                 "taxi".tr,
              //                 textScaleFactor: 1.0,
              //                 style: TextStyle(
              //                   color: Colors.grey[800],
              //                   fontWeight: FontWeight.w500,
              //                 ),
              //                 textAlign: TextAlign.center,
              //               ),
              //             ],
              //           )),
              //     )),
              // Expanded(flex: 1, child: SizedBox()),
              // Expanded(
              //     flex: 14,
              //     child: GestureDetector(
              //       onTap: () {
              //         if (BlocProvider.of<AuthenticationBloc>(context).state
              //             is Authenticated) {
              //           Get.to(() => LogisticHomePage());
              //         } else {
              //           Get.to(() => AuthPage(
              //                 isLogin: true,
              //               ));
              //         }
              //       },
              //       child: Container(
              //           padding: EdgeInsets.symmetric(vertical: 4.0),
              //           decoration: BoxDecoration(
              //             borderRadius: BorderRadius.circular(8.0),
              //             // color: Colors.white,
              //             // Colors.green[200],
              //             // boxShadow: [
              //             //   BoxShadow(
              //             //     color: Colors.grey.withOpacity(0.2),
              //             //     spreadRadius: 1,
              //             //     blurRadius: 2,
              //             //     offset:
              //             //         Offset(0, 0.5), // changes position of shadow
              //             //   ),
              //             // ],
              //             // gradient: LinearGradient(
              //             //   begin: Alignment.topRight,
              //             //   end: Alignment.bottomLeft,
              //             //   colors: [
              //             //     Color(0xffa8ff78),
              //             //     Color(0xff78ffd6),
              //             //   ],
              //             // )
              //           ),
              //           child: Column(
              //             // alignment: AlignmentDirectional.center,
              //             children: [
              //               ClipOval(
              //                 child: Material(
              //                   color: Theme.of(context)
              //                       .primaryColor
              //                       .withAlpha(30),
              //                   child: Container(
              //                     margin: EdgeInsets.all(8.0),
              //                     // color: Colors.red,
              //                     child: Image(
              //                       image: AssetImage("assets/img/box.png"),
              //                       fit: BoxFit.cover,
              //                       // width: MediaQuery.of(context).size.width / 10,
              //                       height: 50.0,
              //                     ),
              //                   ),
              //                 ),
              //               ),
              //               SizedBox(
              //                 height: 8.0,
              //               ),
              //               Text(
              //                 "transportation".tr,
              //                 textScaleFactor: 1.0,
              //                 style: TextStyle(
              //                   color: Colors.grey[800],
              //                   fontWeight: FontWeight.w500,
              //                 ),
              //                 textAlign: TextAlign.center,
              //               ),
              //             ],
              //           )),
              //     )),
            ],
          ),
        ],
      ),
    );
  }
}
