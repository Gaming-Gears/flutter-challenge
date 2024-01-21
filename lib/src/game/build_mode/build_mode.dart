import '../../logger.dart';
import '../tiles/buildings/building.dart';
import '../tiles/buildings/factory.dart';
import '../tiles/buildings/house.dart';
import '../tiles/coordinates.dart';
import '../tiles/layer.dart';
import '../world.dart';

part 'building.dart';
part 'wire.dart';

sealed class BuildMode {
  final SustainaCityWorld world;

  const BuildMode(this.world) : super();

  void build(TileCoordinates coordinates);

  void destroy(TileCoordinates coordinates);
}
