import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flutter/painting.dart';

import '../world.dart';

abstract base class Tile extends SpriteComponent
    with HoverCallbacks, TapCallbacks, HasWorldReference<SustainaCityWorld> {
  static const tileSize = 32.0;
  static const hoverColor = Color.fromARGB(255, 251, 219, 67);
  static const hoverOpacity = 0.2;

  final int tileX;
  final int tileY;
  final int zIndex;

  Tile(this.tileX, this.tileY, {required this.zIndex})
      : super(
          priority: zIndex,
          position: Vector2(
            tileX * tileSize,
            tileY * tileSize,
          ),
        ) {
    paint.isAntiAlias = false;
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

  String get spritePath;
  int get srcTileOffsetX;
  int get srcTileOffsetY;
  int get srcTileWidth;
  int get srcTileHeight;

  void highlight() {
    paint.colorFilter = ColorFilter.mode(
        hoverColor.withOpacity(hoverOpacity), BlendMode.srcATop);
  }

  void unhighlight() {
    paint.colorFilter =
        ColorFilter.mode(hoverColor.withOpacity(0), BlendMode.srcATop);
  }

  @override
  void onHoverEnter() {
    if (world.hoveredTile == null || world.hoveredTile!.priority <= priority) {
      world.hoveredTile?.unhighlight();
      world.hoveredTile = this;
      highlight();
    }
  }

  @override
  void onHoverExit() {
    if (world.hoveredTile == this) {
      world.hoveredTile = null;
    }
    unhighlight();
  }

  @override
  void onTapUp(TapUpEvent event) {
    world.buildHouse(tileX, tileY);
    super.onTapUp(event);
  }
}
