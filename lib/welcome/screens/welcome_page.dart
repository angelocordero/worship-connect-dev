import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worship_connect/wc_core/worship_connect.dart';
import 'package:worship_connect/wc_core/worship_connect_constants.dart';
import 'package:worship_connect/wc_core/worship_connect_navigator.dart';
import 'package:worship_connect/wc_core/worship_connect_utilities.dart';
import 'package:worship_connect/sign_in/utils/wc_user_auth_data.dart';
import 'package:worship_connect/sign_in/utils/wc_user_info_data.dart';
import 'package:worship_connect/sign_in/services/wc_user_authentication_service.dart';
import 'package:worship_connect/sign_in/widgets/facebook_signin_button.dart';
import 'package:worship_connect/sign_in/widgets/google_signin_button.dart';
import 'package:worship_connect/sign_in/widgets/wc_login_screen_logo.dart';
import 'package:worship_connect/welcome/widgets/edit_name_widget.dart';
import 'package:worship_connect/welcome/widgets/enter_name_widget.dart';
import 'package:worship_connect/welcome/widgets/join_create_team_form_switcher.dart';



class WelcomePage extends ConsumerStatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => WelcomePageState();
}

class WelcomePageState extends ConsumerState<WelcomePage> {
  Duration? enterNameWidgetDuration;
  double? editNameWidgetOpacityAnimated;
  double? enterNameWidgetBottomInitial;
  double? enterNameWidgetBottomDisplay;
  double? enterNameWidgetBottomAnimated;
  double? enterNameWidgetBottomFinal;
  double? formSwitcherBottomAnimated;
  double? formSwitcherBottomFinal;
  double? formSwitcherBottomInitial;
  double? logoWidgetTopAnimated;
  double? logoWidgetTopFinal;
  double? logoWidgetTopInitial;
  double? signInWidgetLeftAnimated;
  double? signInWidgetLeftFinal;
  double? signInWidgetLeftInitial;

  Positioned testingButton() {
    return Positioned(
      bottom: 0,
      child: ElevatedButton(
          onPressed: () {
            WCUserAuthentication().signOut();
          },
          child: const Text('asd')),
    );
  }

  AnimatedPositioned _enterNameWidget() {
    return AnimatedPositioned(
      bottom: enterNameWidgetBottomAnimated,
      left: null,
      child: const EnterNameWidget(),
      duration: enterNameWidgetDuration!,
    );
  }

  AnimatedPositioned _signInWidget() {
    return AnimatedPositioned(
      bottom: 0,
      width: wcSignInButtonSize.width,
      left: signInWidgetLeftAnimated,
      duration: const Duration(milliseconds: 500),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        children: const [
          GoogleSignInButton(),
          FacebookSignInButton(),
        ],
      ),
    );
  }

  AnimatedPositioned _logoWidget() {
    return AnimatedPositioned(
      top: logoWidgetTopAnimated,
      child: const WCLoginScreenLogo(),
      duration: const Duration(milliseconds: 500),
    );
  }

  AnimatedOpacity _editNameWidget() {
    return AnimatedOpacity(
      opacity: editNameWidgetOpacityAnimated!,
      child: const EditNameWidget(),
      duration: const Duration(milliseconds: 500),
    );
  }

  AnimatedPositioned _joinCreateTeamFormSwitcher() {
    return AnimatedPositioned(
      bottom: formSwitcherBottomAnimated,
      child: const JoinCreateTeamFormSwitcher(),
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  Widget build(BuildContext context) {
    AsyncData<WCUserAuthData?>? wcUserAuthState = ref.watch(wcUserAuthStateStream).asData;
    AsyncData<WCUserInfoData?>? wcUserInfoData = ref.watch(wcUserInfoDataStream).asData;

    signInWidgetLeftInitial = (WCUtils().screenWidth(context) - wcSignInButtonSize.width) / 2;
    signInWidgetLeftFinal = -300;

    logoWidgetTopInitial = 0;
    logoWidgetTopFinal = -500;
    enterNameWidgetBottomInitial = -300;

    if (wcUserAuthState == null) {
      enterNameWidgetBottomAnimated = enterNameWidgetBottomInitial;
      signInWidgetLeftAnimated = signInWidgetLeftInitial;
    } else {
      signInWidgetLeftAnimated = signInWidgetLeftFinal;
    }

    enterNameWidgetBottomDisplay = WCUtils().screenHeight(context) / 3;
    enterNameWidgetBottomFinal = WCUtils().screenHeight(context);
    enterNameWidgetDuration = const Duration(milliseconds: 300);
    formSwitcherBottomInitial = -300;
    formSwitcherBottomFinal = WCUtils().screenHeight(context) / 5;
    formSwitcherBottomAnimated = formSwitcherBottomInitial;

    if (wcUserInfoData == null) {
      enterNameWidgetBottomAnimated = enterNameWidgetBottomInitial;
      editNameWidgetOpacityAnimated = 0;
    } else if (wcUserInfoData.value!.userName.isNotEmpty) {
      enterNameWidgetBottomAnimated = enterNameWidgetBottomFinal;
      logoWidgetTopAnimated = logoWidgetTopFinal;
      editNameWidgetOpacityAnimated = 1;

      if (wcUserInfoData.value!.teamID.isNotEmpty && mounted) {
        enterNameWidgetDuration = const Duration(seconds: 0);
        WidgetsBinding.instance?.addPostFrameCallback(
          (_) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return const WorshipConnectNavigator();
                },
              ),
            );
          },
        );
      } else {
        formSwitcherBottomAnimated = formSwitcherBottomFinal;
      }
    } else {
      enterNameWidgetBottomAnimated = enterNameWidgetBottomDisplay;
      logoWidgetTopAnimated = logoWidgetTopInitial;
      editNameWidgetOpacityAnimated = 0;
    }

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: const AssetImage('assets/bg_image.jpg'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.5),
            BlendMode.darken,
          ),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: SizedBox(
            height: WCUtils().screenHeight(context),
            width: WCUtils().screenWidth(context),
            child: Stack(
              alignment: AlignmentDirectional.topCenter,
              children: [
                testingButton(),
                _logoWidget(),
                _signInWidget(),
                _enterNameWidget(),
                _editNameWidget(),
                _joinCreateTeamFormSwitcher(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
