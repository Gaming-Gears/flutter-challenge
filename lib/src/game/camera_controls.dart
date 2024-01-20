import 'dart:ui';

import 'package:flame/components.dart';

class CameraController {
  late CameraComponent camera;
  final Vector2 worldBounds;

  CameraController(this.worldBounds);

  void attachCamera(CameraComponent camera) {
    this.camera = camera;
  }

  void moveTo(Vector2 newPosition) {
    camera.viewport.position = Vector2(
      newPosition.x.clamp(
          0, worldBounds.x - camera.viewport.size.x / camera.viewfinder.zoom),
      newPosition.y.clamp(
          0, worldBounds.y - camera.viewport.size.y / camera.viewfinder.zoom),
    );
  }

  void zoom(double zoomChange) {
    camera.viewfinder.zoom =
        (camera.viewfinder.zoom + zoomChange).clamp(0.5, 2.0);
  }

  void clampCameraToMapSize() {
    final double maxX =
        worldBounds.x - camera.viewport.size.x / camera.viewfinder.zoom;
    final double maxY =
        worldBounds.y - camera.viewport.size.y / camera.viewfinder.zoom;
  }
}
