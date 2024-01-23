import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';

import 'game.dart';
import 'tiles/buildings/building.dart';
import 'tiles/ground/grass.dart';
import 'tiles/ground/ground.dart';
import 'tiles/layer.dart';
import 'tiles/tile.dart';

/// The width/height of the map (measured in units).
const kMapSize = 1500;

/// The bounds of the map in the tile coordinate system (measured in units).
const kMapBounds = kMapSize ~/ 2;

/// The width/height of the map (measured in pixels).
const kMapSizePixels = kMapSize * Tile.unitSize;

/// The amount of money the player earns per second.
const kMoneyRate = 3.0;

/// The amount of money the player starts with.
const kInitialMoney = 100.0;

final class SustainaCityWorld extends World
    with HasGameRef<SustainaCityGame>, Pauseable {
  /// The current units that are in view of the camera.
  final renderedUnits = <String>{};

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
  double money = kInitialMoney;

  Vector2 lastMousePosition = Vector2.zero();
  double zoom = 1.0;

  SustainaCityWorld() : super();

  @override
  void render(Canvas canvas) {
    canvas.save();
    canvas.translate(-lastMousePosition.x * zoom + game.size.x / 2,
        -lastMousePosition.y * zoom + game.size.y / 2);
    canvas.scale(zoom);
    // Render your game objects here
    canvas.restore();
  }

  @override
  FutureOr<void> onLoad() async {
    await add(groundLayer);
    await add(buildingLayer);
    return await super.onLoad();
  }

  @override
  void update(double dt) {
    money += kMoneyRate * dt;
    super.update(dt);
  }
}
