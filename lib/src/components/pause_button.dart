import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nes_ui/nes_ui.dart';

import '../game/game.dart';

class PauseButton extends StatelessWidget {
  const PauseButton({super.key, required this.gamRef});

  final SustainaCityGame gamRef;

  @override
  Widget build(BuildContext context) {
    return NesButton(
      type: NesButtonType.normal,
      child: SvgPicture.asset('icons/pause.svg'),
      onPressed: () {
        gamRef.pauseEngine();
        NesDialog.show(
          context: context,
          builder: (_) => Column(
            children: [
              const Text('Settings'),
              const SizedBox(height: 12),
              NesButton(
                type: NesButtonType.normal,
                child: const Text('Resume'),
                onPressed: () => {
                  gamRef.resumeEngine(),
                  Navigator.pop(context),
                },
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
          ),
        );
      },
    );
  }
}
