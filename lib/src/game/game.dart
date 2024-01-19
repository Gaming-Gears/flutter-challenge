import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'world.dart';

final class SustainaCity extends FlameGame
    with SingleGameInstance, HoverCallbacks {
  final hoveredTiles = <(int, int)>{};

  SustainaCity() : super(world: SustainaCityWorld()) {
    pauseWhenBackgrounded = false;
  }

  @override
  Color backgroundColor() => const Color(0x00000000);
}
