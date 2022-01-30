import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worship_connect/wc_core/wc_themes.dart';
import 'package:worship_connect/wc_core/wc_user_firebase_api.dart';
import 'package:worship_connect/wc_core/worship_connect_navigator.dart';
import 'package:worship_connect/sign_in/data_classes/wc_user_auth_data.dart';
import 'package:worship_connect/sign_in/data_classes/wc_user_info_data.dart';
import 'package:worship_connect/sign_in/services/wc_user_authentication_service.dart';

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

class WorshipConnect extends ConsumerWidget {
  const WorshipConnect({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _wcTheme = ref.watch(wcThemeProvider);
    final _wcThemeNotifier = ref.watch(wcThemeProvider.notifier);

    _wcThemeNotifier.init();

    EasyLoading.instance
      ..indicatorType = EasyLoadingIndicatorType.fadingCube
      ..loadingStyle = EasyLoadingStyle.custom
      ..indicatorColor = Colors.blue
      ..textColor = Colors.white
      ..backgroundColor = Colors.white10
      ..userInteractions = false
      ..dismissOnTap = false
      ..errorWidget = const Icon(
        Icons.error,
        color: Colors.red,
      );

    return MaterialApp(
      builder: EasyLoading.init(),
      home: const WorshipConnectNavigator(),
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: _wcTheme,
    );
  }
}
