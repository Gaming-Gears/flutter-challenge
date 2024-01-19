import 'dart:async';

import 'package:flame/components.dart';

import '../logger.dart';
import 'game.dart';
import 'tiles/buildings/building.dart';
import 'tiles/coordinates.dart';
import 'tiles/ground/grass.dart';
import 'tiles/layer.dart';

final class SustainaCityWorld extends World with HasGameRef<SustainaCityGame> {
  /// The width/height of the map (measured in units).
  static const mapSize = 21;

  /// This layer houses all the ground tiles.
  final groundLayer = Layer((coordinates) => Grass(coordinates));

  /// Buildings are placed on this layer.
  final buildingLayer = Layer<Building>((_) => null);

  /// The amount of money the player has.
  double money = 0;

  SustainaCityWorld() : super();

  @override
  FutureOr<void> onLoad() async {
    await add(groundLayer);
    await add(buildingLayer);
    return super.onLoad();
  }

  void build(Building tile) {
    try {
      buildingLayer.setTile(tile);
      gameRef.hoveredTile?.unhighlight();
      gameRef.hoveredTile = tile;
      tile.highlight();
    } on TileAlreadyExists catch (e) {
      error(e.toString());
    } on CoordinatesOutOfBounds catch (e) {
      error(e.toString());
    }
  }

  void destroy(
      TileCoordinates coordinates, TileCoordinates newMouseCoordinates) {
    try {
      buildingLayer.removeTile(coordinates);
      gameRef.hoveredTile = groundLayer.get(newMouseCoordinates);
      if (gameRef.hoveredTile != null) {
        gameRef.hoveredTile!.highlight();
      }
    } on TileNotFound catch (e) {
      error(e.toString());
    }
  }
}
