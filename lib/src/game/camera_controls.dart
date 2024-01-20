import 'package:flame/components.dart';

class CameraController {
  late CameraComponent camera;
  final Vector2 worldBounds;

  CameraController(this.worldBounds);

  /// Attaches the camera to the game.
  void attachCamera(CameraComponent camera) {
    this.camera = camera;
  }

  /// Moves the camera to the specified position.
  void moveTo(Vector2 newPosition) {
    try {
      camera.viewport.position = Vector2(
        newPosition.x.clamp(
            0, worldBounds.x - camera.viewport.size.x / camera.viewfinder.zoom),
        newPosition.y.clamp(
            0, worldBounds.y - camera.viewport.size.y / camera.viewfinder.zoom),
      );
    } on Exception catch (e) {
      throw CameraControllerException(e);
    }
  }

  /// Zooms the camera in or out.
  void zoom(double zoomChange) {
    try {
      camera.viewfinder.zoom =
          (camera.viewfinder.zoom + zoomChange).clamp(0.5, 2.0);
    } on Exception catch (e) {
      throw CameraControllerException(e);
    }
  }

  /// Clamps the camera to the map size.
  void clampCameraToMapSize() {
    try {
      final double maxX =
          worldBounds.x - camera.viewport.size.x / camera.viewfinder.zoom;
      final double maxY =
          worldBounds.y - camera.viewport.size.y / camera.viewfinder.zoom;
    } on Exception catch (e) {
      throw CameraControllerException(e);
    }
  }
}

/// Thrown when the camera controller is unable to move the camera.
final class CameraControllerException implements Exception {
  final dynamic message;
  const CameraControllerException(this.message) : super();
  @override
  String toString() =>
      'An error occurred while trying to move the camera. message: $message';
}
