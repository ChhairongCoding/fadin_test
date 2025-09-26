import 'dart:async';

import 'package:fardinexpress/features/app/view/landing_page.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 2),
        () => Navigator.pushAndRemoveUntil(context,
                MaterialPageRoute(builder: (context) {
              return LandingPage();
            }), (route) => false));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Theme.of(context).primaryColor,
        // child: Image.asset("assets/img/splash_page/stand_banner.jpg"),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: AspectRatio(
                    aspectRatio: 18 / 9,
                    child: Image.asset("assets/img/fardin-logo.png")),
              ),
              // SizedBox(
              //   height: 10.0,
              // ),
              // Text(
              //   "Fardin Express",
              //   textScaleFactor: 1.3,
              //   style: TextStyle(fontWeight: FontWeight.w600),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
