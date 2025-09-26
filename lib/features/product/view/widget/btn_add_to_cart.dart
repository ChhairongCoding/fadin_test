import 'package:flutter/material.dart';

Widget btnAddToCart({required onPressed, required String? title}) {
  return Builder(
      builder: (context) => ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: Colors.green.withOpacity(0.25),
              padding: EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5),
                      bottomLeft: Radius.circular(5))),
            ),
            onPressed: () {
              onPressed();
            },
            child: Text(title!.toUpperCase(),
                style: TextStyle(color: Colors.green, fontSize: 16)),
          ));
}
