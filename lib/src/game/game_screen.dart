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
      body: GameWidget(
        game: SustainaCityGame(),
        overlayBuilderMap: {
          pauseKey: (context, game) => const Padding(
                padding: EdgeInsets.all(10.0),
                child: PauseButton(),
              ),
        },
      ),
    );
  }
}
