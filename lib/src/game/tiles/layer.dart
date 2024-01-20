import 'dart:async';

import 'package:flame/components.dart';

import '../game.dart';
import '../world.dart';
import 'coordinates.dart';
import 'tile.dart';

/// Thrown when a tile is not found at the given coordinates.
final class TileNotFound implements Exception {
  final TileCoordinates coordinates;

  const TileNotFound(this.coordinates) : super();

  @override
  String toString() => 'No tile at $coordinates';
}

/// Thrown when a tile already exists at the given coordinates.
final class TileAlreadyExists implements Exception {
  final TileCoordinates coordinates;

  TileAlreadyExists(this.coordinates);

  @override
  String toString() => 'Tile already exists at $coordinates';
}

extension LayerTileCoordinates on TileCoordinates {
  /// Gets the [TileCoordinates] associated with a given array index.
  static TileCoordinates fromArrayIndex(int index) => TileCoordinates(
      (index % SustainaCityWorld.mapSize) - (SustainaCityWorld.mapSize ~/ 2),
      (index ~/ SustainaCityWorld.mapSize) - (SustainaCityWorld.mapSize ~/ 2));

  /// Converts the coordinates to an array index for the _tiles array in [Layer]
  int toArrayIndex() =>
      (y + SustainaCityWorld.mapSize ~/ 2) * SustainaCityWorld.mapSize +
      (x + SustainaCityWorld.mapSize ~/ 2);
}

/// Represents a single z-axis layer of tiles.
final class Layer<T extends Tile> extends Component
    with HasGameRef<SustainaCityGame> {
  final List<T?> _tiles;

  /// Creates a new layer, calling [tileGenerator] to populate each tile.
  Layer(T? Function(TileCoordinates) tileGenerator)
      : _tiles = List.generate(
            SustainaCityWorld.mapSize * SustainaCityWorld.mapSize,
            (index) =>
                tileGenerator(LayerTileCoordinates.fromArrayIndex(index)));

  @override
  FutureOr<void> onLoad() async {
    for (final tile in _tiles) {
      if (tile != null) {
        await add(tile);
      }
    }
    return super.onLoad();
  }

  /// Returns the tile at the given coordinates.
  T? get(TileCoordinates coordinates) => _tiles[coordinates.toArrayIndex()];

  /// Removes the tile at the given coordinates.
  T removeTile(TileCoordinates coordinates) {
    final oldTile = get(coordinates);
    if (oldTile == null) {
      throw TileNotFound(coordinates);
    } else {
      oldTile.forEachUnit((coordinates) {
        if (get(coordinates) == null) {
          throw TileNotFound(coordinates);
        } else {
          _tiles[coordinates.toArrayIndex()] = null;
        }
      });
      remove(oldTile);
      return oldTile;
    }
  }

  /// Sets the tile at the given coordinates.
  void setTile(T tile) {
    // Check if the new tile would overlap with an existing tile.
    tile.forEachUnit((coordinates) {
      if (get(coordinates) != null) {
        throw TileAlreadyExists(coordinates);
      }
    });

    // Once we know that the new tile is valid, add it to the layer.
    tile.forEachUnit(
        (coordinates) => _tiles[coordinates.toArrayIndex()] = tile);

    // Add the tile to the flame component list.
    add(tile);
  }
}
