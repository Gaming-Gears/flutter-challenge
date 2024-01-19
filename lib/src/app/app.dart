import 'package:flutter/material.dart';
import 'package:nes_ui/nes_ui.dart';

import '../screens/menu_screen.dart';

class SustainaCityApp extends StatelessWidget {
  const SustainaCityApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SustainaCity',
      theme: flutterNesTheme(),
      home: const MenuScreen(),
    );
  }
}
