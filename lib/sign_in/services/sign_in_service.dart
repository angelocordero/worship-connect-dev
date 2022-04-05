import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:worship_connect/sign_in/services/wc_user_authentication_service.dart';
import 'package:worship_connect/wc_core/worship_connect_utilities.dart';

class WCSignIn {
  Future googleSignIn() async {
    EasyLoading.show();
    try {
      final GoogleSignInAccount? googleSignInAccount = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleSignInAuthentication = await googleSignInAccount?.authentication;

      final googleCredential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication?.accessToken,
        idToken: googleSignInAuthentication?.idToken,
      );

      await WCUserAuthentication().authenticate(googleCredential);
      EasyLoading.dismiss();
    } catch (e, st) {
      _catchSignInError(e, st);
    }
  }

  Future facebookSignIn() async {
    EasyLoading.show();

    try {
      final LoginResult fbLoginResult = await FacebookAuth.instance.login();

      if (fbLoginResult.status == LoginStatus.success) {
        final OAuthCredential facebookCredential = FacebookAuthProvider.credential(fbLoginResult.accessToken!.token);
        await WCUserAuthentication().authenticate(facebookCredential);
      }
      EasyLoading.dismiss();
    } catch (e, st) {
      _catchSignInError(e, st);
    }
  }

  _catchSignInError(e, st) {
    if (e.toString().contains('firebase_auth/account-exists-with-different-credential')) {
      WCUtils.wcShowError(wcError: 'An account already exists with the same email address');
    } else {
      WCUtils.wcShowError(e: e, st: st, wcError: 'Sign in failed');
    }
  }
}
