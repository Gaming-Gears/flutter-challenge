import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';

import '../logger.dart';
import 'game.dart';
import 'tiles/buildings/building.dart';
import 'tiles/buildings/house.dart';
import 'tiles/coordinates.dart';
import 'tiles/ground/grass.dart';
import 'tiles/layer.dart';

final class SustainaCityWorld extends World with HasGameRef<SustainaCity> {
  static const mapSize = 50;

  final groundLayer = Layer((coordinates) => Grass(coordinates));
  final buildingLayer = Layer<Building>((_) => null);

  @override
  FutureOr<void> onLoad() async {
    await add(groundLayer);
    await add(buildingLayer);
    return super.onLoad();
  }

  void buildHouse(TileCoordinates coordinates) {
    final house = House(coordinates, Model.values[Random.secure().nextInt(2)]);
    try {
      buildingLayer.setTile(house);
      gameRef.hoveredTile?.unhighlight();
      gameRef.hoveredTile = house;
      house.highlight();
    } on TileAlreadyExists catch (e) {
      error(e.toString());
    } on CoordinatesOutOfBounds catch (e) {
      error(e.toString());
    }
  }

  void removeHouse(
      TileCoordinates coordinates, TileCoordinates newMouseCoordinates) {
    try {
      gameRef.hoveredTile = groundLayer.get(newMouseCoordinates);
      if (gameRef.hoveredTile != null) {
        gameRef.hoveredTile!.highlight();
      }
      buildingLayer.removeTile(coordinates);
    } on TileNotFound catch (e) {
      error(e.toString());
    }
  }
}
