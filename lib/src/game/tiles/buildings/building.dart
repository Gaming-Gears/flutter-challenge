import '../tile.dart';

/// Represents a building that can be placed on the map.
abstract base class Building extends Tile {
  /// The price to build the building
  double get price;

  Building(super.coordinates) : super(priority: 1);
}
