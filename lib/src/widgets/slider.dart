import 'package:flutter/material.dart';

import '../game/audio_controller.dart';

// Custom NES Slider Thumb Shape
class NesSliderThumbShape extends SliderComponentShape {
  final double thumbSize;

  const NesSliderThumbShape(this.thumbSize);

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size(thumbSize, thumbSize);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;

    final paint = Paint()
      ..color = sliderTheme.thumbColor!
      ..style = PaintingStyle.fill;

    // Drawing a square thumb for a pixelated look
    canvas.drawRect(
      Rect.fromCenter(center: center, width: thumbSize, height: thumbSize),
      paint,
    );
  }
}

// Custom NES Slider Track Shape
class NesSliderTrackShape extends SliderTrackShape {
  final double trackHeight;

  const NesSliderTrackShape({required this.trackHeight});

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required Animation<double> enableAnimation,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required Offset thumbCenter,
    bool isDiscrete = false,
    bool isEnabled = true,
    Offset? secondaryOffset,
  }) {
    final Canvas canvas = context.canvas;
    final activeRect = Rect.fromLTWH(
      offset.dx,
      offset.dy + (parentBox.size.height - trackHeight) / 2,
      thumbCenter.dx - offset.dx, // Calculate the width based on thumbCenter
      trackHeight,
    );

    final inactiveRect = Rect.fromLTWH(
      thumbCenter.dx,
      offset.dy + (parentBox.size.height - trackHeight) / 2,
      parentBox.size.width - thumbCenter.dx,
      trackHeight,
    );

    // Paint active track
    _drawPixelatedLine(canvas, activeRect, sliderTheme.activeTrackColor!);
    // Paint inactive track
    _drawPixelatedLine(canvas, inactiveRect, sliderTheme.inactiveTrackColor!);
  }

  void _drawPixelatedLine(Canvas canvas, Rect rect, Color color) {
    final paint = Paint()..color = color;
    // Create a pixelated line effect by drawing multiple small squares
    for (double i = 0; i < rect.width; i += trackHeight) {
      canvas.drawRect(
        Rect.fromLTWH(rect.left + i, rect.top, trackHeight, rect.height),
        paint,
      );
    }
  }

  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    // The vertical center of the parent box
    final double verticalCenter =
        offset.dy + (parentBox.size.height - trackHeight) / 2;

    // The width of the parent box
    final double width = parentBox.size.width;

    return Rect.fromLTWH(
      offset.dx,
      verticalCenter,
      width,
      trackHeight,
    );
  }
}

// NES Slider Theme
class NesSliderTheme {
  final Color activeTrackColor;
  final Color inactiveTrackColor;
  final Color thumbColor;
  final double trackHeight;
  final double thumbSize;

  const NesSliderTheme({
    required this.activeTrackColor,
    required this.inactiveTrackColor,
    required this.thumbColor,
    required this.trackHeight,
    required this.thumbSize,
  });
}

// NES Slider Widget
class NesSlider extends StatefulWidget {
  final double initialValue;
  final ValueChanged<double> onChanged;
  final NesSliderTheme nesSliderTheme;

  const NesSlider({
    super.key,
    required this.initialValue,
    required this.onChanged,
    required this.nesSliderTheme,
  });

  @override
  _NesSliderState createState() => _NesSliderState();
}

class _NesSliderState extends State<NesSlider> {
  late double _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        activeTrackColor: widget.nesSliderTheme.activeTrackColor,
        inactiveTrackColor: widget.nesSliderTheme.inactiveTrackColor,
        thumbColor: widget.nesSliderTheme.thumbColor,
        trackHeight: widget.nesSliderTheme.trackHeight,
        thumbShape: NesSliderThumbShape(widget.nesSliderTheme.thumbSize),
        trackShape:
            NesSliderTrackShape(trackHeight: widget.nesSliderTheme.trackHeight),
      ),
      child: Slider(
        value: _currentValue,
        onChanged: (newValue) {
          setState(() {
            _currentValue = newValue;
          });
          widget.onChanged(newValue);
        },
      ),
    );
  }
}

// Example usage of NesSlider
class SliderWidget extends StatefulWidget {
  const SliderWidget({super.key});

  @override
  State<SliderWidget> createState() => _SliderWidgetState();
}

class _SliderWidgetState extends State<SliderWidget> {
  @override
  Widget build(BuildContext context) {
    return NesSlider(
      initialValue: 0.5,
      onChanged: (newValue) {
        setState(() => AudioController().setBgmVolume(newValue));
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
