import 'building.dart';

enum Model { vertical, horizontal }

extension on Model {
  int get srcTileHeight => switch (this) {
        Model.vertical => 10,
        Model.horizontal => 10,
      };

  int get srcTileWidth => switch (this) {
        Model.vertical => 5,
        Model.horizontal => 8,
      };

  int get srcTileOffsetX => 0;

  int get srcTileOffsetY => switch (this) {
        Model.vertical => 0,
        Model.horizontal => 6,
      };
}

final class House extends Building {
  final Model model;

  House(super.coordinates, this.model) : super();

  @override
  String get spritePath => switch (model) {
        Model.vertical => 'suburbs2_TileB.png',
        Model.horizontal => 'suburbs_TileE.png',
      };

  @override
  int get srcTileHeight => model.srcTileHeight;

  @override
  int get srcTileWidth => model.srcTileWidth;

  @override
  int get srcTileOffsetX => model.srcTileOffsetX;

  @override
  int get srcTileOffsetY => model.srcTileOffsetY;
}
