import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../game/world.dart';
import 'slider.dart';

class MouseSensivitySlider extends StatefulWidget {
  final SustainaCityWorld world;
  const MouseSensivitySlider({super.key, required this.world});

  @override
  State<MouseSensivitySlider> createState() =>
      _MouseSensivitySliderWidgetState();
}

class _MouseSensivitySliderWidgetState extends State<MouseSensivitySlider> {
  @override
  Widget build(BuildContext context) {
    return NesSlider(
      initialValue: 0.5,
      onChanged: (newValue) {
        setState(() {
          if (mounted) {
            widget.world.mouseSensivity = newValue;
          }
        });
      },
      nesSliderTheme: const NesSliderTheme(
        activeTrackColor: Colors.black,
        inactiveTrackColor: Colors.grey,
        thumbColor: Colors.grey,
        trackHeight: 4.0,
        thumbSize: 15.0,
      ),
    );
  }
}
