import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// rgb(135, 131, 138)

ThemeData lightTheme = ThemeData(
    fontFamily: 'Siemreap',
    scaffoldBackgroundColor: Colors.grey[50],
    brightness: Brightness.light,
    primaryColor: Colors.green,
    cardColor: Colors.white,
    textTheme: TextTheme(
      displayLarge: TextStyle(
          color: Colors.black, letterSpacing: 0, fontWeight: FontWeight.w300),
      // bodyText1: TextStyle(color: Colors.amber),
      // bodyText2: TextStyle(color: Colors.deepPurpleAccent)
    ),
    appBarTheme: AppBarTheme(
        elevation: 0,
        color: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.15)),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: Colors.green,
      selectedLabelStyle: TextStyle(color: Colors.green),
      unselectedItemColor: Color.fromRGBO(158, 158, 158, 1),
      unselectedLabelStyle: TextStyle(
        color: Colors.grey[500],
      ),
    ),
    colorScheme: ColorScheme.light(primary: Colors.green)
        .copyWith(background: Colors.white));
