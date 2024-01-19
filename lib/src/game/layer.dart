import 'dart:async';

import 'package:flame/components.dart';

import 'tiles/tile.dart';

final class Layer<T extends Tile> extends Component {
  final List<List<T?>> _tiles;

  final int size;

  Layer(this.size, T? Function(int, int) tileGenerator)
      : _tiles = List.generate(
            size,
            (x) => List<T?>.generate(
                size,
                (y) => tileGenerator(
                    x - (size / 2).floor(), y - (size / 2).floor())));

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

  T? get(int x, int y) =>
      _tiles[x + (size / 2).floor()][y + (size / 2).floor()];

  void set(int x, int y, T tile) {
    final column = x + (size / 2).floor();
    final row = y + (size / 2).floor();
    final oldTile = _tiles[column][row];
    if (oldTile != null) {
      remove(oldTile);
    }
    _tiles[column][row] = tile;
    add(tile);
  }
}
