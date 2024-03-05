import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:nes_ui/nes_ui.dart';

import '../game/game.dart';
import '../widgets/pause_button.dart';
import '../widgets/settings_menu.dart';
import '../widgets/shop_button.dart';

List<Map<String, String>> shoppingItems = [
  {'Factory': 'assets/images/factory.png'},
  {'House': 'assets/images/house.png'},
  {'Solar Panel': 'assets/images/solar_panel.png'},
];

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  static const String pauseKey = 'pause';
  static const String settingsMenu = 'settingsMenu';
  static const String shopButton = 'shopButton';

  @override
  Widget build(BuildContext context) => Scaffold(
        endDrawer: drawer(context),
        body: GameWidget<SustainaCityGame>(
          game: SustainaCityGame(),
          overlayBuilderMap: {
            pauseKey: (_, game) => PauseButton(game),
            settingsMenu: (_, game) => ShowSettingsMenu(game),
            shopButton: (_, game) => ShopButton(game),
          },
        ),
      );
}

Drawer drawer(BuildContext context) => Drawer(
      width: 450,
      child: ListView(
        children: [
          ListTile(
            title: const Text('Shop'),
            leading: Image.asset(
              'assets/icons/shop.png',
              width: 24,
              height: 24,
            ),
          ),
          const Divider(),
          const SizedBox(height: 24),
          ...shoppingItems.map(
            (item) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                title: Text(item.keys.first),
                leading: Image.asset(
                  item.values.first,
                  width: 64,
                  height: 64,
                ),
                trailing: NesButton(
                  type: NesButtonType.primary,
                  onPressed: () {},
                  child: const Text('Buy'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
