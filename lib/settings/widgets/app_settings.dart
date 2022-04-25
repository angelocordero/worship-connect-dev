import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worship_connect/settings/widgets/theme_selection_card.dart';
import 'package:worship_connect/sign_in/services/wc_user_authentication_service.dart';
import 'package:worship_connect/sign_in/utils/wc_user_info_data.dart';
import 'package:worship_connect/wc_core/wc_about_details.dart';
import 'package:worship_connect/wc_core/core_providers_definition.dart';
import 'package:worship_connect/wc_core/wc_url_utilities.dart';
import 'package:worship_connect/wc_core/wc_user_firebase_api.dart';
import 'package:worship_connect/wc_core/worship_connect_constants.dart';

class AppSettings extends StatelessWidget {
  const AppSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Application Settings',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            const Divider(),
            _notificationsTile(),
            _themeListTile(),
            _wcAboutListTile(context),
            _signOutButton(),
          ],
        ),
      ),
    );
  }

  Consumer _notificationsTile() {
    return Consumer(
      builder: (context, ref, _) {
        WCUserInfoData? _userData = ref.watch(wcUserInfoDataStream).value;

        String? _fcmToken = _userData?.fcmToken;

        return SwitchListTile(
          title: const Text('Notifications'),
          value: _fcmToken?.isNotEmpty ?? false,
          onChanged: (newValue) async {
            if (_userData == null) return;

            if (newValue) {
              await WCUSerFirebaseAPI().turnOnUserNotifications(_userData.userID, _userData.teamID);
            } else {
              await WCUSerFirebaseAPI().turnOffUserNotifications(_userData.userID, _userData.teamID);
            }
          },
        );
      },
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
    return Consumer(
      builder: (context, ref, child) {
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
          trailing: wcTrailingIcon,
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return const ThemeSelectionCard();
              },
            );
          },
        );
      },
    );
  }

  AboutListTile _wcAboutListTile(BuildContext context) {
    return AboutListTile(
      icon: const Icon(Icons.info_outline),
      applicationIcon: wcApplicationIcon,
      applicationName: wcApplicationName,
      applicationVersion: wcApplicationVersion,
      aboutBoxChildren: [
        RichText(
          text: TextSpan(
            style: DefaultTextStyle.of(context).style,
            text: 'To send issues or to contact me, please visit the ',
            children: [
              TextSpan(
                text: 'Worship Connect Github page.',
                style: const TextStyle(
                  color: Colors.blue,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () async {
                    await WCUrlUtils.openWCGithubPage();
                  },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
