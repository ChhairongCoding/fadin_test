import 'dart:io';
import 'package:flutter/material.dart';

class PendingWidget extends StatelessWidget {
  const PendingWidget(
      {Key? key, required this.firstChild, required this.secondChild});
  final Widget firstChild;
  final Widget secondChild;

  static bool get validDate =>
      Platform.isAndroid || DateTime.now().isAfter(DateTime(2025, 9, 10));

  @override
  Widget build(BuildContext context) {
    return validDate ? secondChild : firstChild;
  }
}
