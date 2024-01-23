import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class InfoBoxComponent extends PositionComponent {
  final String info;
  late TextPainter _painter;
  late TextStyle _textStyle;
  final Paint _backgroundPaint;

  InfoBoxComponent({required this.info, super.position, Vector2? size})
      : _backgroundPaint = Paint()..color = Colors.white,
        super(size: size ?? Vector2(200, 200)) {
    _textStyle = const TextStyle(color: Colors.black, fontSize: 14);
    _painter = TextPainter(
      text: TextSpan(text: info, style: _textStyle),
      textDirection: TextDirection.ltr,
    );
    _painter.layout();
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawRect(size.toRect(), _backgroundPaint);
    _painter.paint(
        canvas,
        Vector2(size.x / 2 - _painter.width / 2,
                size.y / 2 - _painter.height / 2)
            .toOffset());
  }
}
