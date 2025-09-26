import 'package:fardinexpress/config/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget registerButton({required BuildContext context}) => SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: () {
          Navigator.pushNamed(context, authPage, arguments: false);
        },
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
              side: BorderSide(color: Theme.of(context).primaryColor)),
        ),
        // color: Theme.of(context).primaryColor,
        child: Text(
          "register".tr,
          style: TextStyle(color: Colors.black),
          textScaleFactor: 1.1,
        ),
      ),
    );
