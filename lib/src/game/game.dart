import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';

import 'game_screen.dart';
import 'tiles/buildings/factory.dart';
import 'tiles/coordinates.dart';
import 'tiles/tile.dart';
import 'world.dart';

final class SustainaCityGame extends FlameGame<SustainaCityWorld>
    with
        SingleGameInstance,
        TapDetector,
        SecondaryTapDetector,
        KeyboardEvents,
        PanDetector,
        ScaleDetector,
        ScrollDetector,
        HasGameReference {
  /// The tile that the mouse is currently hovering over. Null if the mouse
  /// leaves the game area.
  Tile? hoveredTile;

  SustainaCityGame() : super(world: SustainaCityWorld()) {
    pauseWhenBackgrounded = false;
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    /// Move the camera
    world.cameraController.moveTo(camera.viewport.position - info.delta.global);
  }

  @override
  void onScroll(PointerScrollInfo info) {
    /// Zoom the camera
    world.cameraController.zoom(
        info.scrollDelta.global.y * 0.01); // Adjust the multiplier as needed
  }

  @override
  void onMount() {
    super.onMount();

    /// Add the pause button to the game on top left-corner.
    game.overlays.add(GameScreen.pauseKey);
  }

  @override
  void onRemove() {
    super.onRemove();
    game.overlays.remove(GameScreen.pauseKey);
  }

  /// Left-click handler
  @override
  void onTapUp(TapUpInfo info) {
    if (hoveredTile != null) {
      world.build(Factory(hoveredTile!.coordinates));
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
