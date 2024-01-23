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
    final building = switch (currentBuilding) {
      CurrentBuilding.factory => Factory(coordinates),
      CurrentBuilding.smallHouse => SmallHouse(coordinates),
      CurrentBuilding.largeHouse => LargeHouse(coordinates),
    };
    if (world.money < building.price) {
      error('Need \$${building.price}, but only have \$${world.money}');
    } else {
      try {
        if (world.buildingLayer.setTile(building)) {
          world.groundLayer.get(coordinates)?.unhighlight();
          building.highlight();

          // Deduct the price of the building from the player's money
          world.money -= building.price;
        }
      } on CoordinatesOutOfBounds catch (e) {
        error(e.toString());
      }
    }
  }

  /// Destroys the currently hovered [Building], then highlights the tile at
  /// [coordinates].
  @override
  void destroy(UnitCoordinates coordinates) {
    final building = world.buildingLayer.get(coordinates);
    if (building != null) {
      building.removeFromLayer();

      building.unhighlight();
      world.groundLayer.get(coordinates)?.highlight();

      // Refund the player for a portion of the building's price
      world.money += building.price * kDestroyRefund;
    }
  }
}
