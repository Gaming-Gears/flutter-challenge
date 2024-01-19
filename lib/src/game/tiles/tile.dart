import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:flutter/painting.dart';

import '../game.dart';
import 'coordinates.dart';

abstract base class Tile extends SpriteComponent
    with HoverCallbacks, TapCallbacks, HasGameRef<SustainaCityGame> {
  static const tileSize = 32.0;
  static const hoverColor = Color.fromARGB(255, 251, 219, 67);
  static const hoverOpacity = 0.2;

  final TileCoordinates coordinates;

  Tile(this.coordinates, {required int priority})
      : super(
          priority: priority,
          position: Vector2(
            coordinates.tileX * tileSize,
            coordinates.tileY * tileSize,
          ),
        ) {
    paint.isAntiAlias = false;
  }

  String get spritePath;
  int get srcTileOffsetX;
  int get srcTileOffsetY;
  int get srcTileWidth;
  int get srcTileHeight;

  void forEachUnit(void Function(TileCoordinates coordinates) callback) {
    for (int x = coordinates.tileX; x < coordinates.tileX + srcTileWidth; x++) {
      for (int y = coordinates.tileY;
          y < coordinates.tileY + srcTileHeight;
          y++) {
        callback(TileCoordinates(x, y));
      }
    }
  }

  @override
  FutureOr<void> onLoad() async {
    sprite = Sprite(
      await Flame.images.load(spritePath),
      srcSize: Vector2(srcTileWidth * tileSize, srcTileHeight * tileSize),
      srcPosition:
          Vector2(srcTileOffsetX * tileSize, srcTileOffsetY * tileSize),
    );
    return await super.onLoad();
  }

  void highlight() => paint.colorFilter =
      ColorFilter.mode(hoverColor.withOpacity(hoverOpacity), BlendMode.srcATop);

  void unhighlight() => paint.colorFilter =
      ColorFilter.mode(hoverColor.withOpacity(0), BlendMode.srcATop);

  @override
  void onHoverEnter() {
    final currentlyHovered = game.hoveredTile;
    if (currentlyHovered == null ||
        currentlyHovered.priority <= priority ||
        !Rect.fromLTWH(
                currentlyHovered.coordinates.tileX.toDouble(),
                currentlyHovered.coordinates.tileX.toDouble(),
                currentlyHovered.srcTileWidth.toDouble(),
                currentlyHovered.srcTileHeight.toDouble())
            .contains(Offset(
                coordinates.tileX.toDouble(), coordinates.tileX.toDouble()))) {
      game.hoveredTile?.unhighlight();
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
