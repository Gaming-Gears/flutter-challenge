import '../tile.dart';

abstract base class Building extends Tile {
  Building(super.tileX, super.tileY) : super(zIndex: 1);
}
