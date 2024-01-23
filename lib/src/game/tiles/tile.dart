import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';

import '../world.dart';
import 'coordinates.dart';
import 'layer.dart';

/// Thrown when a layer is not found for a given tile type.
final class LayerNotFound implements Exception {
  final Type type;
  final Map<Type, Type> availableLayers;

  const LayerNotFound(this.type, this.availableLayers) : super();

  @override
  String toString() =>
      'No layer found for $type, available layers are: $availableLayers';
}

/// Thrown when a tile is placed on an incorrect layer.
final class IncorrectLayerType implements Exception {
  final Type type;
  final Type incorrect;
  final Type correct;

  const IncorrectLayerType(this.type, this.incorrect, this.correct) : super();

  @override
  String toString() =>
      'Incorrect layer for $type: $incorrect, correct layer was: $correct';
}

/// The tint of a tile when hovered over
const kHoverColor = Color.fromARGB(51, 251, 219, 67);

/// A mixin for components that can be hovered over.
mixin Hoverable {
  /// Tints the component to [kHoverColor]
  void highlight();

  /// Removes the tint from the component
  void unhighlight();
}

/// Renders a tint over the background when the pointer is hovering over it.
final class BackgroundHover extends Component with HasPaint, Hoverable {
  UnitCoordinates coordinates;
  bool highlighted = false;

  BackgroundHover(this.coordinates) : super(priority: 0) {
    paint.blendMode = BlendMode.srcATop;
    paint.color = kHoverColor;
  }

  @override
  void render(Canvas canvas) {
    if (highlighted) {
      canvas.drawRect(
        Rect.fromLTWH(coordinates.x * Tile.pixelSize,
            coordinates.y * Tile.pixelSize, Tile.pixelSize, Tile.pixelSize),
        paint,
      );
    }
    super.render(canvas);
  }

  @override
  void highlight() => highlighted = true;

  @override
  void unhighlight() => highlighted = false;
}

/// The "MOTHER OF ALL TILES"
abstract base class Tile<T extends Tile<T>> extends SpriteComponent
    with HasWorldReference<SustainaCityWorld>, Hoverable {
  /// Pixel size of a single unit
  static const pixelSize = 32.0;

  /// The coordinates of the tile
  final UnitCoordinates coordinates;

  /// The layer this tile is on
  late final Layer<T> layer;

  /// Whether or not the tile is highlighted
  bool highlighted = false;

  Tile(this.coordinates)
      : super(
          position: Vector2(
            coordinates.x * pixelSize,
            coordinates.y * pixelSize,
          ),
        ) {
    paint.isAntiAlias = false;
  }

  @override
  FutureOr<void> onLoad() async {
    // Get the layer corresponding to this tile type
    final Layer<Tile<dynamic>>? tileLayer = world.tileToLayer[T];
    if (tileLayer == null) {
      throw LayerNotFound(
          T,
          world.tileToLayer
              .map((key, value) => MapEntry(key, value.runtimeType)));
    }
    if (tileLayer is Layer<T>) {
      layer = tileLayer;
    } else {
      throw IncorrectLayerType(T, tileLayer.runtimeType, Layer<T>);
    }

    // load and set the sprite
    sprite = Sprite(
      await Flame.images.load(spritePath),
      srcSize: Vector2(widthUnits * pixelSize, tileHeight * pixelSize),
      srcPosition:
          Vector2(srcTileOffsetX * pixelSize, srcTileOffsetY * pixelSize),
    );

    // Fixes anti-aliasing issues on web
    if (highlighted) {
      highlight();
    } else {
      unhighlight();
    }

    return await super.onLoad();
  }

  /// The path to the sprite sheet
  String get spritePath;

  /// The offset of the sprite within the sprite sheet measured in units
  int get srcTileOffsetX;

  /// The offset of the sprite within the sprite sheet measured in units
  int get srcTileOffsetY;

  /// The width of the sprite measured in units
  int get widthUnits;

  /// The height of the sprite measured in units
  int get tileHeight;

  /// Iterate through each unit in the [Tile], calling [callback] on each one.
  void forEachUnit(
      void Function(
        UnitCoordinates coordinates,
        VoidCallback breakLoop,
      ) callback) {
    bool breakLoop = false;
    void breakLoopCallback() => breakLoop = true;

    for (int y = coordinates.y; y < coordinates.y + tileHeight; ++y) {
      for (int x = coordinates.x; x < coordinates.x + widthUnits; ++x) {
        callback(UnitCoordinates(x, y), breakLoopCallback);
        if (breakLoop) {
          return;
        }
      }
    }
  }

  /// Removes this tile from the layer it is on.
  void removeFromLayer() {
    forEachUnit((coordinates, _) {
      if (layer.get(coordinates) == null) {
        // This should only happen if the dimensions of the tile are somehow
        // invalid.
        throw TileNotFound(coordinates);
      } else {
        layer.tiles[coordinates.toArrayIndex()].value = null;
      }
    });
    layer.remove(this);
  }

  /// Tints the sprite to [kHoverColor]
  @override
  void highlight() {
    highlighted = true;
    paint.colorFilter = const ColorFilter.mode(kHoverColor, BlendMode.srcATop);
  }

  /// Removes the tint from the sprite
  @override
  void unhighlight() {
    highlighted = false;
    paint.colorFilter =
        const ColorFilter.mode(Colors.transparent, BlendMode.srcATop);
  }
}
