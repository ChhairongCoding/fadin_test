import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget btnBuyNow({required onPressed}) {
  return Builder(
      builder: (context) => ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              padding: EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                topRight: Radius.circular(5),
                bottomRight: Radius.circular(5),
              )),
              backgroundColor: Colors.green,
            ),
            onPressed: () {
              onPressed();
            },
            child: Text("buyNow".tr.toUpperCase(),
                style: TextStyle(color: (Colors.white), fontSize: 16)),
          ));
}
