import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nes_ui/nes_ui.dart';
import 'package:universal_html/html.dart' as html;

import '../game/game_screen.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SustainaCity'),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            NesButton(
              type: NesButtonType.normal,
              child: const Text('Start Game'),
              onPressed: () => Navigator.push(
                context,
                NesVerticalGridTransition.route<void>(
                    pageBuilder: (_, __, ___) => const GameScreen()),
              ),
            ),
            NesButton(
              type: NesButtonType.normal,
              child: const Text('Exit'),
              onPressed: () => kIsWeb ? html.window.close() : appWindow.close(),
            ),
          ],
        ),
      ),
    );
  }
}
