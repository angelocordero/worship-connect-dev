import 'package:flutter/material.dart';

class SettingsHomePage extends StatelessWidget {
  const SettingsHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
    );
  }
}
