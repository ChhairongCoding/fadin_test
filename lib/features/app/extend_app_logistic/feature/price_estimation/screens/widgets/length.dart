import 'package:fardinexpress/utils/bloc/indexing/indexing_bloc.dart';
import 'package:fardinexpress/utils/bloc/indexing/indexing_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'custom_slider_theme_data.dart';

class Length extends StatelessWidget {
  static final TextEditingController heightCtl =
      TextEditingController(text: "10");
  final int height = 10;
  final double _fontSize = 16;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Text("Length"),
              SizedBox(width: 10),
              ConstrainedBox(
                constraints: BoxConstraints(minWidth: 10),
                child: IntrinsicWidth(
                  child: TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18)),
                        padding:
                            EdgeInsets.symmetric(horizontal: 0, vertical: 0)),
                    child: TextField(
                      // enableInteractiveSelection: false,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: _fontSize,
                        fontWeight: FontWeight.w900,
                      ),
                      textAlign: TextAlign.center,
                      controller: heightCtl,

                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                        hintText: '10',
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10),
              Text("cm", style: TextStyle(color: Colors.grey[700]))
            ],
          ),
        ),
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            SliderTheme(
                data: customSliderThemeData(context),
                child: BlocBuilder<IndexingBloc, int>(
                  builder: (c, state) {
                    return Slider(
                      value: (state == 0) ? 1 : state.toDouble(),
                      min: 1,
                      max: 100,
                      activeColor: Theme.of(context).primaryColor,
                      onChanged: (double value) {
                        BlocProvider.of<IndexingBloc>(context)
                            .add(Taped(index: value.toInt()));
                        heightCtl.text = value.toStringAsFixed(0);
                        // setState(() {
                        //   heightCtl.text = value.toStringAsFixed(0);
                        //   height = value.round();
                        // });
                      },
                    );
                  },
                )),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "1  ",
                    textScaleFactor: 0.9,
                  ),
                  Text(
                    "50",
                    textScaleFactor: 0.9,
                  ),
                  Text(
                    "100",
                    textScaleFactor: 0.9,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
