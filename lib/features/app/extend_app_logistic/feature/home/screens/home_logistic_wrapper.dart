import 'package:fardinexpress/features/app/extend_app_logistic/feature/blog/screens/info_page.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/feature/home/nav_tap_screen/express_screen.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/feature/home/nav_tap_screen/logistic_screen.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/feature/home/screens/logistic_home_page.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/shared/widget/bottom_nav_bar.dart';
import 'package:fardinexpress/utils/bloc/invoking/invoking_bloc.dart';
import 'package:fardinexpress/utils/bloc/navbar_indexing/navbar_indexing_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

NavbarIndexingBloc? bottomNavBarIndexBloc;

class LogisticHomeWrapper extends StatefulWidget {
  const LogisticHomeWrapper({Key? key}) : super(key: key);

  @override
  LogisticHomeWrapperState createState() => LogisticHomeWrapperState();
}

class LogisticHomeWrapperState extends State<LogisticHomeWrapper> {
  static List<InvokingBloc>? bottomNavBarInvokingBloc;
  final List<Widget> bottomNavigationPages = [
    LogisticHomePage(),
    ExpressScreen(),
    LogisticScreen(),
    InfoPageWrapper()
  ];

  @override
  void initState() {
    bottomNavBarIndexBloc = NavbarIndexingBloc();
    bottomNavBarInvokingBloc = [
      InvokingBloc(),
      InvokingBloc(),
      InvokingBloc(),
      InvokingBloc(),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder(
          bloc: bottomNavBarIndexBloc,
          builder: (BuildContext context, dynamic state) {
            return IndexedStack(
              index: state,
              children: bottomNavigationPages,
            );
          }),
      bottomNavigationBar: BottomNavBar(),
    );
  }

  @override
  void dispose() {
    bottomNavBarIndexBloc!.close();
    for (var bloc in bottomNavBarInvokingBloc!) {
      bloc.close();
    }
    super.dispose();
  }
}
