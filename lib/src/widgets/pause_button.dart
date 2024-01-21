import 'package:flutter/material.dart';
import 'package:nes_ui/nes_ui.dart';

import '../game/game.dart';
import 'settings_menu.dart';

class PauseButton extends StatelessWidget {
  final SustainaCityGame game;

  const PauseButton(this.game, {super.key}) : super();

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(10.0),
        child: NesButton(
          type: NesButtonType.normal,
          child: Image.asset(
            'assets/icons/pause.png',
            height: 20,
            width: 20,
          ),
          onPressed: () => showSettingsMenu(context, game),
        ),
      );
}
