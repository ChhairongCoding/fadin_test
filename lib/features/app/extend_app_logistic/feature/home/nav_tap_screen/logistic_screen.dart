import 'package:badges/badges.dart';
import 'package:badges/badges.dart' as badges;
import 'package:fardinexpress/features/account/controller/account_controller.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/feature/banner/screens/widgets/home_banner_slider.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/feature/home/screens/widgets/service.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/feature/home/screens/widgets/tracking.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/utils/constants/app_constant.dart';
import 'package:fardinexpress/features/notification/view/notification_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LogisticScreen extends StatefulWidget {
  const LogisticScreen({Key? key}) : super(key: key);

  @override
  State<LogisticScreen> createState() => _LogisticScreenState();
}

class _LogisticScreenState extends State<LogisticScreen> {
  final AccountController _controller = Get.find<AccountController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: appHeadBar(
            leading: false,
            context: context,
            leadingWidget: Container(),
            title: Container(
              // padding: EdgeInsets.symmetric(
              //     vertical: 9.0),
              child: CircleAvatar(
                radius: 25.0,
                // child: Icon(
                //   Icons.person_outline_sharp,
                //   size: 40,
                // ),
                backgroundImage: AssetImage("assets/img/fardin-logo.png"),
                backgroundColor: Colors.transparent,
              ),
            ),
            actionItem: badges.Badge(
              badgeStyle: BadgeStyle(
                padding: EdgeInsets.symmetric(horizontal: 3, vertical: 5),
                badgeColor: Colors.red,
              ),
              // badgeColor: Colors.blue,
              // padding: EdgeInsets.symmetric(horizontal: 3, vertical: 5),
              showBadge: true,
              position: BadgePosition.topEnd(top: 12, end: 13),
              badgeContent: Text(
                " ",
                textScaleFactor: 0.5,
              ),
              child: IconButton(
                  onPressed: () {
                    Get.to(() => NotificationPage(
                          notificationType: NotificationType.page,
                        ));
                    // Get.to(() => SuccessfulScreen());
                  },
                  icon: Icon(
                    Icons.notifications_active,
                    color: Colors.amber[700],
                  )),
            ),
            titleCenter: true),
        body: Container(
            color: Theme.of(context).primaryColor,
            padding: EdgeInsets.only(top: 10),
            child: SingleChildScrollView(
                child: standardAppbarStyle(
              context,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // addAutomaticKeepAlives: true,
                children: [
                  SizedBox(height: 20.0),
                  // Obx(() {
                  //   if (_controller.isLoading.value) {
                  //     return Center(child: CircularProgressIndicator());
                  //   } else {
                  //     return GestureDetector(
                  //       onTap: () {
                  //          Get.to(() => AddressList(
                  //               isCheckout: false,
                  //             ));
                  //       },
                  //       child: Container(
                  //           child: ListTile(
                  //         title: Text(
                  //           "${_controller.userName.value.toString().toUpperCase()}",
                  //           style: TextStyle(
                  //               fontSize: 18.0,
                  //               color: Colors.grey[800],
                  //               fontWeight: FontWeight.bold),
                  //         ),
                  //         subtitle: Row(
                  //           children: [
                  //             Icon(
                  //               Icons.location_on,
                  //               color: Colors.red,
                  //             ),
                  //             Text(
                  //               "${_controller.accountInfo.address.description.toString()}",
                  //               style: TextStyle(color: Colors.grey[600]),
                  //             ),
                  //           ],
                  //         ),
                  //       )),
                  //     );
                  //   }
                  // }),
                  // SizedBox(height: 15),
                  Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: Tracking()),
                  SizedBox(height: 15),
                  Container(
                    margin: EdgeInsets.only(left: 20, top: 0, right: 20),
                    child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        child: HomeBannerSlider()),
                  ),
                  SizedBox(height: 30),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30))),
                      // padding: EdgeInsets.only(top: 20),
                      child: Service(),
                    ),
                  )
                ],
              ),
            ))));
  }
}
