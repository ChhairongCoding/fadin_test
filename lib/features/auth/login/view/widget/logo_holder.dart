import 'package:flutter/material.dart';

Widget logoHolder() => Row(
      children: [
        Expanded(flex: 25, child: Container()),
        const Expanded(
            flex: 50,
            child: AspectRatio(
              aspectRatio: 1.5,
              child: FittedBox(
                  child:
                      Image(image: AssetImage("assets/img/fardin-logo.png"))),
            )),
        Expanded(flex: 25, child: Container()),
      ],
    );
