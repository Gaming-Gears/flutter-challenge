import 'building.dart';
import 'factory.dart';

abstract base class House extends Building {
  Factory? powerSource;

  House(super.coordinates) : super();

  double get powerConsumption;
}

final class SmallHouse extends House {
  SmallHouse(super.coordinates) : super();

  @override
  String get spritePath => 'suburbs2_TileB.png';

  @override
  int get widthUnits => 5;

  @override
  int get tileHeight => 10;

  @override
  int get srcTileOffsetX => 0;

  @override
  int get srcTileOffsetY => 0;

  @override
  double get price => 100;

  @override
  double get powerConsumption => 1;
}

final class LargeHouse extends House {
  LargeHouse(super.coordinates) : super();

  @override
  String get spritePath => 'suburbs_TileE.png';

  @override
  int get widthUnits => 8;

  @override
  int get tileHeight => 10;

  @override
  int get srcTileOffsetX => 0;

  @override
  int get srcTileOffsetY => 6;

  @override
  double get price => 200;

  @override
  double get powerConsumption => 2;
}
