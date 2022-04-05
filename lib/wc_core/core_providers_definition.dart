import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worship_connect/sign_in/services/wc_user_authentication_service.dart';
import 'package:worship_connect/sign_in/utils/wc_user_auth_data.dart';
import 'package:worship_connect/sign_in/utils/wc_user_info_data.dart';
import 'package:worship_connect/wc_core/wc_themes.dart';
import 'package:worship_connect/wc_core/wc_user_firebase_api.dart';

final wcUserAuthStateStream = StreamProvider<WCUserAuthData?>(
  (ref) {
    return WCUserAuthentication().wcUserAuthStateChange;
  },
);

final wcUserInfoDataStream = StreamProvider<WCUserInfoData?>(
  (ref) {
    final AsyncValue<WCUserAuthData?>? wcUserAuthState = ref.watch(wcUserAuthStateStream);

    return WCUSerFirebaseAPI().wcUserInfoDataStream(wcUserAuthState?.value?.userAuthID);
  },
);

final wcThemeProvider = StateNotifierProvider<WCThemeProvider, ThemeMode>(
  (ref) {
    return WCThemeProvider();
  },
);