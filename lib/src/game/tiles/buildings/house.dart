import 'building.dart';

enum Model { vertical, horizontal }

final class House extends Building {
  final Model model;

  House(super.coordinates, this.model) : super();

  @override
  String get spritePath => switch (model) {
        Model.vertical => 'suburbs2_TileB.png',
        Model.horizontal => 'suburbs_TileE.png',
      };

  @override
  int get tileHeight => switch (model) {
        Model.vertical => 10,
        Model.horizontal => 10,
      };

  @override
  int get tileWidth => switch (model) {
        Model.vertical => 5,
        Model.horizontal => 8,
      };

  @override
  int get srcTileOffsetX => 0;

  @override
  int get srcTileOffsetY => switch (model) {
        Model.vertical => 0,
        Model.horizontal => 6,
      };

  @override
  double get price => switch (model) {
        Model.vertical => 100,
        Model.horizontal => 200,
      };
}
