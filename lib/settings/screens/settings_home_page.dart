import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:worship_connect/settings/widgets/app_settings.dart';
import 'package:worship_connect/settings/widgets/user_settings.dart';
import 'package:worship_connect/settings/widgets/team_settings.dart';

class SettingsHomePage extends StatelessWidget {
  const SettingsHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: GoogleFonts.exo2(),
        ),
      ),
      body: ListView(
        children: const <Widget>[
          UserSettings(),
          TeamSettings(),
          AppSettins(),
        ],
      ),
    );
  }
}
