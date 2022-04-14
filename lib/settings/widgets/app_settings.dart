import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worship_connect/settings/widgets/theme_selection_card.dart';
import 'package:worship_connect/settings/widgets/wc_about_card.dart';
import 'package:worship_connect/sign_in/services/wc_user_authentication_service.dart';
import 'package:worship_connect/wc_core/wc_custom_route.dart';
import 'package:worship_connect/wc_core/core_providers_definition.dart';
import 'package:worship_connect/wc_core/worship_connect_constants.dart';

class AppSettings extends StatelessWidget {
  const AppSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Align(
              child: Text('Application Settings'),
              alignment: Alignment.centerLeft,
            ),
            const Divider(),
            _themeListTile(),
            _wcAboutListTile(context),
            _signOutButton()
          ],
        ),
      ),
    );
  }

  Padding _signOutButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ElevatedButton(
        child: const Text('Logout'),
        onPressed: () async {
          await WCUserAuthentication().signOut();
        },
      ),
    );
  }

  Consumer _themeListTile() {
    return Consumer(builder: (context, ref, child) {
      String _themeModeString = 'System Default';

      ThemeMode _currentTheme = ref.watch(wcThemeProvider);

      switch (_currentTheme) {
        case ThemeMode.dark:
          _themeModeString = 'Dark';
          break;

        case ThemeMode.light:
          _themeModeString = 'Light';
          break;
        default:
          _themeModeString = 'System Default';
          break;
      }

      return ListTile(
        title: Text(_themeModeString),
        subtitle: const Text('Theme'),
        trailing: Hero(
          tag: 'theme',
          child: IconButton(
            icon: wcTrailingIcon,
            onPressed: () {
              Navigator.push(
                context,
                WCCustomRoute(
                  builder: (BuildContext context) {
                    return const ThemeSelectionCard();
                  },
                ),
              );
            },
          ),
        ),
      );
    });
  }

  ListTile _wcAboutListTile(BuildContext context) {
    return ListTile(
      title: const Text('About Worship Connect'),
      trailing: const Hero(
        tag: 'about',
        child: Icon(Icons.info_outline),
      ),
      onTap: () {
        Navigator.push(
          context,
          WCCustomRoute(
            builder: (context) {
              return const WCAboutCard();
            },
          ),
        );
      },
    );
  }
}
