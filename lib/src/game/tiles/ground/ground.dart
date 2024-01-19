import '../tile.dart';

abstract base class Ground extends Tile {
  Ground(super.tileX, super.tileY) : super(zIndex: 0);
}
