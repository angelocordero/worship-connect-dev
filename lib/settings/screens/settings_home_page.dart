import 'package:flutter/material.dart';
import 'package:worship_connect/settings/widgets/app_settings.dart';
import 'package:worship_connect/settings/widgets/user_settings.dart';
import 'package:worship_connect/settings/widgets/team_settings.dart';

class SettingsHomePage extends StatelessWidget {
  const SettingsHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(4),
        children: const <Widget>[
          UserSettings(),
          TeamSettings(),
          AppSettings(),
        ],
      ),
    );
  }
}
