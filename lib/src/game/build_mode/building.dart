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
      // Deduct the price of the building from the player's money only if the
      // building is successfully placed
      if (world.buildingLayer.setTile(building)) {
        world.money -= building.price;
        info('Built $building, and spent \$${building.price}');
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

      // Refund the player for a portion of the building's price
      final refundPrice = building.price * kDestroyRefund;
      world.money += refundPrice;

      info('Destroyed $building, and refunded \$$refundPrice');
    }
  }
}
