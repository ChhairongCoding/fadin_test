import 'package:flutter/material.dart';

class DialogMessageWidget {
  static Future<void> show(
          {required BuildContext context,
          required String title,
          required String message,
          VoidCallback? onOk,
          required int success}) =>
      showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Image.asset(
              success == 0
                  ? 'assets/dialog_state/close.png'
                  : success == 1
                      ? 'assets/dialog_state/check.png'
                      : success == 2
                          ? 'assets/dialog_state/information.png'
                          : 'assets/dialog_state/warning.gif',
              height: 60,
              fit: BoxFit.contain,
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(
                    message,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            actionsAlignment: MainAxisAlignment.center, // center actions
            actions: <Widget>[
              if (onOk != null)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              if (onOk != null) SizedBox(width: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                child: Text('OK', style: TextStyle(color: Colors.white)),
                onPressed: () {
                  Navigator.of(context).pop();
                  if (onOk != null) {
                    onOk();
                  }
                },
              ),
            ],
          );
        },
      );
}
