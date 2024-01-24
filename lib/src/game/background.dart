import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';

import 'tiles/coordinates.dart';
import 'tiles/tile.dart';

/// Renders the background of the game.
final class Background extends SpriteComponent {
  /// The size of the background in units. This should be enough to cover the
  /// entirety of an 8k monitor.
  static const unitSize = 325;

  /// The offset of the background from the camera position in units.
  static const cameraOffset = -unitSize ~/ 2;

  /// Returns the offset of the background from [cameraCoordinates] in pixels.
  static Vector2 _offset(UnitCoordinates cameraCoordinates) =>
      (cameraCoordinates +
              (UnitCoordinates(cameraOffset, cameraOffset), checkBounds: false))
          .toVector2()
          .scaled(Tile.pixelSize);

  Background() : super(position: _offset(UnitCoordinates(0, 0)), priority: -1);

  /// Updates the [position] of the background based on [cameraCoordinates].
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
