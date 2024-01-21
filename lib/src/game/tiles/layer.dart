import 'dart:async';

import 'package:flame/components.dart';

import '../../logger.dart';
import '../world.dart';
import 'coordinates.dart';
import 'tile.dart';

/// Thrown when a tile is not found at the given coordinates but it should be.
/// This should only happen if there is an error with the code.
final class TileNotFound {
  final TileCoordinates coordinates;

  const TileNotFound(this.coordinates) : super();

  @override
  String toString() => 'No tile at $coordinates';
}

extension LayerTileCoordinates on TileCoordinates {
  /// Gets the [TileCoordinates] associated with a given array index.
  static TileCoordinates fromArrayIndex(int index) => TileCoordinates(
      (index % SustainaCityWorld.mapSize) - SustainaCityWorld.mapBounds,
      (index ~/ SustainaCityWorld.mapSize) - SustainaCityWorld.mapBounds);

  /// Converts the coordinates to an array index for the _tiles array in [Layer]
  int toArrayIndex() =>
      (y + SustainaCityWorld.mapBounds) * SustainaCityWorld.mapSize +
      (x + SustainaCityWorld.mapBounds);
}

/// Represents a single z-axis layer of tiles.
final class Layer<T extends Tile<T>> extends Component
    with HasWorldReference<SustainaCityWorld> {
  final T? Function(TileCoordinates coordinates) initialTileGenerator;
  late final List<T?> tiles;

  /// Creates a new layer, calling [tileGenerator] to populate each tile.
  Layer(this.initialTileGenerator, {required super.priority}) : super();

  @override
  FutureOr<void> onLoad() async {
    world.tileToLayer[T] = this;
    tiles = List.generate(
        SustainaCityWorld.mapSize * SustainaCityWorld.mapSize,
        (index) =>
            initialTileGenerator(LayerTileCoordinates.fromArrayIndex(index)));
    for (final tile in tiles) {
      if (tile != null) {
        await add(tile);
      }
    }
    return super.onLoad();
  }

  /// Returns the tile at the given coordinates.
  T? get(TileCoordinates coordinates) => tiles[coordinates.toArrayIndex()];

  /// Removes and returns the tile at the given coordinates. Returns null if no
  /// tile was found.
  T? removeTile(TileCoordinates coordinates) =>
      get(coordinates)?..removeFromLayer();

  /// Sets the tile at the given coordinates. Returns true if the tile was
  /// successfully set, false otherwise.
  bool setTile(T tile) {
    // Check if the new tile would overlap with an existing tile. `forEachUnit`
    // will exit early and return 0 if it finds a tile at the given coordinates.
    bool overlaps = false;
    try {
      tile.forEachUnit(
        (coordinates, breakLoop) {
          if (get(coordinates) != null) {
            error('Tried to build at $coordinates but tile already exists');
            overlaps = true;
            breakLoop();
          }
        },
      );
      // This will occur if the player tries to build on the edge of the map.
      // This is an expected error and should be caught and handled.
    } on CoordinatesOutOfBounds catch (e) {
      error(e.toString());
      return false;
    }

    // If the new tile would not overlap with an existing tile, add it to the
    // layer.
    if (!overlaps) {
      // Once we know that the new tile is valid, add it to the layer.
      tile.forEachUnit(
          (coordinates, _) => tiles[coordinates.toArrayIndex()] = tile);

      // Add the tile to the flame component list.
      add(tile);
      return true;
    }
    return false;
  }
}
