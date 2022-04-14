import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:page_transition/page_transition.dart';
import 'package:worship_connect/sign_in/utils/wc_user_info_data.dart';
import 'package:worship_connect/sign_in/widgets/wc_login_screen_logo.dart';
import 'package:worship_connect/wc_core/core_providers_definition.dart';
import 'package:worship_connect/welcome/screens/join_create_team_page.dart';
import 'package:worship_connect/welcome/widgets/enter_name_widget.dart';

class EnterNamePage extends ConsumerStatefulWidget {
  const EnterNamePage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EnterNamePageState();
}

class _EnterNamePageState extends ConsumerState<EnterNamePage> {
  double _opacity = 1;

  @override
  Widget build(BuildContext context) {
    WCUserInfoData? _wcUserInfoData = ref.watch(wcUserInfoDataStream).asData?.value;

    bool isOnTop = ModalRoute.of(context)?.isCurrent ?? false;

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

    return Column(
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
        Hero(
          tag: 'name',
          child: AnimatedOpacity(
            opacity: _opacity,
            duration: const Duration(milliseconds: 300),
            child: const EnterNameWidget(),
          ),
        ),
        const Spacer(),
      ],
    );
  }
}
