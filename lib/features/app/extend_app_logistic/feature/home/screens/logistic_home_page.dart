import 'package:badges/badges.dart' as badges;
import 'package:badges/badges.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/feature/banner/screens/widgets/home_banner_slider.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/feature/home/screens/widgets/service_express.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/utils/constants/app_constant.dart';
import 'package:fardinexpress/features/notification/view/notification_page.dart';
import 'package:fardinexpress/utils/component/widget/custom_tabview.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'widgets/service.dart';
import 'widgets/tracking.dart';

final List<Color?> colorList = [
  Colors.red[100],
  Colors.blue[100],
  Colors.green[100],
  Colors.purple[100],
  Colors.orange[100],
  Colors.lightGreen[100],
  Colors.yellow[100],
  Colors.pink[100],
  Colors.lime[100]
];

class LogisticHomePage extends StatelessWidget {
  static ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: appHeadBar(
            leading: true,
            context: context,
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
                badgeColor: Colors.blue,
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
                    Icons.notifications_outlined,
                    color: Colors.white,
                  )),
            ),
            titleCenter: true),
        body: Container(
            color: Theme.of(context).primaryColor,
            padding: EdgeInsets.only(top: 10),
            child: HomeBody()));
  }
}

class HomeBody extends StatelessWidget {
  final RefreshController _refreshController = RefreshController();
  @override
  Widget build(BuildContext context) {
    final _homepageTap = <Tab>[
      Tab(
          child: Text("express".tr,
              style: TextStyle(
                fontSize: 16.0,
              ))),
      Tab(
          child: Text("logistic".tr,
              style: TextStyle(
                fontSize: 16.0,
              ))),
    ];
    // final RefreshController _refreshController = RefreshController();
    int initPosition = 0;
    return SingleChildScrollView(
        child: standardAppbarStyle(
      context,
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // addAutomaticKeepAlives: true,
        children: [
          SizedBox(height: 15),
          Container(
              margin: EdgeInsets.symmetric(horizontal: 20), child: Tracking()),
          SizedBox(height: 15),
          Container(
            margin: EdgeInsets.only(left: 20, top: 0, right: 20),
            child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                child: HomeBannerSlider()),
          ),
          SizedBox(height: 15),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30))),
              // padding: EdgeInsets.only(top: 20),
              child: CustomTabView(
                  itemCount: _homepageTap.length,
                  tabBuilder: (context, index) => _homepageTap[index],
                  pageBuilder: (context, index) {
                    if (index == 0) {
                      return SingleChildScrollView(
                          child: Container(
                              padding: EdgeInsets.only(top: 20),
                              child: ServiceExpress()));
                    } else {
                      return Container(
                          padding: EdgeInsets.only(top: 20), child: Service());
                    }
                  },
                  onPositionChange: (index) {
                    initPosition = index;
                  },
                  initPosition: initPosition),
            ),
          )
        ],
      ),
    ));
  }
}
