import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart;
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import '../screens/game_screen.dart';
import 'build_mode/build_mode.dart';
import 'camera.dart';
import 'info_box/info_box.dart';
import 'tiles/coordinates.dart';
import 'tiles/tile.dart';
import 'world.dart';

mixin Pauseable on HasGameRef<SustainaCityGame> implements Component {
  @override
  @mustCallSuper
  void update(double dt) {
    if (gameRef.isPaused) {
      return;
    }
    super.update(dt);
  }
}

final class SustainaCityGame extends FlameGame<SustainaCityWorld>
    with
        SingleGameInstance,
        TapDetector,
        SecondaryTapDetector,
        KeyboardEvents,
        PanDetector,

        MouseMovementDetector,

        ScrollDetector,
        PointerMoveCallbacks {

  /// The current build mode. This determines what happens when the players taps
  late BuildMode _buildMode;

  /// Whether or not the game is paused.
  bool isPaused = false;

  /// The currently hovered tile.
  Tile? hoveredTile;

  SustainaCityGame() : super(world: SustainaCityWorld()) {
    pauseWhenBackgrounded = false;
  }

  @override
  FutureOr<void> onLoad() async {
    _buildMode = BuildingBuildMode(CurrentBuilding.smallHouse, world);

    return await super.onLoad();
  }

  /// Converts screen coordinates (with pan/zoom) to global coordinates (units)
  UnitCoordinates? _toGlobalCoordinates(Vector2 screenCoordinates) {
    try {
      return ((screenCoordinates -
                  canvasSize.scaled(0.5) -
                  camera.viewport.position) /
              (camera.viewfinder.zoom * Tile.pixelSize))
          .toUnits();
    } on CoordinatesOutOfBounds catch (_) {
      return null;
    }
  }

  @override
  void onPanUpdate(DragUpdateInfo info) =>
      camera.pan(camera.viewport.position + info.delta.global);

  /// Zooms the camera in or out.
  @override
  void onScroll(PointerScrollInfo info) =>
      camera.zoomToCursor(info.scrollDelta.global.y, world.lastMousePosition);

  /// Called when the mouse is moved.
  @override
  void onMouseMove(PointerHoverInfo info) =>
      world.lastMousePosition = info.eventPosition.global;

  @override
  KeyEventResult onKeyEvent(
    // ignore: deprecated_member_use
    RawKeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    for (final key in keysPressed) {
      switch (key) {
        case LogicalKeyboardKey.escape:
          overlays.add(GameScreen.settingsMenu);
          return KeyEventResult.handled;
        case LogicalKeyboardKey.digit1:
          _buildMode = BuildingBuildMode(CurrentBuilding.smallHouse, world);
          return KeyEventResult.handled;
        case LogicalKeyboardKey.digit2:
          _buildMode = BuildingBuildMode(CurrentBuilding.largeHouse, world);
          return KeyEventResult.handled;
        case LogicalKeyboardKey.digit3:
          _buildMode = BuildingBuildMode(CurrentBuilding.factory, world);
          return KeyEventResult.handled;
      }
    }
    return KeyEventResult.ignored;
  }

  @override
  void onMount() {
    /// Add the pause button to the game on top left-corner.
    overlays.add(GameScreen.pauseKey);
    super.onMount();
  }

  void updateHighlightedTile(UnitCoordinates coordinates) {
    Tile? newTile;
    for (final layer in world.layers) {
      newTile = layer.get(coordinates) ?? newTile;
    }
    if (newTile != hoveredTile) {
      if (newTile != null) {
        hoveredTile?.unhighlight();
        newTile.highlight();
        hoveredTile = newTile;
      } else {
        hoveredTile?.unhighlight();
        hoveredTile = null;
      }
    }
  }

  /// Left-click handler
  @override
  void onTapUp(TapUpInfo info) {
    final position = _toGlobalCoordinates(info.eventPosition.global);
    if (position != null) {
      _buildMode.build(position);
      updateHighlightedTile(position);
    }
    super.onTapUp(info);
  }

  /// Right-click handler
  @override
  void onSecondaryTapUp(TapUpInfo info) {
    final position = _toGlobalCoordinates(info.eventPosition.global);
    if (position != null) {
      _buildMode.destroy(position);
      updateHighlightedTile(position);
    }
    super.onSecondaryTapUp(info);
  }

  @override
  void onPointerMove(PointerMoveEvent event) {
    final position = _toGlobalCoordinates(event.devicePosition);
    if (position != null) {
      updateHighlightedTile(position);
    }
    super.onPointerMove(event);
  }

  @override
  void onTap() {
    camera.viewport.add(InfoBoxComponent(
        info: 'info', position: Vector2(500, 500), size: Vector2(200, 100)));
    super.onTap();
  }
}
