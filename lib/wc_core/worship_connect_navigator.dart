import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worship_connect/wc_core/wc_home_navigator.dart';
import 'package:worship_connect/wc_core/worship_connect_utilities.dart';
import 'package:worship_connect/sign_in/utils/wc_user_auth_data.dart';
import 'package:worship_connect/sign_in/utils/wc_user_info_data.dart';
import 'package:worship_connect/welcome/screens/welcome_page.dart';
import 'package:worship_connect/wc_core/core_providers_definition.dart';

class WorshipConnectNavigator extends ConsumerWidget {
  const WorshipConnectNavigator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final AsyncValue<WCUserAuthData?> wcUserAuthState = ref.watch(wcUserAuthStateStream);

    return wcUserAuthState.when(
      data: (data) {
        final AsyncValue<WCUserInfoData?> wcUserInfoData = ref.watch(wcUserInfoDataStream);

        return wcUserInfoData.when(
          data: (data) {
            EasyLoading.dismiss();

            if (data == null) {
              _pushToWelcomePage(context);
              return WCUtils.authLoadingWidget();
            }

            if (data.teamID.isEmpty || data.userName.isEmpty) {
              _pushToWelcomePage(context);
              return WCUtils.authLoadingWidget();
            } else {
              return const HomeNavigator();
            }
          },
          error: (err, stack) {
            return WCUtils.authLoadingWidget();
          },
          loading: () {
            return WCUtils.authLoadingWidget();
          },
        );
      },
      error: (err, stack) {
        _pushToWelcomePage(context);
        return Container();
      },
      loading: () {
        return WCUtils.authLoadingWidget();
      },
    );
  }
}

_pushToWelcomePage(BuildContext context) {
  WidgetsBinding.instance?.addPostFrameCallback(
    (_) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) {
            EasyLoading.dismiss();
            return const WelcomePage();
          },
        ),
      );
    },
  );
}
