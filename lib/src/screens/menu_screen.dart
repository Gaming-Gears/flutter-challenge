import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nes_ui/nes_ui.dart';
import '../widgets/settings_menu.dart';

import 'game_screen.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key}) : super();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('SustainaCity'),
        ),
        body: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
                child: const Text('Settings'),
                onPressed: () => Navigator.push(
                  context,
                  NesVerticalGridTransition.route<void>(
                      pageBuilder: (_, __, ___) =>
                          const Scaffold(body: SettingsMenu())),
                ),
              ),
              Visibility(
                visible: !kIsWeb,
                child: NesButton(
                  type: NesButtonType.normal,
                  child: const Text('Exit'),
                  onPressed: () => appWindow.close(),
                ),
              ),
            ],
          ),
        ),
      );
}
