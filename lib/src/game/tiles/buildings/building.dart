import '../tile.dart';

abstract base class Building extends Tile {
  Building(super.coordinates) : super(priority: 1);
}
