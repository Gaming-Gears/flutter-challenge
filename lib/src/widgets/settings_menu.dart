import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nes_ui/nes_ui.dart';

import '../game/game.dart';
import '../screens/game_screen.dart';
import 'dialog_box.dart';

Future<void> showSettingsMenu(
  BuildContext context,
  SustainaCityGame game,
) async {
  game.isPaused = true;
  await StyledDialog.show<void>(
    context: context,
    builder: (_) => const SettingsMenu(),
  );
  game.isPaused = false;
}

final class SettingsMenu extends StatelessWidget {
  const SettingsMenu({super.key}) : super();

  @override
  Widget build(BuildContext context) => Column(
        children: [
          const Text('Settings'),
          const SizedBox(height: 12),
          NesButton(
            type: NesButtonType.normal,
            child: const Text('Resume'),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(height: 12),
          NesButton(
            type: NesButtonType.normal,
            child: const Text('Exit Game'),
            onPressed: () =>
                Navigator.popUntil(context, (route) => route.isFirst),
          ),
          const SizedBox(height: 25),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Music'),
              const SizedBox(width: 20),
              Row(
                children: [
                  NesButton(
                    type: NesButtonType.success,
                    child: const Text('On'),
                    onPressed: () {},
                  ),
                  const SizedBox(width: 8),
                  NesButton(
                    type: NesButtonType.normal,
                    child: const Text('Off'),
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Sound FX'),
              const SizedBox(width: 20),
              Row(
                children: [
                  NesButton(
                    type: NesButtonType.success,
                    child: const Text('On'),
                    onPressed: () {},
                  ),
                  const SizedBox(width: 8),
                  NesButton(
                    type: NesButtonType.normal,
                    child: const Text('Off'),
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
        ],
      );
}

final class ShowSettingsMenu extends StatefulWidget {
  final SustainaCityGame game;

  const ShowSettingsMenu(this.game, {super.key}) : super();

  @override
  State<StatefulWidget> createState() => _ShowSettingsMenuState();
}

final class _ShowSettingsMenuState extends State<ShowSettingsMenu> {
  @override
  void initState() {
    Timer.run(() => showSettingsMenu(
          context,
          widget.game,
        ).then((_) => widget.game.overlays.remove(GameScreen.settingsMenu)));
    super.initState();
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
