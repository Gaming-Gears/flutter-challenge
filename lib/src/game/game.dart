import 'package:flame/events.dart';
import 'package:flame/game.dart';

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
      world.buildHouse(hoveredTile!.coordinates);
    }
    super.onTapUp(info);
  }

  /// Right-click handler
  @override
  void onSecondaryTapUp(TapUpInfo info) {
    if (hoveredTile != null) {
      world.removeHouse(hoveredTile!.coordinates,
          ScreenCoordinates.fromTap(info).toTileCoordinates(canvasSize));
    }
    super.onSecondaryTapUp(info);
  }
}
