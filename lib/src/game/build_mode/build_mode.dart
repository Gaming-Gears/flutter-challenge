import '../tiles/tile.dart';

part 'building.dart';
part 'wire.dart';

sealed class BuildMode {
  const BuildMode() : super();

  void build(Tile? hoveredTile) {}
}
