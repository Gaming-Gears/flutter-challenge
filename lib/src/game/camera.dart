import 'package:flame/components.dart';

import 'tiles/coordinates.dart';
import 'tiles/layer.dart';
import 'tiles/tile.dart';
import 'world.dart';

const kMaxZoom = 3.0;
const kMinZoom = 0.75;
const kZoomSpeed = 0.07;
const kLerpFactor = 0.05;

extension SustainaCityCamera on CameraComponent {
  /// Clamps the camera position to the bounds of the map.
  void _clampPosition() => viewport.position.clampScalar(
      -kMapBounds * Tile.pixelSize * viewfinder.zoom + 1,
      kMapBounds * Tile.pixelSize * viewfinder.zoom);

  /// Returns [position] scaled with [zoom] in units.
  static UnitCoordinates _globalPixelCoordinatesToUnits(
          Vector2 position, double zoom) =>
      (position / (Tile.pixelSize * zoom)).toUnits();

  /// Returns half [size] scaled with [zoom] in units, with an extra padding.
  static UnitCoordinates _halfRenderBounds(Vector2 size, double zoom) =>
      _globalPixelCoordinatesToUnits(size, zoom * 2) +
      (UnitCoordinates(1, 1), checkBounds: false);

  /// Returns half the screen size scaled with the zoom of the camera in units.
  UnitCoordinates halfRenderBounds() =>
      _halfRenderBounds(viewport.size, viewfinder.zoom);

  /// Calls [callback] for each tile in the range [topLeft], [bottomRight] but
  /// not in the range [maskTopLeft], [maskBottomRight].
  ///
  /// [callback] should return true if the tile was handled, or false otherwise.
  static void _updateRenderedTilesHelper(
    UnitCoordinates topLeft,
    UnitCoordinates bottomRight,
    UnitCoordinates maskTopLeft,
    UnitCoordinates maskBottomRight,
    Layer layer,
    bool Function(Tile<dynamic> coordinates) callback,
  ) {
    final checkedCoordinates = <String>{};
    for (int y = topLeft.y; y <= bottomRight.y; ++y) {
      for (int x = topLeft.x; x <= bottomRight.x; ++x) {
        final coordinates = UnitCoordinates(x, y);
        if (!checkedCoordinates.contains(coordinates.toString())) {
          if (x < maskTopLeft.x ||
              x > maskBottomRight.x ||
              y < maskTopLeft.y ||
              y > maskBottomRight.y) {
            final tile = layer.get(coordinates);
            if (tile != null && callback(tile)) {
              tile.forEachUnit((coordinates, breakLoop) =>
                  checkedCoordinates.add(coordinates.toString()));
            }
          } else {
            x = maskBottomRight.x;
          }
        }
      }
    }
  }

  /// Hides/shows the tiles that should be hidden/revealed when the camera moves
  void _updateRenderedTiles(Vector2 oldPosition, double oldZoom) {
    // Half of the new local bounds of the viewport in units (half the width/height)
    final halfBounds = halfRenderBounds();

    // The new position of the camera in units
    final positionUnits =
        _globalPixelCoordinatesToUnits(-viewport.position, viewfinder.zoom);

    // Move the background so that it is centered on the camera
    final theWorld = world as SustainaCityWorld;
    theWorld.background.updatePosition(positionUnits);

    // Half the old local bounds of the viewport in units
    final oldHalfBounds = _halfRenderBounds(viewport.size, oldZoom);

    // The old position of the camera in units
    final oldPositionUnits =
        _globalPixelCoordinatesToUnits(-oldPosition, oldZoom);

    // Calculate the new global viewport bounds in units
    final topLeft = ((positionUnits - (halfBounds, checkBounds: false)))
        .clampScalar(-kMapBounds, kMapBounds - 1);
    final bottomRight = ((positionUnits + (halfBounds, checkBounds: false))
        .clampScalar(-kMapBounds, kMapBounds - 1));

    // Calculate the old global viewport bounds in units
    final oldTopLeft =
        ((oldPositionUnits - (oldHalfBounds, checkBounds: false)))
            .clampScalar(-kMapBounds, kMapBounds - 1);
    final oldBottomRight =
        ((oldPositionUnits + (oldHalfBounds, checkBounds: false))
            .clampScalar(-kMapBounds, kMapBounds - 1));

    for (final layer in theWorld.layers) {
      // Hide the tiles that are no longer in the viewport
      _updateRenderedTilesHelper(
          oldTopLeft, oldBottomRight, topLeft, bottomRight, layer, (tile) {
        bool inBounds = false;
        tile.forEachUnit((coordinates, breakLoop) {
          if (coordinates.x >= topLeft.x &&
              coordinates.x <= bottomRight.x &&
              coordinates.y >= topLeft.y &&
              coordinates.y <= bottomRight.y) {
            inBounds = true;
            breakLoop();
          }
        });
        if (!inBounds) {
          layer.remove(tile);
          return true;
        }
        return false;
      });

      // Show the tiles that are now in the viewport
      _updateRenderedTilesHelper(
          topLeft, bottomRight, oldTopLeft, oldBottomRight, layer, (tile) {
        layer.add(tile);
        return true;
      });
    }
  }

  /// Moves the camera to the specified position.
  void pan(Vector2 newPosition) {
    final oldPosition = viewport.position.clone();
    viewport.position = newPosition;
    _clampPosition();
    _updateRenderedTiles(oldPosition, viewfinder.zoom);
  }

  /// Zooms the camera in or out.
  void zoom(double zoomChange) {
    final oldPosition = viewport.position.clone();
    final oldZoom = viewfinder.zoom;
    viewfinder.zoom =
        (viewfinder.zoom + zoomChange * kZoomSpeed).clamp(kMinZoom, kMaxZoom);
    _clampPosition();
    _updateRenderedTiles(oldPosition, oldZoom);
  }

  /// Moves the camera to the specified position and zooms in or out.
  void zoomToCursor(double zoomChange, Vector2 mousePosition) {
    double newZoom = viewfinder.zoom + zoomChange * kZoomSpeed;
    newZoom = newZoom.clamp(kMinZoom, kMaxZoom);

    if (newZoom != viewfinder.zoom || viewport.position != -mousePosition) {
      final oldPosition = viewport.position.clone();
      final oldZoom = viewfinder.zoom;

      // Calculate target position for the camera
      Vector2 targetPosition = -mousePosition + viewport.size / 2;

      // Apply linear interpolation for smooth zooming
      viewfinder.zoom = lerp(oldZoom, newZoom, kLerpFactor);

      // Smoothly pan the camera to keep the cursor in focus
      viewport.position = lerpVector2(oldPosition, targetPosition, kLerpFactor);

      _clampPosition();
      _updateRenderedTiles(oldPosition, oldZoom);
    }
  }

  // Linear interpolation for double values
  double lerp(double start, double end, double t) {
    return start + (end - start) * t;
  }

  // Linear interpolation for Vector2 values
  Vector2 lerpVector2(Vector2 start, Vector2 end, double t) {
    return Vector2(
      lerp(start.x, end.x, t),
      lerp(start.y, end.y, t),
    );
  }
}
