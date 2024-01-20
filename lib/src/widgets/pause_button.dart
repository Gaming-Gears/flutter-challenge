import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
          child: SvgPicture.asset('icons/pause.svg'),
          onPressed: () => showSettingsMenu(context, game),
        ),
      );
}
