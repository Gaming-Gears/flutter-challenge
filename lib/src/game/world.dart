import 'dart:async';

import 'package:flame/components.dart';

import 'background.dart';
import 'game.dart';
import 'tiles/buildings/building.dart';
import 'tiles/coordinates.dart';
import 'tiles/layer.dart';
import 'tiles/tile.dart';

/// The width/height of the map (measured in units).
const kMapSize = 1500;

/// The bounds of the map in the tile coordinate system (measured in units).
const kMapBounds = kMapSize ~/ 2;

/// The width/height of the map (measured in pixels).
const kMapSizePixels = kMapSize * Tile.pixelSize;

/// The amount of money the player earns per second.
const kMoneyRate = 3.0;

/// The amount of money the player starts with.
const kInitialMoney = 100.0;

final class SustainaCityWorld extends World
    with HasGameRef<SustainaCityGame>, Pauseable {
  /// The background of the world. This is a static image.
  final background = Background();

  /// A 1x1 unit square that is used to highlight the background.
  final backgroundHover = BackgroundHover(UnitCoordinates(0, 0));

  /// Buildings are placed on this layer.
  final buildingLayer = Layer<Building>((_) => null);

  /// All the layers in the world.
  late final layers = <Layer<Tile>>[buildingLayer];

  /// Maps tile types to the layers they should go in.
  final tileToLayer = <Type, Layer>{};

  /// The amount of money the player has.
  double money = kInitialMoney;

  SustainaCityWorld() : super();

  @override
  FutureOr<void> onLoad() async {
    await Future.wait<void>([
      ...layers.map((layer) async => await add(layer)),
      (() async => await add(background))(),
      (() async => await add(backgroundHover))()
    ]);
    return await super.onLoad();
  }

  @override
  void updateGame(double dt) => money += kMoneyRate * dt;
}
