import '../world.dart';

/// Thrown when coordinates are instantiated that are out of bounds.
final class CoordinatesOutOfBounds implements Exception {
  final int x;
  final int y;

  const CoordinatesOutOfBounds(this.x, this.y) : super();

  @override
  String toString() => 'Coordinates out of bounds: $x, $y';
}

/// Represents the coordinates of a tile in units.
final class TileCoordinates {
  final int x;
  final int y;

  /// Performs bounds checking on the coordinates and throws
  /// [CoordinatesOutOfBounds] if they are invalid.
  TileCoordinates(this.x, this.y) {
    // Bounds checking in the constructor so we can always be sure that the
    // coordinates are valid.
    if (x.abs() > SustainaCityWorld.mapBounds ||
        y.abs() > SustainaCityWorld.mapBounds) {
      throw CoordinatesOutOfBounds(x, y);
    }
  }

  @override
  String toString() => '$x, $y';
}
