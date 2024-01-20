import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../components/pause_button.dart';
import 'game.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  static const String pauseKey = 'pause';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GameWidget<SustainaCityGame>(
        game: SustainaCityGame(),
        overlayBuilderMap: {
          pauseKey: (context, gameRef) => Padding(
                padding: const EdgeInsets.all(10.0),
                child: PauseButton(
                  gamRef: gameRef,
                ),
              ),
        },
      ),
    );
  }
}
