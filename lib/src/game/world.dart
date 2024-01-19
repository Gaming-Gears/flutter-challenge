import 'dart:async';

import 'package:flame/components.dart';

import 'cursor.dart';
import 'layer.dart';
import 'tiles/buildings/building.dart';
import 'tiles/buildings/house.dart';
import 'tiles/ground/grass.dart';

final class SustainaCityWorld extends World {
  static const mapSize = 100;

  final groundLayer = Layer(mapSize, (x, y) => Grass(x, y));
  final buildingLayer = Layer<Building>(mapSize, (x, y) => null);

  @override
  FutureOr<void> onLoad() async {
    await add(Cursor());
    await add(groundLayer);
    await add(buildingLayer);
    return super.onLoad();
  }

  void buildHouse(int tileX, int tileY) {
    buildingLayer.set(tileX, tileY, House(tileX, tileY));
  }
}
