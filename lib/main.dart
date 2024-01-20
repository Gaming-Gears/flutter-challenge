import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';

import 'src/app/app.dart';
import 'src/cache.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.setLandscape();
  await Flame.device.fullScreen();
  await initializeCache();
  runApp(const SustainaCityApp());

  doWhenWindowReady(() {
    const initialSize = Size(600, 450);
    appWindow.minSize = initialSize;
    appWindow.size = initialSize;
    appWindow.alignment = Alignment.center;
    appWindow.show();
  });
}
