import 'dart:async';

import 'package:flame/components.dart';

import '../logger.dart';
import 'game.dart';
import 'tiles/buildings/building.dart';
import 'tiles/coordinates.dart';
import 'tiles/ground/grass.dart';
import 'tiles/ground/ground.dart';
import 'tiles/layer.dart';
import 'tiles/tile.dart';

final class SustainaCityWorld extends World with HasGameRef<SustainaCityGame> {
  /// The width/height of the map (measured in units).
  static const mapSize = 100;

  /// The bounds of the map in the tile coordinate system (measured in units).
  static const mapBounds = mapSize ~/ 2;

  /// The width/height of the map (measured in pixels).
  static const mapSizePixels = mapSize * Tile.unitSize;

  /// The amount of money the player earns per second.
  static const moneyRate = 3.0;

  /// The amount of money the player starts with.
  static const initialMoney = 100.0;

  /// The percentage the player gets back when destroying a building.
  static const destroyRefund = 0.8;

  /// This layer houses all the ground tiles.
  final groundLayer = Layer<Ground>(Grass.new, priority: 0);

  /// Buildings are placed on this layer.
  final buildingLayer = Layer<Building>((_) => null, priority: 1);

  /// All the layers in the world.
  late final layers = <Layer<Tile>>[groundLayer, buildingLayer];

  /// The amount of money the player has.
  double money = initialMoney;

  SustainaCityWorld() : super();

  @override
  FutureOr<void> onLoad() async {
    await add(groundLayer);
    await add(buildingLayer);
    return await super.onLoad();
  }

  @override
  void update(double dt) {
    money += moneyRate * dt;
    super.update(dt);
  }

  /// Builds a [Building] on the [buildingLayer].
  void build(Building building) {
    if (money < building.price) {
      error('Need \$${building.price}, but only have \$$money');
    } else {
      bool built = false;
      try {
        built = buildingLayer.setTile(building);
      } on CoordinatesOutOfBounds catch (e) {
        error(e.toString());
      }
      if (built) {
        gameRef.hoveredTile?.unhighlight();
        gameRef.hoveredTile = building;
        building.highlight();
        money -= building.price;
      }
    }
  }

  /// Destroys the [Building] on the [buildingLayer] at [coordinates], then
  /// highlights the tile at [mouseCoordinates].
  void destroy(TileCoordinates coordinates, TileCoordinates mouseCoordinates) {
    final oldBuilding = buildingLayer.removeTile(coordinates);
    if (oldBuilding != null) {
      // Unhighlight the destroy building
      gameRef.hoveredTile?.unhighlight();

      // Highlight the tile under the mouse
      int highestPriority = -1;
      Tile? hoveredTile;
      for (final layer in layers) {
        if (layer.priority > highestPriority) {
          final tile = layer.get(mouseCoordinates);
          if (tile != null) {
            hoveredTile = tile;
            highestPriority = layer.priority;
          }
        }
      }
      if (hoveredTile != null) {
        gameRef.hoveredTile = hoveredTile;
        hoveredTile.highlight();
      }

      // Refund the player for a portion of the building's price
      money += oldBuilding.price * destroyRefund;
    }
  }
}
