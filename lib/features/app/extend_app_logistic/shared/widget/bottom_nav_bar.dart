import 'package:fardinexpress/features/app/extend_app_logistic/feature/home/screens/home_logistic_wrapper.dart';
import 'package:fardinexpress/utils/bloc/navbar_indexing/navbar_indexing_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int tabIndex = 1;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: bottomNavBarIndexBloc,
      builder: (BuildContext context, dynamic state) {
        return BottomNavigationBar(
            selectedFontSize: 12.0,
            unselectedFontSize: 12.0,
            type: BottomNavigationBarType.fixed,
            showUnselectedLabels: false,
            // showSelectedLabels: (tabIndex.toString() == "0") ? false : true,
            showSelectedLabels: true,
            currentIndex: state,
            onTap: (index) {
              onButtomNavigationTapped(index);
              tabIndex = index;
              setState(() {
                if (tabIndex == 0) {
                  Get.back();
                }
              });
            },
            items: <BottomNavigationBarItem>[
              // BottomNavigationBarItem(
              //   icon: AspectRatio(
              //       aspectRatio: (tabIndex.toString() == "0") ? 4 / 1 : 5 / 1,
              //       child: (tabIndex.toString() == "0")
              //           ? Image.asset("assets/img/logo/aha_logo.png")
              //           : Image.asset("assets/img/logo/aha_logo_black.png")),
              //   label: AppLocalizations.of(context)!.translate("home")!,
              // ),
              BottomNavigationBarItem(
                icon: AspectRatio(
                    aspectRatio: (tabIndex.toString() == "0") ? 4 / 1 : 5 / 1,
                    child: (tabIndex.toString() == "0")
                        ? Image.asset("assets/img/fardin-logo.png")
                        : Image.asset("assets/img/fardin-logo.png")),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: AspectRatio(
                    aspectRatio: (tabIndex.toString() == "1") ? 4 / 1 : 5 / 1,
                    child: (tabIndex.toString() == "1")
                        ? Image.asset(
                            "assets/extend_assets/icons/bottom_navigation/delivery-truck-light.png")
                        : Image.asset(
                            "assets/extend_assets/icons/bottom_navigation/delivery-truck-dark.png")),
                label: "Express",
              ),
              BottomNavigationBarItem(
                icon: AspectRatio(
                    aspectRatio: (tabIndex.toString() == "2") ? 4 / 1 : 5 / 1,
                    child: (tabIndex.toString() == "2")
                        ? Image.asset(
                            "assets/extend_assets/icons/bottom_navigation/logistics-light.png")
                        : Image.asset(
                            "assets/extend_assets/icons/bottom_navigation/logistics-dark.png")),
                label: "Logistic",
              ),
              BottomNavigationBarItem(
                icon: AspectRatio(
                    aspectRatio: (tabIndex.toString() == "3") ? 4 / 1 : 5 / 1,
                    child: (tabIndex.toString() == "3")
                        ? Image.asset(
                            "assets/extend_assets/icons/bottom_navigation/information-light.png")
                        : Image.asset(
                            "assets/extend_assets/icons/bottom_navigation/information-dark.png")),
                label: "Info",
              ),
            ]);
      },
    );
  }

  static void onButtomNavigationTapped(int index) {
    bottomNavBarIndexBloc!.add(Taped(index: index));
  }

  @override
  void dispose() {
    bottomNavBarIndexBloc!.close();
    for (var bloc in LogisticHomeWrapperState.bottomNavBarInvokingBloc!) {
      bloc.close();
    }
    super.dispose();
  }
}
