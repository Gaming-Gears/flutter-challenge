import 'package:flame/components.dart';

import '../world.dart';

/// Thrown when coordinates are instantiated that are out of bounds.
final class CoordinatesOutOfBounds implements Exception {
  final int x;
  final int y;

  const CoordinatesOutOfBounds(this.x, this.y) : super();

  @override
  String toString() => 'Coordinates out of bounds: $x, $y';
}

/// Represents coordinates in units.
final class UnitCoordinates {
  final int x;
  final int y;

  /// Performs bounds checking on the coordinates and throws
  /// [CoordinatesOutOfBounds] if they are invalid.
  UnitCoordinates(this.x, this.y, {bool checkBounds = true}) {
    // Bounds checking in the constructor so we can always be sure that the
    // coordinates are valid.
    if (checkBounds &&
        (x < -kMapBounds ||
            x >= kMapBounds ||
            y < -kMapBounds ||
            y >= kMapBounds)) {
      throw CoordinatesOutOfBounds(x, y);
    }
  }

  Vector2 toVector2() => Vector2(x.toDouble(), y.toDouble());

  UnitCoordinates operator -() => UnitCoordinates(-x, -y);

  UnitCoordinates operator +((UnitCoordinates, {bool checkBounds}) operand) =>
      UnitCoordinates(
        x + operand.$1.x,
        y + operand.$1.y,
        checkBounds: operand.checkBounds,
      );

  UnitCoordinates operator -((UnitCoordinates, {bool checkBounds}) operand) =>
      this + (-operand.$1, checkBounds: operand.checkBounds);

  UnitCoordinates clampScalar(int min, int max, {bool checkBounds = true}) =>
      UnitCoordinates(
        x.clamp(min, max),
        y.clamp(min, max),
        checkBounds: checkBounds,
      );

  @override
  String toString() => '$x, $y';
}

extension ToUnitCoordinates on Vector2 {
  /// Converts the vector to tile coordinates.
  UnitCoordinates toUnits() => UnitCoordinates(x.floor(), y.floor());
}
