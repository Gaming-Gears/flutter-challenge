import 'building.dart';
import 'house.dart';

const kPowerProduction = 10.0;

final class Factory extends Building {
  final List<House> connectedHouses = [];

  Factory(super.coordinates) : super();

  @override
  String get spritePath => 'factory.png';

  @override
  int get tileHeight => 24;

  @override
  int get widthUnits => 36;

  @override
  int get srcTileOffsetX => 0;

  @override
  int get srcTileOffsetY => 0;

  @override
  double get price => 100;
}
