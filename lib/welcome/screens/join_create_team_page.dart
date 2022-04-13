import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worship_connect/sign_in/utils/wc_user_info_data.dart';
import 'package:worship_connect/wc_core/core_providers_definition.dart';
import 'package:worship_connect/welcome/widgets/edit_name_widget.dart';
import 'package:worship_connect/welcome/widgets/join_create_team_form_switcher.dart';

class JoinCreateTeamPage extends ConsumerWidget {
  const JoinCreateTeamPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    WCUserInfoData? _wcUserInfoData = ref.watch(wcUserInfoDataStream).asData?.value;

    bool isOnTop = ModalRoute.of(context)?.isCurrent ?? false;

    if (_wcUserInfoData != null && _wcUserInfoData.userName.isNotEmpty && _wcUserInfoData.teamID.isNotEmpty && isOnTop) {
      WidgetsBinding.instance?.addPostFrameCallback(
        (_) async {
          await Navigator.pushReplacementNamed(context, '/home');
        },
      );
    }

    return Column(
      children: const [
        Hero(
          tag: 'name',
          child: EditNameWidget(),
        ),
        Spacer(),
        JoinCreateTeamFormSwitcher(),
        Spacer(),
      ],
    );
  }
}
