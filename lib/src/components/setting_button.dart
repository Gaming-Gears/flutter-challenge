import 'package:flutter/material.dart';
import 'package:nes_ui/nes_ui.dart';

class SettingsButton extends StatelessWidget {
  const SettingsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: IconButton(
        icon: Icon(Icons.settings),
        onPressed: () => NesDialog.show(
          context: context,
          builder: (_) => Container(
            child: Text('Settings'),
          ),
        ),
      ),
    );
  }
}
