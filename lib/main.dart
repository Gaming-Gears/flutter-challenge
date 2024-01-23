import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:nes_ui/nes_ui.dart';

import 'src/cache.dart';
import 'src/screens/menu_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.setLandscape();
  await Flame.device.fullScreen();
  await initializeCache();
  runApp(MaterialApp(
    title: 'SustainaCity',
    theme: flutterNesTheme(),
    home: const MenuScreen(),
  ));

  doWhenWindowReady(() {
    appWindow.alignment = Alignment.center;
    appWindow.show();
  });
}
