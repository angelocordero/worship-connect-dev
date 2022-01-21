import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:worship_connect/sign_in/services/wc_user_authentication_service.dart';

class WCSignIn {
  Future googleSignIn() async {
    EasyLoading.show();
    final GoogleSignInAccount? googleSignInAccount = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleSignInAuthentication = await googleSignInAccount?.authentication;

    final googleCredential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication?.accessToken,
      idToken: googleSignInAuthentication?.idToken,
    );

    await WCUserAuthentication().authenticate(googleCredential);
    EasyLoading.dismiss();
  }

  Future facebookSignIn() async {
    //TODO: fb sign in
  }
}
