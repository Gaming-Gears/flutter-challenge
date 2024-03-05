import 'package:flutter/material.dart';
import 'package:nes_ui/nes_ui.dart';

import '../game/game.dart';

class ShopButton extends StatelessWidget {
  const ShopButton(SustainaCityGame game, {super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 10,
      right: 10,
      child: NesButton(
        type: NesButtonType.normal,
        onPressed: () => Scaffold.of(context).openEndDrawer(),
        child: Image.asset(
          'assets/icons/shop.png',
          height: 24,
          width: 24,
        ),
      ),
    );
  }
}
