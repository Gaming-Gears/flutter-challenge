import 'package:flame/events.dart';
import 'package:flame/game.dart';

import 'tiles/coordinates.dart';
import 'tiles/tile.dart';
import 'world.dart';

final class SustainaCity extends FlameGame<SustainaCityWorld>
    with SingleGameInstance, TapDetector, SecondaryTapDetector {
  Tile? hoveredTile;

  SustainaCity() : super(world: SustainaCityWorld()) {
    pauseWhenBackgrounded = false;
  }

  @override
  void onTapUp(TapUpInfo info) {
    if (hoveredTile != null) {
      world.buildHouse(hoveredTile!.coordinates);
    }
    super.onTapUp(info);
  }

  @override
  void onSecondaryTapUp(TapUpInfo info) {
    if (hoveredTile != null) {
      world.removeHouse(hoveredTile!.coordinates,
          ScreenCoordinates.fromTap(info).toTileCoordinates(canvasSize));
    }
    super.onSecondaryTapUp(info);
  }
}
