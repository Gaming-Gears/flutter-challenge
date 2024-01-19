import 'package:flame/components.dart';
import 'package:flame/events.dart';

import '../world.dart';
import 'tile.dart';

final class CoordinatesOutOfBounds implements Exception {
  final int x;
  final int y;

  const CoordinatesOutOfBounds(this.x, this.y) : super();

  @override
  String toString() => 'Coordinates out of bounds: $x, $y';
}

final class ScreenCoordinates {
  final double x;
  final double y;

  const ScreenCoordinates(this.x, this.y) : super();

  factory ScreenCoordinates.fromTap(TapUpInfo info) => ScreenCoordinates(
      info.eventPosition.global.x, info.eventPosition.global.y);

  TileCoordinates toTileCoordinates(Vector2 canvasSize) => TileCoordinates(
        (x - 0.5 * canvasSize.x) ~/ Tile.tileSize,
        (y - 0.5 * canvasSize.y) ~/ Tile.tileSize,
      );

  @override
  String toString() => '$x, $y';
}

final class TileCoordinates {
  final int tileX;
  final int tileY;

  TileCoordinates(this.tileX, this.tileY) {
    if (tileX.abs() > SustainaCityWorld.mapSize ~/ 2 ||
        tileY.abs() > SustainaCityWorld.mapSize ~/ 2) {
      throw CoordinatesOutOfBounds(tileX, tileY);
    }
  }

  ArrayIndexCoordinates toArrayIndexCoordinates() => ArrayIndexCoordinates(
        tileX + SustainaCityWorld.mapSize ~/ 2,
        tileY + SustainaCityWorld.mapSize ~/ 2,
      );

  @override
  String toString() => '$tileX, $tileY';
}

final class ArrayIndexCoordinates {
  final int xIndex;
  final int yIndex;

  ArrayIndexCoordinates(this.xIndex, this.yIndex) {
    if (xIndex < 0 ||
        xIndex >= SustainaCityWorld.mapSize ||
        yIndex < 0 ||
        yIndex >= SustainaCityWorld.mapSize) {
      throw CoordinatesOutOfBounds(xIndex, yIndex);
    }
  }

  TileCoordinates toTileCoordinates() => TileCoordinates(
        xIndex - SustainaCityWorld.mapSize ~/ 2,
        yIndex - SustainaCityWorld.mapSize ~/ 2,
      );

  @override
  String toString() => '$xIndex, $yIndex';
}
