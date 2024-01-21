import 'dart:async';

import 'package:flame/components.dart';

import 'tiles/buildings/building.dart';
import 'tiles/ground/grass.dart';
import 'tiles/ground/ground.dart';
import 'tiles/layer.dart';
import 'tiles/tile.dart';

final class SustainaCityWorld extends World {
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

  /// This layer houses all the ground tiles.
  final groundLayer = Layer<Ground>(Grass.new, priority: 0);

  /// Buildings are placed on this layer.
  final buildingLayer = Layer<Building>((_) => null, priority: 1);

  /// All the layers in the world.
  late final layers = <Layer<Tile>>[groundLayer, buildingLayer];

  /// Maps tile types to the layers they should go in.
  final tileToLayer = <Type, Layer>{};

  /// The tile that the mouse is currently hovering over. Null if the mouse
  /// leaves the game area.
  Tile<Object?>? hoveredTile;

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
}
