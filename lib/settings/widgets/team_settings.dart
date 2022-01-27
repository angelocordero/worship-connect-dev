import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worship_connect/settings/data_classes/wc_team_data.dart';
import 'package:worship_connect/settings/services/team_firebase_api.dart';
import 'package:worship_connect/sign_in/data_classes/wc_user_info_data.dart';
import 'package:worship_connect/wc_core/worship_connect.dart';
import 'package:clipboard/clipboard.dart';
import 'package:worship_connect/wc_core/worship_connect_utilities.dart';

final wcTeamDataStream = StreamProvider<TeamData>((ref) {
  final WCUserInfoData _wcUserInfoData = ref.watch(wcUserInfoDataStream).asData!.value!;

  return TeamFirebaseAPI(_wcUserInfoData.teamID).teamData();
});

class TeamSettings extends ConsumerWidget {
  const TeamSettings({Key? key}) : super(key: key);

  static Icon trailingIcon = const Icon(Icons.arrow_forward_ios);

  ListTile _leaveTeamTile(WCUserInfoData _userData) {
    return ListTile(
      title: const Text('Leave Team'),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: () async {
        await TeamFirebaseAPI(_userData.teamID).leaveTeam(_userData);
      },
    );
  }

  ListTile _membersTile() {
    return ListTile(
      title: const Text('Members'),
      trailing: const Icon(Icons.arrow_forward_ios),
      //TODO: members list page
      onTap: () {},
    );
  }

  Visibility _teamInvitesTile({
    required bool isOpen,
    required bool isAdminOrLeader,
    required String teamID,
  }) {
    return Visibility(
      visible: isAdminOrLeader,
      child: SwitchListTile(
        title: const Text('Allow Team Invites'),
        value: isOpen,
        onChanged: (value) async {
          TeamFirebaseAPI(teamID).toggleIsTeamOpen(isOpen);
        },
      ),
    );
  }

  ListTile _teamIDTile(String _teamID) {
    return ListTile(
      title: Text(_teamID),
      subtitle: const Text('Team ID'),
      trailing: const Icon(Icons.copy),
      onTap: () async {
        if (_teamID.isEmpty) {
          WCUtils().wcShowError('Unable to copy team ID');
          return;
        }
        await FlutterClipboard.copy(_teamID);
        WCUtils().wcShowSuccess('Team ID copied to clipboard');
      },
    );
  }

  ListTile _teamNameTile(String _teamName) {
    //TODO: allow name change
    return ListTile(
      title: Text(_teamName),
      subtitle: const Text('Team Name'),
      trailing: trailingIcon,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TeamData _teamData = ref.watch(wcTeamDataStream).asData?.value ?? TeamData.empty();
    WCUserInfoData? _userData = ref.watch(wcUserInfoDataStream).asData?.value;

    return Card(
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Team Settings'),
            const Divider(),
            _teamNameTile(_teamData.teamName),
            _teamIDTile(_teamData.teamID),
            _teamInvitesTile(
              isOpen: _teamData.isOpen,
              isAdminOrLeader: WCUtils().isAdminOrLeader(_userData!),
              teamID: _teamData.teamID,
            ),
            _membersTile(),
            _leaveTeamTile(_userData)
          ],
        ),
      ),
    );
  }
}
