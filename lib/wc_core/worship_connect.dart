import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worship_connect/sign_in/screens/login_page.dart';
import 'package:worship_connect/sign_in/utils/wc_user_info_data.dart';
import 'package:worship_connect/wc_core/wc_home_navigator.dart';
import 'package:worship_connect/wc_core/core_providers_definition.dart';

class WorshipConnect extends ConsumerWidget {
  const WorshipConnect({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _wcTheme = ref.watch(wcThemeProvider);
    final _wcThemeNotifier = ref.watch(wcThemeProvider.notifier);
    WCUserInfoData? _wcUserInfoData = ref.watch(wcUserInfoDataStream).asData?.value;

    _wcThemeNotifier.init();

    FirebaseCrashlytics.instance.setUserIdentifier(_wcUserInfoData?.userID ?? '');

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
      showPerformanceOverlay: kProfileMode ? true : false,
      builder: EasyLoading.init(),
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: _wcTheme,
      routes: {
        '/': (context) => const LoginPage(),
        '/home': (context) => const HomeNavigator(),
      },
    );
  }
}
