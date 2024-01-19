import 'package:flutter/material.dart';
import 'package:nes_ui/nes_ui.dart';

import 'setting_button.dart';

class TempApp extends StatelessWidget {
  const TempApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Temp App',
      theme: flutterNesTheme(),
      home: TempPage(),
    );
  }
}

class TempPage extends StatelessWidget {
  const TempPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Temp Page'),
      ),
      body: Container(
        child: Center(
          child: SettingsButton(),
        ),
      ),
    );
  }
}
