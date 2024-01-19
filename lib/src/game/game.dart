import 'dart:math';

import 'package:flame/events.dart';
import 'package:flame/game.dart';

import 'tiles/buildings/house.dart';
import 'tiles/coordinates.dart';
import 'tiles/tile.dart';
import 'world.dart';

final class SustainaCityGame extends FlameGame<SustainaCityWorld>
    with SingleGameInstance, TapDetector, SecondaryTapDetector {
  /// The tile that the mouse is currently hovering over. Null if the mouse
  /// leaves the game area.
  Tile? hoveredTile;

  SustainaCityGame() : super(world: SustainaCityWorld()) {
    pauseWhenBackgrounded = false;
  }

  /// Left-click handler
  @override
  void onTapUp(TapUpInfo info) {
    if (hoveredTile != null) {
      world.build(House(hoveredTile!.coordinates,
          Model.values[Random().nextInt(Model.values.length)]));
    }
    super.onTapUp(info);
  }

  /// Right-click handler
  @override
  void onSecondaryTapUp(TapUpInfo info) {
    if (hoveredTile != null) {
      world.destroy(
          hoveredTile!.coordinates,
          TileCoordinates(
            (info.eventPosition.global.x - 0.5 * canvasSize.x) ~/ Tile.unitSize,
            (info.eventPosition.global.y - 0.5 * canvasSize.y) ~/ Tile.unitSize,
          ));
    }
    super.onSecondaryTapUp(info);
  }
}
