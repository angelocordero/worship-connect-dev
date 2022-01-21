import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:worship_connect/wc_core/worship_connect.dart';
import 'package:worship_connect/wc_core/worship_connect_constants.dart';
import 'package:worship_connect/wc_sign_in/data_classes/wc_user_info_data.dart';
import 'package:worship_connect/wc_welcome/screens/welcome_page.dart';
import 'package:worship_connect/wc_welcome/services/create_join_team_firebase_api.dart';
import 'package:worship_connect/wc_welcome/widgets/create_team_form.dart';
import 'package:worship_connect/wc_welcome/widgets/join_team_form.dart';

final createTeamNameProvider = StateProvider.autoDispose<String>((ref) {
  return '';
});

final joinTeamIDProvider = StateProvider.autoDispose<String>((ref) {
  return '';
});

class JoinCreateTeamFormSwitcher extends StatefulWidget {
  const JoinCreateTeamFormSwitcher({Key? key}) : super(key: key);

  @override
  State<JoinCreateTeamFormSwitcher> createState() => _JoinCreateTeamFormSwitcherState();
}

class _JoinCreateTeamFormSwitcherState extends State<JoinCreateTeamFormSwitcher> {
  String buttonText = 'Join Team';
  late List<Color> createColor = inactiveButtonColor;
  int currentIndex = 0;
  double? dividerRight = 146;
  List<Color> inactiveButtonColor = [Colors.white38, Colors.white38];
  List<Color> joinColor = wcGradientColors;
  List<Widget> pages = const [
    JoinTeamForm(),
    CreateTeamForm(),
  ];

  Positioned _joinTeamButton() {
    return Positioned(
      top: 0,
      left: 20,
      right: 130,
      height: 30,
      child: TextButton(
        onPressed: () {
          setState(
            () {
              buttonText = 'Join Team';
              joinColor = wcGradientColors;
              createColor = inactiveButtonColor;
              currentIndex = 0;
              dividerRight = 146;
            },
          );
        },
        child: GradientText(
          'JOIN',
          colors: joinColor,
        ),
      ),
    );
  }

  Positioned _createTeamButton() {
    return Positioned(
      top: 0,
      right: 20,
      left: 130,
      height: 30,
      child: TextButton(
        onPressed: () {
          setState(
            () {
              buttonText = 'Create Team';
              joinColor = inactiveButtonColor;
              createColor = wcGradientColors;
              currentIndex = 1;
              dividerRight = 33;
            },
          );
        },
        child: GradientText(
          'CREATE',
          colors: createColor,
        ),
      ),
    );
  }

  Positioned _divider() {
    return const Positioned(
      top: 25,
      left: 11,
      width: 200,
      child: Divider(
        thickness: 3,
        color: Colors.white38,
      ),
    );
  }

  Positioned _joinCreateFormView() {
    return Positioned(
      top: 40,
      height: 140,
      width: 200,
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: IndexedStack(
          index: currentIndex,
          children: pages,
        ),
      ),
    );
  }

  Positioned _joinCreateButton() {
    return Positioned(
      right: 50,
      left: 50,
      bottom: 0,
      height: 30,
      child: Consumer(
        builder: (context, ref, child) {
          String _joinTeamID = ref.watch<String>(joinTeamIDProvider);
          String _createTeamName = ref.watch<String>(createTeamNameProvider);
          String _userName = ref.watch<String>(userNameProvider);

          AsyncData<WCUserInfoData?>? _wcUserInfoData = ref.watch(wcUserInfoDataStream).asData;

          String? _userID = _wcUserInfoData?.value?.userID;

          return ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.zero,
              shape: wcButtonShape,
            ),
            onPressed: () async {
              if (currentIndex == 0) {
                await CreateJoinTeamFirebaseAPI().joinTeam(
                  teamID: _joinTeamID,
                  joinerName: _userName,
                  joinerID: _userID ?? '',
                );
              } else {
                await CreateJoinTeamFirebaseAPI().createTeam(
                  teamName: _createTeamName,
                  creatorID: _userID ?? '',
                  creatorName: _userName,
                );
              }
            },
            child: Ink(
              decoration: BoxDecoration(
                gradient: wcLinearGradient,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  buttonText,
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  AnimatedPositioned _dividerAnimated() {
    return AnimatedPositioned(
      top: 31,
      right: dividerRight,
      width: 40,
      height: 4,
      duration: const Duration(milliseconds: 300),
      child: Container(
        decoration: BoxDecoration(
          gradient: wcLinearGradient,
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      width: 250,
      decoration: BoxDecoration(
        color: Colors.black38,
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
        border: Border.all(color: wcPrimaryColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Stack(
          alignment: AlignmentDirectional.center,
          clipBehavior: Clip.none,
          children: [
            _joinTeamButton(),
            _createTeamButton(),
            _divider(),
            _joinCreateButton(),
            _joinCreateFormView(),
            _dividerAnimated(),
          ],
        ),
      ),
    );
  }
}
