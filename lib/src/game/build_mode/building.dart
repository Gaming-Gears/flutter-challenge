part of 'build_mode.dart';

enum CurrentBuilding { factory, smallHouse, largeHouse }

/// The percentage the player gets back when destroying a building.
const kDestroyRefund = 0.8;

final class BuildingBuildMode extends BuildMode {
  final CurrentBuilding currentBuilding;

  const BuildingBuildMode(this.currentBuilding, super.world) : super();

  /// Builds a [Building] on the building [Layer] in [world].
  @override
  void build(UnitCoordinates coordinates) {
    final hoveredTile = world.hoveredTile;
    if (hoveredTile != null) {
      final building = switch (currentBuilding) {
        CurrentBuilding.factory => Factory(hoveredTile.coordinates),
        CurrentBuilding.smallHouse => SmallHouse(hoveredTile.coordinates),
        CurrentBuilding.largeHouse => LargeHouse(hoveredTile.coordinates),
      };
      if (world.money < building.price) {
        error('Need \$${building.price}, but only have \$${world.money}');
      } else {
        bool built = false;
        try {
          built = world.buildingLayer.setTile(building);
        } on CoordinatesOutOfBounds catch (e) {
          error(e.toString());
        }
        if (built) {
          hoveredTile.unhighlight();
          world.hoveredTile = building;
          building.highlight();
          world.money -= building.price;
        }
      }
    }
  }

  /// Destroys the currently hovered [Building], then highlights the tile at
  /// [coordinates].
  @override
  void destroy(UnitCoordinates coordinates) {
    final hoveredBuilding = world.hoveredTile;
    if (hoveredBuilding != null && hoveredBuilding is Building) {
      hoveredBuilding.removeFromLayer();

      // Unhighlight the destroy building
      hoveredBuilding.unhighlight();

      // Highlight the tile under the mouse
      int highestPriority = -1;
      for (final layer in world.layers) {
        if (layer.priority > highestPriority) {
          final tile = layer.get(coordinates);
          if (tile != null) {
            world.hoveredTile = tile;
            highestPriority = layer.priority;
          }
        }
      }
      world.hoveredTile?.highlight();

      // Refund the player for a portion of the building's price
      world.money += hoveredBuilding.price * kDestroyRefund;
    }
  }
}
