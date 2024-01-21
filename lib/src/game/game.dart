import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import '../screens/game_screen.dart';
import 'camera_controls.dart';
import 'tiles/buildings/factory.dart';
import 'tiles/coordinates.dart';
import 'tiles/tile.dart';
import 'world.dart';

enum ActiveTile { factory, smallHouse, largeHouse }

final class SustainaCityGame extends FlameGame<SustainaCityWorld>
    with
        SingleGameInstance,
        TapDetector,
        SecondaryTapDetector,
        KeyboardEvents,
        PanDetector,
        ScrollDetector {
  /// The tile that the mouse is currently hovering over. Null if the mouse
  /// leaves the game area.
  Tile? hoveredTile;

  SustainaCityGame() : super(world: SustainaCityWorld()) {
    pauseWhenBackgrounded = false;
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    camera.pan(camera.viewport.position + info.delta.global);
  }

  @override
  void onScroll(PointerScrollInfo info) =>
      camera.zoom(info.scrollDelta.global.y);

  @override
  KeyEventResult onKeyEvent(
    // ignore: deprecated_member_use
    RawKeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    if (keysPressed.contains(LogicalKeyboardKey.escape)) {
      overlays.add(GameScreen.settingsMenu);
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  @override
  void onMount() {
    super.onMount();

    /// Add the pause button to the game on top left-corner.
    overlays.add(GameScreen.pauseKey);
  }

  @override
  void onRemove() {
    super.onRemove();
    overlays.remove(GameScreen.pauseKey);
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
