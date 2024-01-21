import 'package:flame/components.dart';

import 'world.dart';

extension CameraControls on CameraComponent {
  static const maxZoom = 3.0;
  static const minZoom = 0.5;
  static const zoomSpeed = 0.003;

  /// Clamps the camera position to the bounds of the map.
  void _clampPosition() {
    final bounds = SustainaCityWorld.mapSizePixels * viewfinder.zoom / 2;
    viewport.position.clampScalar(-bounds, bounds);
  }

  /// Moves the camera to the specified position.
  void pan(Vector2 newPosition) {
    viewport.position = newPosition;
    _clampPosition();
  }

  /// Zooms the camera in or out.
  void zoom(double zoomChange) {
    viewfinder.zoom =
        (viewfinder.zoom + zoomChange * zoomSpeed).clamp(minZoom, maxZoom);
    _clampPosition();
  }
}
