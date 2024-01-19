import '../tile.dart';

abstract base class Ground extends Tile {
  Ground(super.coordinates) : super(priority: 0);
}
