import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';

import 'game.dart';
import 'tiles/tile.dart';

final class Cursor extends SpriteComponent with HasGameRef<SustainaCity> {
  Cursor() : super(priority: 1000);

  @override
  FutureOr<void> onLoad() async {
    sprite = Sprite(await Flame.images.load('cursor.png'),
        srcSize: Vector2(Tile.tileSize, Tile.tileSize));
    return await super.onLoad();
  }

  @override
  void update(double dt) {
    if (gameRef.hoveredTiles.isNotEmpty) {
      opacity = 1;
      position = Vector2(
        gameRef.hoveredTiles.first.$1 * Tile.tileSize,
        gameRef.hoveredTiles.first.$2 * Tile.tileSize,
      );
    } else {
      opacity = 0;
    }
    super.update(dt);
  }
}
