import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import '../screens/game_screen.dart';
import 'camera_controls.dart';
import 'tiles/buildings/factory.dart';
import 'tiles/buildings/house.dart';
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
  Tile<Object?>? hoveredTile;

  /// The tile that is currently selected to be placed on the map.
  ActiveTile activeTile = ActiveTile.factory;

  SustainaCityGame() : super(world: SustainaCityWorld()) {
    pauseWhenBackgrounded = false;
  }

  /// Converts screen coordinates (with pan/zoom) to tile coordinates
  TileCoordinates fromScreenCoordinates(Vector2 screenCoordinates) {
    final tileCoordinatesVector = screenCoordinates.clone()
      ..sub(canvasSize.scaled(0.5))
      ..sub(camera.viewport.position)
      ..scale(1 / (camera.viewfinder.zoom * Tile.unitSize));
    return TileCoordinates(
      tileCoordinatesVector.x.floor(),
      tileCoordinatesVector.y.floor(),
    );
  }

  @override
  void onPanUpdate(DragUpdateInfo info) =>
      camera.pan(camera.viewport.position + info.delta.global);

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
    } else if (keysPressed.contains(LogicalKeyboardKey.digit1)) {
      activeTile = ActiveTile.factory;
    } else if (keysPressed.contains(LogicalKeyboardKey.digit2)) {
      activeTile = ActiveTile.smallHouse;
    } else if (keysPressed.contains(LogicalKeyboardKey.digit3)) {
      activeTile = ActiveTile.largeHouse;
    } else {
      return KeyEventResult.ignored;
    }
    return KeyEventResult.handled;
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
      final coords = hoveredTile!.coordinates;
      world.build(
        switch (activeTile) {
          ActiveTile.factory => Factory(coords),
          ActiveTile.smallHouse => SmallHouse(coords),
          ActiveTile.largeHouse => LargeHouse(coords),
        },
      );
    }
    super.onTapUp(info);
  }

  /// Right-click handler
  @override
  void onSecondaryTapUp(TapUpInfo info) {
    if (hoveredTile != null) {
      world.destroy(
        hoveredTile!.coordinates,
        fromScreenCoordinates(info.eventPosition.global),
      );
    }
    super.onSecondaryTapUp(info);
  }
}
