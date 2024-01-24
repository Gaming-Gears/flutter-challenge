import 'dart:async';
import 'dart:io' show Platform;

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide PointerMoveEvent;
import 'package:flutter/services.dart';

import '../screens/game_screen.dart';
import 'build_mode/build_mode.dart';
import 'camera.dart';
import 'tiles/coordinates.dart';
import 'tiles/tile.dart';
import 'world.dart';

/// Add this to components that can be paused.
mixin Pauseable on HasGameRef<SustainaCityGame> implements Component {
  void updateGame(double dt);

  @override
  @nonVirtual
  void update(double dt) {
    if (!gameRef.isPaused) {
      updateGame(dt);
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

  /// The currently hovered tile.
  late Hoverable _hoveredTile;

  /// Whether or not the game is paused.
  bool isPaused = false;

  SustainaCityGame() : super(world: SustainaCityWorld()) {
    pauseWhenBackgrounded = false;
  }

  @override
  void onMount() {
    /// Add the pause button to the game on top left-corner.
    overlays.add(GameScreen.pauseKey);
    super.onMount();
  }

  @override
  FutureOr<void> onLoad() {
    _buildMode = BuildingBuildMode(CurrentBuilding.smallHouse, world);
    _hoveredTile = world.backgroundHover;
    return super.onLoad();
  }

  /// Converts screen coordinates (in pixels) to global coordinates (pixels)
  /// and applies pan/zoom.
  Vector2 screenCoordinatesToGlobal(Vector2 screenCoordinates) =>
      (screenCoordinates - canvasSize.scaled(0.5) - camera.viewport.position) /
      camera.viewfinder.zoom;

  /// Converts screen coordinates (in pixels) to global coordinates (units) and
  /// applies the pan and zoom. Returns null if the coordinates are out of
  /// bounds.
  UnitCoordinates? _screenCoordinatesToGlobal(Vector2 screenCoordinates) {
    try {
      return (screenCoordinatesToGlobal(screenCoordinates) / Tile.pixelSize)
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
  void onScroll(PointerScrollInfo info) => camera.zoomToCursor(
        (Platform.isMacOS ? 1 : -1) * info.scrollDelta.global.y,
        info.eventPosition.global,
      );

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
        case LogicalKeyboardKey.digit4:
          _buildMode = WireBuildMode(world);
          return KeyEventResult.handled;
      }
    }
    return KeyEventResult.ignored;
  }

  void updateHighlightedTile(UnitCoordinates coordinates) {
    // Find the highest priority tile at the coordinates
    Tile? newTile;
    for (final layer in world.layers) {
      newTile = layer.get(coordinates) ?? newTile;
    }

    // If the tile is null, highlight the background
    if (newTile == null) {
      // If the background is not already highlighted, unhighlight the old tile
      // and set _hoveredTile to the background
      if (_hoveredTile != world.backgroundHover) {
        _hoveredTile.unhighlight();
        _hoveredTile = world.backgroundHover;
      }
      // Update the coordinates of the background hover so it tracks the pointer
      world.backgroundHover.coordinates = coordinates;
      // If the newly hovered tile is not null and it is not the same as the
      // currently hovered tile, unhighlight the old tile and set _hoveredTile
    } else if (_hoveredTile != newTile) {
      _hoveredTile.unhighlight();
      _hoveredTile = newTile;
    }

    // Highlight the hovered tile
    _hoveredTile.highlight();
  }

  /// Left-click handler
  @override
  void onTapUp(TapUpInfo info) {
    final position = _screenCoordinatesToGlobal(info.eventPosition.global);
    if (position != null) {
      _buildMode.build(position);
      updateHighlightedTile(position);
    }
    super.onTapUp(info);
  }

  /// Right-click handler
  @override
  void onSecondaryTapUp(TapUpInfo info) {
    final position = _screenCoordinatesToGlobal(info.eventPosition.global);
    if (position != null) {
      _buildMode.destroy(position);
      updateHighlightedTile(position);
    }
    super.onSecondaryTapUp(info);
  }

  @override
  void onPointerMove(PointerMoveEvent event) {
    final position = _screenCoordinatesToGlobal(event.devicePosition);
    if (position != null) {
      updateHighlightedTile(position);
    }
    super.onPointerMove(event);
  }
}
