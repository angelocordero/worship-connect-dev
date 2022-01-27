import 'package:flutter/material.dart';
import 'package:worship_connect/settings/widgets/team_settings.dart';
import 'package:worship_connect/sign_in/services/wc_user_authentication_service.dart';

class SettingsHomePage extends StatelessWidget {
  const SettingsHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        actions: [
          IconButton(
            onPressed: () async {
              await WCUserAuthentication().signOut();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: ListView(
        children: const <Widget>[
          TeamSettings(),
        ],
      ),
    );
  }
}
