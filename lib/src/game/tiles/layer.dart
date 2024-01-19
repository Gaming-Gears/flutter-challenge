import 'dart:async';

import 'package:flame/components.dart';

import '../world.dart';
import 'coordinates.dart';
import 'tile.dart';

final class TileNotFound implements Exception {
  final TileCoordinates coordinates;

  const TileNotFound(this.coordinates) : super();

  @override
  String toString() => 'No tile at $coordinates';
}

final class TileAlreadyExists implements Exception {
  final TileCoordinates coordinates;

  TileAlreadyExists(this.coordinates);

  @override
  String toString() => 'Tile already exists at $coordinates';
}

extension<T> on List<List<T?>> {
  T? get(ArrayIndexCoordinates indices) => this[indices.xIndex][indices.yIndex];

  void set(ArrayIndexCoordinates indices, T? tile) =>
      this[indices.xIndex][indices.yIndex] = tile;
}

final class Layer<T extends Tile> extends Component {
  final List<List<T?>> _tiles;

  Layer(T? Function(TileCoordinates) tileGenerator)
      : _tiles = List.generate(
            SustainaCityWorld.mapSize,
            (x) => List<T?>.generate(
                SustainaCityWorld.mapSize,
                (y) => tileGenerator(
                    ArrayIndexCoordinates(x, y).toTileCoordinates())));

  @override
  FutureOr<void> onLoad() async {
    for (final column in _tiles) {
      for (final tile in column) {
        if (tile != null) {
          await add(tile);
        }
      }
    }
    return super.onLoad();
  }

  T? get(TileCoordinates coordinates) =>
      _tiles.get(coordinates.toArrayIndexCoordinates());

  void removeTile(TileCoordinates coordinates) {
    final oldTile = _tiles.get(coordinates.toArrayIndexCoordinates());
    if (oldTile == null) {
      throw TileNotFound(coordinates);
    } else {
      oldTile.forEachUnit((coordinates) {
        final indices = coordinates.toArrayIndexCoordinates();
        if (_tiles.get(indices) == null) {
          throw TileNotFound(coordinates);
        } else {
          _tiles.set(indices, null);
        }
      });
      remove(oldTile);
    }
  }

  void setTile(T tile) {
    tile.forEachUnit((coordinates) {
      if (_tiles.get(coordinates.toArrayIndexCoordinates()) != null) {
        throw TileAlreadyExists(coordinates);
      }
    });

    tile.forEachUnit((coordinates) =>
        _tiles.set(coordinates.toArrayIndexCoordinates(), tile));

    add(tile);
  }
}
