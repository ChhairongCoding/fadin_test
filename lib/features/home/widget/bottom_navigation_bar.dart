import 'package:fardinexpress/features/auth/bloc/auth_bloc.dart';
import 'package:fardinexpress/features/auth/bloc/auth_state.dart';
import 'package:fardinexpress/features/home/home.dart';
import 'package:fardinexpress/utils/bloc/indexing/indexing_event.dart';
import 'package:fardinexpress/utils/component/widget/cart_button.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppBottomNavigationBar extends StatefulWidget {
  const AppBottomNavigationBar({Key? key}) : super(key: key);

  @override
  _AppBottomNavigationBarState createState() => _AppBottomNavigationBarState();
}

class _AppBottomNavigationBarState extends State<AppBottomNavigationBar> {
  int tabIndex = 0;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: bottomNavigationIndexBloc,
      builder: (BuildContext context, dynamic state) {
        return BottomAppBar(
            color: Colors.white70,
            elevation: 0.0,
            // height: 80.0,
            // color: Colors.transparent,
            shape: CircularNotchedRectangle(),
            notchMargin: 8.0,
            clipBehavior: Clip.antiAlias,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: BottomNavigationBar(
                  backgroundColor: Colors.green.withValues(alpha: 0.5),
                  elevation: 0.0,
                  selectedFontSize: 12.0,
                  unselectedFontSize: 12.0,
                  type: BottomNavigationBarType.fixed,
                  showUnselectedLabels: false,
                  // showSelectedLabels: (tabIndex.toString() == "0") ? false : true,
                  showSelectedLabels: false,
                  currentIndex: state,
                  onTap: (index) {
                    onButtomNavigationTapped(index);
                    tabIndex = index;
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
                        icon: Image.asset(
                            tabIndex == 0
                                ? 'assets/icon/home-filled.png'
                                : 'assets/icon/home-outlined.png',
                            height: 25.0),
                        // Icon(
                        //     tabIndex == 0 ? Icons.home : Icons.home_outlined),
                        label: ""),
                    BottomNavigationBarItem(
                        icon: Image.asset(
                            tabIndex == 1
                                ? 'assets/icon/apps-filled.png'
                                : 'assets/icon/apps-outlined.png',
                            height: 25.0),
                        // Icon(tabIndex == 1
                        //     ? Icons.dataset
                        //     : Icons.dataset_outlined),
                        label: ""),
                    BottomNavigationBarItem(
                        icon: BlocBuilder<AuthenticationBloc, AuthState>(
                            builder: (context, state) {
                          if (state is NotAuthenticated) {
                            return Image.asset(
                                tabIndex == 2
                                    ? 'assets/icon/shopping-cart-filled.png'
                                    : 'assets/icon/shopping-cart-outlined.png',
                                height: 25.0);
                            // Icon(tabIndex == 2
                            //     ? Icons.shopping_cart
                            //     : Icons.shopping_cart_outlined);
                          } else {
                            return cartButton(
                                context: context, index: tabIndex);
                          }
                        }),
                        label: ""),
                    BottomNavigationBarItem(
                        icon: Image.asset(
                            tabIndex == 3
                                ? 'assets/icon/account-filled.png'
                                : 'assets/icon/account-outlined.png',
                            height: 25.0),
                        // Icon(
                        //     tabIndex == 3 ? Icons.person : Icons.person_outline),
                        label: ""),
                  ]),
            ));
      },
    );
  }

  static void onButtomNavigationTapped(int index) {
    bottomNavigationIndexBloc!.add(Taped(index: index));
  }

  @override
  void dispose() {
    bottomNavigationIndexBloc!.close();
    for (var bloc in HomeState.bottomNavigationPagesInvokingBloc!) {
      bloc.close();
    }
    super.dispose();
  }
}
