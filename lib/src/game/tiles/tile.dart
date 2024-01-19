import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';

import '../game.dart';
import '../world.dart';

abstract base class Tile extends SpriteComponent
    with
        HoverCallbacks,
        TapCallbacks,
        HasGameRef<SustainaCity>,
        HasWorldReference<SustainaCityWorld> {
  static const tileSize = 32.0;

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

  @override
  void onHoverEnter() {
    gameRef.hoveredTiles.add((tileX, tileY));
  }

  @override
  void onHoverExit() {
    gameRef.hoveredTiles.remove((tileX, tileY));
  }

  @override
  void onTapUp(TapUpEvent event) {
    world.buildHouse(tileX, tileY);
    super.onTapUp(event);
  }
}
