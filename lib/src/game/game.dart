import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import '../screens/game_screen.dart';
import 'build_mode/build_mode.dart';
import 'camera.dart';
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
        ScrollDetector {
  /// The current build mode. This determines what happens when the players taps
  late BuildMode _buildMode;

  bool isPaused = false;

  SustainaCityGame() : super(world: SustainaCityWorld()) {
    pauseWhenBackgrounded = false;
  }

  @override
  FutureOr<void> onLoad() async {
    _buildMode = BuildingBuildMode(CurrentBuilding.smallHouse, world);
    return await super.onLoad();
  }

  /// Converts screen coordinates (with pan/zoom) to global coordinates (units)
  UnitCoordinates _toGlobalCoordinates(Vector2 screenCoordinates) =>
      ((screenCoordinates - canvasSize.scaled(0.5) - camera.viewport.position) /
              (camera.viewfinder.zoom * Tile.unitSize))
          .toUnits();

  @override
  void onPanUpdate(DragUpdateInfo info) =>
      camera.pan(camera.viewport.position + info.delta.global);

  @override
  void onScroll(PointerScrollInfo info) {
    camera.zoom(info.scrollDelta.global.y);
  }

  @override
  void onMouseMove(PointerHoverInfo info) {
    camera.panToCursor(info.eventPosition.global);
    super.onMouseMove(info);
  }

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

  /// Left-click handler
  @override
  void onTapUp(TapUpInfo info) {
    _buildMode.build(_toGlobalCoordinates(info.eventPosition.global));
    super.onTapUp(info);
  }

  /// Right-click handler
  @override
  void onSecondaryTapUp(TapUpInfo info) {
    _buildMode.destroy(_toGlobalCoordinates(info.eventPosition.global));
    super.onSecondaryTapUp(info);
  }
}
