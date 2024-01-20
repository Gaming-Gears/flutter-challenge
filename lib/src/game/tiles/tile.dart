import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:flutter/painting.dart';

import '../game.dart';
import 'coordinates.dart';

/// The "MOTHER OF ALL TILES"
abstract base class Tile extends SpriteComponent
    with HoverCallbacks, TapCallbacks, HasGameRef<SustainaCityGame> {
  /// Pixel size of a single unit
  static const unitSize = 32.0;

  /// The tint of the sprite when hovered over
  static const hoverColor = Color.fromARGB(255, 251, 219, 67);

  /// The opacity of the tint of the sprite when hovered over
  static const hoverOpacity = 0.2;

  /// The coordinates of the tile
  final TileCoordinates coordinates;

  /// Priority is the z-index of the tile. Higher priority tiles are drawn on
  /// top of lower priority tiles.
  Tile(this.coordinates, {required int priority})
      : super(
          priority: priority,
          position: Vector2(
            coordinates.x * unitSize,
            coordinates.y * unitSize,
          ),
        ) {
    paint.isAntiAlias = false;
  }

  /// The path to the sprite sheet
  String get spritePath;

  /// The offset (measured in units) of the sprite within the sprite sheet
  int get srcTileOffsetX;

  /// The offset (measured in units) of the sprite within the sprite sheet
  int get srcTileOffsetY;

  /// The width (measured in units) of the sprite
  int get tileWidth;

  /// The height (measured in units) of the sprite
  int get tileHeight;

  /// Iterate through each unit in the [Tile], calling [callback] on each one.
  void forEachUnit(
      void Function(
        TileCoordinates coordinates,
        VoidCallback breakLoop,
      ) callback) {
    bool breakLoop = false;
    void breakLoopCallback() => breakLoop = true;

    for (int x = coordinates.x; x < coordinates.x + tileWidth; x++) {
      for (int y = coordinates.y; y < coordinates.y + tileHeight; y++) {
        callback(TileCoordinates(x, y), breakLoopCallback);
        if (breakLoop) {
          return;
        }
      }
    }
  }

  @override
  FutureOr<void> onLoad() async {
    sprite = Sprite(
      await Flame.images.load(spritePath),
      srcSize: Vector2(tileWidth * unitSize, tileHeight * unitSize),
      srcPosition:
          Vector2(srcTileOffsetX * unitSize, srcTileOffsetY * unitSize),
    );
    return await super.onLoad();
  }

  /// Tints the sprite to [hoverColor]
  void highlight() => paint.colorFilter =
      ColorFilter.mode(hoverColor.withOpacity(hoverOpacity), BlendMode.srcATop);

  /// Removes the tint from the sprite
  void unhighlight() => paint.colorFilter =
      ColorFilter.mode(hoverColor.withOpacity(0), BlendMode.srcATop);

  @override
  void onHoverEnter() {
    final currentlyHovered = game.hoveredTile;
    if (
        // If no tile is currently hovered over, highlight this tile
        currentlyHovered == null ||
            // If this tile has a higher priority than the currently
            // hovered tile, highlight this tile
            currentlyHovered.priority <= priority ||
            // If this tile is not contained within the currently hovered
            // tile, highlight this tile
            !Rect.fromLTWH(
                    currentlyHovered.coordinates.x.toDouble(),
                    currentlyHovered.coordinates.y.toDouble(),
                    currentlyHovered.tileWidth.toDouble(),
                    currentlyHovered.tileHeight.toDouble())
                .contains(Offset(
                    coordinates.x.toDouble(), coordinates.y.toDouble()))) {
      currentlyHovered?.unhighlight();
      game.hoveredTile = this;
      highlight();
    }
  }

  @override
  void onHoverExit() {
    if (game.hoveredTile == this) {
      game.hoveredTile = null;
      unhighlight();
    }
  }
}
