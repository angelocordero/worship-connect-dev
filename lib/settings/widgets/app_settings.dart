import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worship_connect/settings/widgets/theme_selection_card.dart';
import 'package:worship_connect/settings/widgets/wc_about_card.dart';
import 'package:worship_connect/sign_in/services/wc_user_authentication_service.dart';
import 'package:worship_connect/wc_core/wc_custom_route.dart';
import 'package:worship_connect/wc_core/wc_themes.dart';
import 'package:worship_connect/wc_core/worship_connect.dart';
import 'package:worship_connect/wc_core/worship_connect_constants.dart';

class AppSettins extends ConsumerWidget {
  const AppSettins({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final WCThemeProvider _wcThemeNotifier = ref.watch(wcThemeProvider.notifier);

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
            _themeListTile(_wcThemeNotifier, context),
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
        style: ElevatedButton.styleFrom(shape: wcButtonShape),
        onPressed: () {
          WCUserAuthentication().signOut();
        },
      ),
    );
  }

  ListTile _themeListTile(WCThemeProvider _wcThemeNotifier, BuildContext context) {
    return ListTile(
      title: const Text('Theme'),
      subtitle: Text(
        _wcThemeNotifier.getCurrentThemeName(),
      ),
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
