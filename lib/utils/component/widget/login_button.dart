import 'package:fardinexpress/config/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget loginButton({required BuildContext context}) => SizedBox(
      width: double.infinity,
      child: TextButton(
          style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            backgroundColor: Theme.of(context).primaryColor,
            padding: const EdgeInsets.symmetric(vertical: 15),
          ),
          onPressed: () {
            Navigator.pushNamed(context, authPage, arguments: true);
          },
          child: Text(
            "login".tr,
            textScaleFactor: 1.1,
            style: TextStyle(color: Colors.white),
          )),
    );
