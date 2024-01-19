import '../tile.dart';

/// The lowest layer of tiles.
abstract base class Ground extends Tile {
  Ground(super.coordinates) : super(priority: 0);
}
