import 'ground.dart';

final class Grass extends Ground {
  Grass(super.coordinates) : super();

  @override
  String get spritePath => 'TileA5.png';

  @override
  int get srcTileHeight => 1;

  @override
  int get srcTileWidth => 1;

  @override
  int get srcTileOffsetX => 0;

  @override
  int get srcTileOffsetY => 0;
}
