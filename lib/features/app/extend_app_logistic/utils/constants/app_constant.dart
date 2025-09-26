import 'package:flutter/material.dart';

double categoryItemBorderRadius = 10;
double bannerBorderRadius = 10;
double searchBarBorderRadius = 10;
double standardBorderRadius = 25;
double btnBorderRadius = 6.0;
mixin ErrorState {
  dynamic get error;
}

appHeadBar(
    {required BuildContext context,
    required Widget title,
    required Widget actionItem,
    required bool titleCenter,
    required bool leading,
    Widget? leadingWidget}) {
  return AppBar(
    // backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    leading: leadingWidget,
    automaticallyImplyLeading: leading,
    backgroundColor: Theme.of(context).primaryColor,
    iconTheme: IconThemeData(color: Colors.white),
    elevation: 0,
    centerTitle: titleCenter,
    title: title,
    actions: [actionItem],
  );
}

standardAppbarStyle(BuildContext context, Widget childBody) {
  return Container(
    height: MediaQuery.of(context).size.height,
    decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(standardBorderRadius),
            topRight: Radius.circular(standardBorderRadius))),
    child: childBody,
  );
}
