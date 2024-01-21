import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../screens/game_screen.dart';
import 'build_mode/build_mode.dart';
import 'camera_controls.dart';
import 'tiles/coordinates.dart';
import 'tiles/tile.dart';
import 'world.dart';

mixin Pauseable on HasGameRef<SustainaCityGame> {
  void gameUpdate(double dt);

  @override
  @nonVirtual
  void update(double dt) {
    if (gameRef.isPaused) {
      return;
    }
    gameUpdate(dt);
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

  /// Converts screen coordinates (with pan/zoom) to tile coordinates
  TileCoordinates _fromScreenCoordinates(Vector2 screenCoordinates) {
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
    _buildMode.build(_fromScreenCoordinates(info.eventPosition.global));
    super.onTapUp(info);
  }

  /// Right-click handler
  @override
  void onSecondaryTapUp(TapUpInfo info) {
    _buildMode.destroy(_fromScreenCoordinates(info.eventPosition.global));
    super.onSecondaryTapUp(info);
  }
}
