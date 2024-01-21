import 'building.dart';

final class Factory extends Building {
  Factory(super.coordinates) : super();

  @override
  String get spritePath => 'factory.png';

  @override
  int get tileHeight => 24;

  @override
  int get tileWidth => 35;

  @override
  int get srcTileOffsetX => 0;

  @override
  int get srcTileOffsetY => 0;

  @override
  double get price => 100;
}
