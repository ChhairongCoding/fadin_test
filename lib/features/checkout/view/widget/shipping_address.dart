import 'package:flutter/material.dart';

Widget shippingAddress(
        String name, String phone, String address, Function() onTap) =>
    Builder(
      builder: (context) => GestureDetector(
        onTap: onTap,
        child: Container(
          color: Colors.grey[200],
          child: ListTile(
            leading: Icon(
              Icons.pin_drop_outlined,
              color: Colors.red,
            ),
            title: Text("$name " + " $phone"),
            subtitle: Text(
              address,
              style: TextStyle(color: Colors.black54),
            ),
          ),
        ),
      ),
    );
