import 'package:flutter/material.dart';
import 'package:worship_connect/settings/widgets/app_settings.dart';
import 'package:worship_connect/settings/widgets/personal_settings.dart';
import 'package:worship_connect/settings/widgets/team_settings.dart';

class SettingsHomePage extends StatelessWidget {
  const SettingsHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: const <Widget>[
          PersonalSettings(),
          TeamSettings(),
          AppSettins(),
        ],
      ),
    );
  }
}
