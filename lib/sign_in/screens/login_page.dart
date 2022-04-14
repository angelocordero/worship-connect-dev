import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:page_transition/page_transition.dart';
import 'package:worship_connect/sign_in/utils/wc_user_info_data.dart';
import 'package:worship_connect/sign_in/widgets/facebook_signin_button.dart';
import 'package:worship_connect/sign_in/widgets/google_signin_button.dart';
import 'package:worship_connect/sign_in/widgets/wc_login_screen_logo.dart';
import 'package:worship_connect/wc_core/core_providers_definition.dart';
import 'package:worship_connect/welcome/screens/enter_name_page.dart';
import 'package:worship_connect/welcome/screens/join_create_team_page.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  double _opacity = 1;

  @override
  Widget build(BuildContext context) {
    WCUserInfoData? _wcUserInfoData = ref.watch(wcUserInfoDataStream).asData?.value;
    bool isOnTop = ModalRoute.of(context)?.isCurrent ?? false;

    if (_wcUserInfoData != null && _wcUserInfoData.userName.isEmpty && isOnTop) {
      WidgetsBinding.instance?.addPostFrameCallback(
        (_) async {
          setState(() {
            _opacity = 0;
          });

          await Navigator.push(
            context,
            PageTransition(
              child: const EnterNamePage(),
              type: PageTransitionType.leftToRightWithFade,
            ),
          );
        },
      );
    }

    if (_wcUserInfoData != null && _wcUserInfoData.userName.isNotEmpty && _wcUserInfoData.teamID.isEmpty && isOnTop) {

      WidgetsBinding.instance?.addPostFrameCallback(
        (_) async {
          setState(() {
            _opacity = 0;
          });
          await Navigator.push(
            context,
            PageTransition(
              child: const JoinCreateTeamPage(),
              type: PageTransitionType.bottomToTop,
            ),
          );
        },
      );
    }

    if (_wcUserInfoData != null && _wcUserInfoData.userName.isNotEmpty && _wcUserInfoData.teamID.isNotEmpty && isOnTop) {
      WidgetsBinding.instance?.addPostFrameCallback(
        (_) async {
          await Navigator.pushReplacementNamed(context, '/home');
        },
      );
    }

    return Container(
      color: Colors.black,
      child: SafeArea(
        child: Container(
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
          child: Column(
            children: [
              Hero(
                tag: 'logo',
                child: AnimatedOpacity(
                  opacity: _opacity,
                  duration: const Duration(milliseconds: 300),
                  child: const WCLoginScreenLogo(),
                ),
              ),
              const Spacer(),
              AnimatedOpacity(
                opacity: _opacity,
                duration: const Duration(milliseconds: 300),
                child: const GoogleSignInButton(),
              ),
              const SizedBox(
                height: 20,
              ),
              AnimatedOpacity(
                opacity: _opacity,
                duration: const Duration(milliseconds: 300),
                child: const FacebookSignInButton(),
              ),
              const SizedBox(
                height: 70,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
