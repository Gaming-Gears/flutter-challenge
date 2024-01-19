import 'building.dart';

final class House extends Building {
  House(super.tileX, super.tileY) : super();

  @override
  String get spritePath => 'suburbs2_TileB.png';

  @override
  int get srcTileHeight => 10;

  @override
  int get srcTileWidth => 5;

  @override
  int get srcTileOffsetX => 0;

  @override
  int get srcTileOffsetY => 0;
}
