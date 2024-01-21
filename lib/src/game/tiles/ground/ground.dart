import '../tile.dart';

/// The lowest layer of tiles.
abstract base class Ground extends Tile<Ground> {
  Ground(super.coordinates) : super();
}
