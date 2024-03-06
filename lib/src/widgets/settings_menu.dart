import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nes_ui/nes_ui.dart';

import '../game/audio_controller.dart';
import '../game/game.dart';
import '../screens/game_screen.dart';
import 'dialog_box.dart';
import 'slider.dart';

Future<void> showSettingsMenu(
  BuildContext context,
  SustainaCityGame game,
  bool isMusicOn,
  bool isSfxOn,
) async {
  game.isPaused = true;
  await StyledDialog.show<void>(
    context: context,
    builder: (_) => SettingsMenu(
      isMusicOn: isMusicOn,
      isSfxOn: isSfxOn,
    ),
  );
  game.isPaused = false;
}

// ignore: must_be_immutable
final class SettingsMenu extends StatefulWidget {
  bool isMusicOn;
  bool isSfxOn;
  SettingsMenu(
      {requested, this.isMusicOn = true, this.isSfxOn = true, super.key});

  @override
  State<SettingsMenu> createState() => _SettingsMenuState();
}

class _SettingsMenuState extends State<SettingsMenu> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: FractionallySizedBox(
          widthFactor: 0.8, // 80% of the screen width
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text('Settings', style: TextStyle(fontSize: 24)),
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Music'),
                      Row(
                        children: [
                          NesButton(
                            type: widget.isMusicOn
                                ? NesButtonType.success
                                : NesButtonType.normal,
                            child: const Text('On'),
                            onPressed: () {
                              setState(() {
                                widget.isMusicOn = true;
                              });
                              AudioController().resumeBgm();
                            },
                          ),
                          const SizedBox(width: 8),
                          NesButton(
                            type: widget.isMusicOn
                                ? NesButtonType.normal
                                : NesButtonType.error,
                            child: const Text('Off'),
                            onPressed: () {
                              setState(() {
                                widget.isMusicOn = false;
                              });
                              AudioController().stopBgm();
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Sound FX'),
                  Row(
                    children: [
                      NesButton(
                          type: widget.isSfxOn
                              ? NesButtonType.success
                              : NesButtonType.normal,
                          child: const Text('On'),
                          onPressed: () {
                            setState(() {
                              widget.isSfxOn = true;
                            });
                            AudioController().resumeBgm();
                          }),
                      const SizedBox(width: 8),
                      NesButton(
                          type: widget.isSfxOn
                              ? NesButtonType.normal
                              : NesButtonType.error,
                          child: const Text('Off'),
                          onPressed: () {
                            setState(() {
                              widget.isSfxOn = false;
                            });
                            AudioController().stopSfx();
                          }),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(flex: 1, child: Text('Volume')),
                  Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                    child: SliderWidget(),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(flex: 1, child: Text('Mouse Sensitivity')),
                  Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                    child: SliderWidget(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
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
          false,
          false,
        ).then((_) => widget.game.overlays.remove(GameScreen.settingsMenu)));
    super.initState();
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
