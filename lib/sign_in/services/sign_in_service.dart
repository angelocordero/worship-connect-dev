import 'package:flutter_easyloading/flutter_easyloading.dart';
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
    } catch (error) {
      WCUtils().wcShowError('Sign in failed');
    }
  }

  Future facebookSignIn() async {
    //TODO: fb sign in
  }
}
