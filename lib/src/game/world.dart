import 'dart:async';

import 'package:flame/components.dart';

import '../logger.dart';
import 'camera_controls.dart';
import 'game.dart';
import 'tiles/buildings/building.dart';
import 'tiles/coordinates.dart';
import 'tiles/ground/grass.dart';
import 'tiles/layer.dart';

final class SustainaCityWorld extends World with HasGameRef<SustainaCityGame> {
  /// The width/height of the map (measured in units).
  static const mapSize = 100;

  /// The amount of money the player earns per second.
  static const moneyRate = 3.0;

  /// The amount of money the player starts with.
  static const initialMoney = 100.0;

  /// The percentage the player gets back when destroying a building.
  static const destroyRefund = 0.8;

  /// This layer houses all the ground tiles.
  final groundLayer = Layer((coordinates) => Grass(coordinates));

  /// Buildings are placed on this layer.
  final buildingLayer = Layer<Building>((_) => null);

  /// The amount of money the player has.
  double money = initialMoney;

  /// The camera controller attached to the game.
  late CameraController cameraController;

  SustainaCityWorld() : super();

  @override
  FutureOr<void> onLoad() async {
    await add(groundLayer);
    await add(buildingLayer);

    /// example for bounds we need to change to map size in the future

    final Vector2 worldBounds = game.size;

    /// Initialize the camera controller
    cameraController = CameraController(worldBounds);

    /// Attach the camera to the game
    cameraController.attachCamera(game.camera);
    return super.onLoad();
  }

  @override
  void update(double dt) {
    money += moneyRate * dt;
    super.update(dt);
  }

  void build(Building tile) {
    if (money < tile.price) {
      error('Need \$${tile.price}, but only have \$$money');
    } else {
      bool built = false;
      try {
        built = buildingLayer.setTile(tile);
      } on CoordinatesOutOfBounds catch (e) {
        error(e.toString());
      }
      if (built) {
        gameRef.hoveredTile?.unhighlight();
        gameRef.hoveredTile = tile;
        tile.highlight();
        money -= tile.price;
      }
    }
  }

  void destroy(
      TileCoordinates coordinates, TileCoordinates newMouseCoordinates) {
    final oldBuilding = buildingLayer.removeTile(coordinates);
    if (oldBuilding != null) {
      gameRef.hoveredTile = groundLayer.get(newMouseCoordinates);
      if (gameRef.hoveredTile != null) {
        gameRef.hoveredTile!.highlight();
      }
      money += oldBuilding.price * destroyRefund;
    }
  }
}
