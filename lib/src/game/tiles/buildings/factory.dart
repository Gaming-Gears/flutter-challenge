import 'building.dart';
import 'house.dart';

final class Factory extends Building {
  final List<House> connectedHouses = [];

  Factory(super.coordinates) : super();

  static const powerProduction = 10.0;

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
