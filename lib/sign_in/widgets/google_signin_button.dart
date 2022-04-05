import 'package:flutter/material.dart';
import 'package:worship_connect/wc_core/worship_connect_constants.dart';
import 'package:worship_connect/sign_in/services/sign_in_service.dart';

class GoogleSignInButton extends StatelessWidget {
  const GoogleSignInButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.only(left: 45),
            alignment: Alignment.centerLeft,
            minimumSize: wcSignInButtonSize,
            maximumSize: wcSignInButtonSize,
            primary: Colors.white,
            shape: wcButtonShape),
        icon: Image.asset(
          'assets/google_logo.png',
          width: 50,
          height: 44,
        ),
        label: Text(
          'Sign in with Google',
          style: wcSignInButtonTextStyle,
        ),
        onPressed: () async {
          await WCSignIn().googleSignIn();
        },
      ),
    );
  }
}
