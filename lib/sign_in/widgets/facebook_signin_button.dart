import 'package:flutter/material.dart';
import 'package:worship_connect/wc_core/worship_connect_constants.dart';
import 'package:worship_connect/sign_in/services/sign_in_service.dart';

class FacebookSignInButton extends StatelessWidget {
  const FacebookSignInButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 75),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.only(left: 45),
          alignment: Alignment.centerLeft,
          minimumSize: wcSignInButtonSize,
          maximumSize: wcSignInButtonSize,
          primary: Colors.white,
          shape: wcButtonShape,
        ),
        icon: Image.asset(
          'assets/facebook_logo.png',
          height: 23,
          width: 50,
        ),
        label: Text(
          'Sign in with Facebook',
          style: wcSignInButtonTextStyle,
        ),
        onPressed: () async {
          await WCSignIn().facebookSignIn();
        },
      ),
    );
  }
}
