import 'package:flutter/material.dart';

customDialog(BuildContext context, String? title, Widget content, Function onOk,
    {bool dismissible = true}) {
  showDialog(
      barrierDismissible: dismissible,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: title == null ? null : Text(title),
          content: content,
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
                onOk();
              },
            )
          ],
        );
      });
}
