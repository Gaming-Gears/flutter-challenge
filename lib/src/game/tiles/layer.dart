import 'dart:async';

import 'package:flame/components.dart';

import '../../lazy.dart';
import '../../logger.dart';
import '../camera.dart';
import '../game.dart';
import '../world.dart';
import 'coordinates.dart';
import 'tile.dart';

/// Thrown when a tile is not found at the given coordinates but it should be.
/// This should only happen if there is an error with the code.
final class TileNotFound {
  final UnitCoordinates coordinates;

  const TileNotFound(this.coordinates) : super();

  @override
  String toString() => 'No tile at $coordinates';
}

final class LayerNotAddedToArray implements Exception {
  final Layer layer;

  const LayerNotAddedToArray(this.layer) : super();

  @override
  String toString() =>
      'Layer $layer was not added to the layers array. Current layers array: '
      '${layer.world.layers}';
}

extension LayerArrayIndices on UnitCoordinates {
  /// Gets the [UnitCoordinates] associated with a given array index.
  static UnitCoordinates fromArrayIndex(int index) => UnitCoordinates(
        (index % kMapSize) - kMapBounds,
        (index ~/ kMapSize) - kMapBounds,
      );

  /// Converts the coordinates to an array index for the _tiles array in [Layer]
  int toArrayIndex() => (y + kMapBounds) * kMapSize + (x + kMapBounds);
}

/// Represents a single z-axis layer of tiles.
final class Layer<T extends Tile<T>> extends Component
    with HasWorldReference<SustainaCityWorld>, HasGameRef<SustainaCityGame> {
  final T? Function(UnitCoordinates coordinates) initialTileGenerator;
  late final List<Lazy<T?>> tiles;

  /// Creates a new layer, calling [initialTileGenerator] to populate each tile.
  Layer(this.initialTileGenerator) : super();

  @override
  FutureOr<void> onLoad() async {
    priority = world.layers.indexOf(this);
    if (priority == -1) {
      throw LayerNotAddedToArray(this);
    }
    world.tileToLayer[T] = this;
    tiles = List.generate(
        kMapSize * kMapSize,
        (index) => Lazy(() =>
            initialTileGenerator(LayerArrayIndices.fromArrayIndex(index))));
    final halfRenderBounds = gameRef.camera.halfRenderBounds();
    for (int y = -halfRenderBounds.y; y <= halfRenderBounds.y; ++y) {
      for (int x = -halfRenderBounds.x; x <= halfRenderBounds.x; ++x) {
        final tile = get(UnitCoordinates(x, y));
        if (tile != null) {
          await add(tile);
        }
      }
    }
    return await super.onLoad();
  }

  /// Returns the tile at the given coordinates.
  T? get(UnitCoordinates coordinates) =>
      tiles[coordinates.toArrayIndex()].value;

  /// Removes and returns the tile at the given coordinates. Returns null if no
  /// tile was found.
  T? removeTile(UnitCoordinates coordinates) =>
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
          final existingTile = get(coordinates);
          if (existingTile != null) {
            error('Tried to build at $coordinates but tile already exists, '
                'existing tile: $existingTile');
            overlaps = true;
            breakLoop();
          }
        },
      );
      // This will occur if the player tries to build on the edge of the map.
      // This is an expected error and should be caught and handled.
    } on CoordinatesOutOfBounds catch (e) {
      error('Tried to place $tile but $e');
      return false;
    }

    // If the new tile would not overlap with an existing tile, add it to the
    // layer.
    if (!overlaps) {
      // Once we know that the new tile is valid, add it to the layer.
      tile.forEachUnit(
          (coordinates, _) => tiles[coordinates.toArrayIndex()].value = tile);

      // Add the tile to the flame component list.
      add(tile);
      return true;
    }
    return false;
  }
}
