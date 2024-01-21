import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../game/game.dart';
import '../widgets/pause_button.dart';
import '../widgets/settings_menu.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  static const String pauseKey = 'pause';
  static const String settingsMenu = 'settingsMenu';

  @override
  Widget build(BuildContext context) => Scaffold(
        body: GameWidget<SustainaCityGame>(
          game: SustainaCityGame(),
          overlayBuilderMap: {
            pauseKey: (_, game) => PauseButton(game),
            settingsMenu: (_, game) => ShowSettingsMenu(game),
          },
        ),
      );
}
