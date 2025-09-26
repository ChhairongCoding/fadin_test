import 'package:flutter/material.dart';

SliderThemeData customSliderThemeData(BuildContext context) =>
    SliderTheme.of(context).copyWith(
      activeTrackColor: Theme.of(context).primaryColor,
      inactiveTrackColor: Theme.of(context).primaryColor.withOpacity(0.2),
      // trackShape: RectangularSliderTrackShape(),
      trackHeight: 4,
      thumbColor: Colors.blueAccent,
      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
      overlayColor: Colors.red.withAlpha(32),
      overlayShape: RoundSliderOverlayShape(overlayRadius: 25),
    );
