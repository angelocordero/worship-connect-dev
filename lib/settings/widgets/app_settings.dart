import 'package:flutter/material.dart';
import 'package:worship_connect/settings/widgets/wc_about_card.dart';
import 'package:worship_connect/sign_in/services/wc_user_authentication_service.dart';
import 'package:worship_connect/wc_core/wc_custom_route.dart';
import 'package:worship_connect/wc_core/worship_connect_constants.dart';

class AppSettins extends StatelessWidget {
  const AppSettins({Key? key}) : super(key: key);

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
              child: Text('App Settings'),
              alignment: Alignment.centerLeft,
            ),
            const Divider(),
            ListTile(
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
            ),
            ElevatedButton(
              child: const Text('Logout'),
              style: ElevatedButton.styleFrom(shape: wcButtonShape),
              onPressed: () {
                WCUserAuthentication().signOut();
              },
            )
          ],
        ),
      ),
    );
  }
}
