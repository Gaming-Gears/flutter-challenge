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
}
