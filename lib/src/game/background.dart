import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';

import 'tiles/coordinates.dart';
import 'tiles/tile.dart';

final class Background extends SpriteComponent {
  static const unitSize = 200;
  static const cameraOffset = (-unitSize ~/ 2) * Tile.pixelSize;

  static Vector2 _offset(UnitCoordinates cameraCoordinates) => Vector2(
      cameraCoordinates.x * Tile.pixelSize + cameraOffset,
      cameraCoordinates.y * Tile.pixelSize + cameraOffset);

  Background() : super(position: _offset(UnitCoordinates(0, 0)), priority: -1);

  void updatePosition(UnitCoordinates cameraCoordinates) =>
      position = _offset(cameraCoordinates);

  @override
  FutureOr<void> onLoad() async {
    sprite = Sprite(await Flame.images.load('bg.png'),
        srcSize: Vector2.all(unitSize * Tile.pixelSize),
        srcPosition: Vector2.zero());
    return await super.onLoad();
  }
}
