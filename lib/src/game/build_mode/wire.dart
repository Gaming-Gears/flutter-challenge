part of 'build_mode.dart';

const kMaxFactoryConnections = 4;

final class WireBuildMode extends BuildMode {
  House? target;
  Factory? source;

  WireBuildMode(super.world) : super();

  @override
  void build(UnitCoordinates coordinates) {
    final building = world.buildingLayer.get(coordinates);
    if (target == null && building is House && building.powerSource == null) {
      target = building;
      if (source != null) {
        building.powerSource = source;
        source!.connectedHouses.add(building);
      }
    } else if (source == null &&
        building is Factory &&
        building.connectedHouses.length < kMaxFactoryConnections) {
      source = building;
      if (target != null) {
        building.connectedHouses.add(target!);
        target!.powerSource = building;
      }
    }
    if (target != null && source != null) {
      source = null;
      target = null;
      info('Connected: $target to $source');
    }
  }

  @override
  void destroy(UnitCoordinates coordinates) {
    target = null;
    source = null;
  }
}
