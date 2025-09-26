import 'package:flutter/material.dart';

void errorSnackBar({required String text, required BuildContext context}) =>
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      margin: EdgeInsets.only(bottom: 20, left: 20, right: 20),
      backgroundColor: Colors.grey[850],
      content: Text(
        text,
        style: TextStyle(color: Colors.white),
      ),
      behavior: SnackBarBehavior.floating,
    ));
