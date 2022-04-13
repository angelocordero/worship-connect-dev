import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worship_connect/sign_in/screens/login_page.dart';
import 'package:worship_connect/sign_in/utils/wc_user_auth_data.dart';
import 'package:worship_connect/sign_in/utils/wc_user_info_data.dart';
import 'package:worship_connect/wc_core/wc_home_navigator.dart';
import 'package:worship_connect/wc_core/worship_connect_utilities.dart';
import 'package:worship_connect/wc_core/core_providers_definition.dart';
import 'package:worship_connect/welcome/screens/enter_name_page.dart';
import 'package:worship_connect/welcome/screens/join_create_team_page.dart';

class WorshipConnectNavigator extends ConsumerWidget {
  const WorshipConnectNavigator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final WCUserAuthData? _wcUserAuthState = ref.watch(wcUserAuthStateStream).value;


    bool isOnTop = ModalRoute.of(context)?.isCurrent ?? false;

    if (_wcUserAuthState?.userAuthID == null && isOnTop) {

      WidgetsBinding.instance?.addPostFrameCallback(
        (_) async {
          await Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) {
                EasyLoading.dismiss();
                return const LoginPage();
              },
            ),
          );
        },
      );
    }

    final WCUserInfoData? _wcUserInfoData = ref.watch(wcUserInfoDataStream).value;
    if (_wcUserAuthState != null && _wcUserInfoData?.userID != null && _wcUserInfoData!.userName.isEmpty && isOnTop) {

      WidgetsBinding.instance?.addPostFrameCallback(
        (_) async {
          await Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) {
                EasyLoading.dismiss();
                return const EnterNamePage();
              },
            ),
          );
        },
      );
    }

    if (_wcUserAuthState != null &&
        _wcUserInfoData?.userID != null &&
        _wcUserInfoData!.userName.isNotEmpty &&
        _wcUserInfoData.teamID.isEmpty &&
        isOnTop) {

      WidgetsBinding.instance?.addPostFrameCallback(
        (_) async {
          await Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) {
                EasyLoading.dismiss();
                return const JoinCreateTeamPage();
              },
            ),
          );
        },
      );
    }

    if (_wcUserInfoData != null) {
      return const HomeNavigator();
    }

    return WCUtils.authLoadingWidget();
  }
}
