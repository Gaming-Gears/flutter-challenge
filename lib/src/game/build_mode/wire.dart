part of 'build_mode.dart';

final class WireBuildMode extends BuildMode {
  const WireBuildMode(super.world) : super();

  @override
  void build(UnitCoordinates coordinates) {
    print('Building wire at $coordinates');
  }

  @override
  void destroy(UnitCoordinates coordinates) {
    print('Destroying wire at $coordinates');
  }
}
