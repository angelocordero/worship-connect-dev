import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:worship_connect/wc_core/wc_user_firebase_api.dart';
import 'package:worship_connect/sign_in/utils/wc_user_auth_data.dart';

class WCUserAuthentication {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  authenticate(OAuthCredential _oAuthCredential) async {
    UserCredential wcUserCredential = await _firebaseAuth.signInWithCredential(_oAuthCredential);

    // initialize user data in firebase if new user
    if (wcUserCredential.additionalUserInfo!.isNewUser) {
      User? newUser = wcUserCredential.user;

      WCUSerFirebaseAPI().initializeWCUserData(newUser!.uid);
    }
  }

  signOut() async {
    EasyLoading.show();

    FirebaseCrashlytics.instance.setUserIdentifier('');

    GoogleSignIn _googleSignIn = GoogleSignIn();
    await _firebaseAuth.signOut();
    await _googleSignIn.signOut();
    await _googleSignIn.disconnect();

    // TODO: add facebook sign out

    EasyLoading.dismiss();
  }

  Stream<WCUserAuthData?> get wcUserAuthStateChange {
    return _firebaseAuth.authStateChanges().map(_getWCUserAuthData);
  }

  WCUserAuthData? _getWCUserAuthData(User? user) {
    if (user == null) {
      return null;
    } else {
      return WCUserAuthData(userAuthID: user.uid);
    }
  }
}
