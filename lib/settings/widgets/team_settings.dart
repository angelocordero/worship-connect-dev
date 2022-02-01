import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worship_connect/settings/data_classes/wc_team_data.dart';
import 'package:worship_connect/settings/providers/members_list_provider.dart';
import 'package:worship_connect/settings/screens/member_list_page.dart';
import 'package:worship_connect/settings/services/team_firebase_api.dart';
import 'package:worship_connect/settings/widgets/change_team_name_card.dart';
import 'package:worship_connect/sign_in/data_classes/wc_user_info_data.dart';
import 'package:worship_connect/wc_core/wc_custom_route.dart';
import 'package:worship_connect/wc_core/worship_connect.dart';
import 'package:clipboard/clipboard.dart';
import 'package:worship_connect/wc_core/worship_connect_constants.dart';
import 'package:worship_connect/wc_core/worship_connect_utilities.dart';

final wcTeamDataStream = StreamProvider<TeamData>((ref) {
  final WCUserInfoData _wcUserInfoData = ref.watch(wcUserInfoDataStream).asData!.value!;

  return TeamFirebaseAPI(_wcUserInfoData.teamID).teamData();
});

final membersListProvider = StateNotifierProvider.autoDispose<MembersListProvider, dynamic>(
  (ref) {
    AsyncData<WCUserInfoData?>? wcUserInfoData = ref.watch(wcUserInfoDataStream).asData;

    return MembersListProvider(
      teamID: wcUserInfoData?.value?.teamID ?? '',
    );
  },
);

class TeamSettings extends ConsumerWidget {
  const TeamSettings({Key? key}) : super(key: key);

  Padding _leaveTeamButton({
    required WCUserInfoData userData,
    required BuildContext context,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(shape: wcButtonShape),
        onPressed: () async {
          if (WCUtils().isAdminOrLeader(userData)) {
            WCUtils().wcShowError('Team leader and admins cannot leave team');
            return;
          }

          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Leave team?'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('No'),
                  ),
                  TextButton(
                    onPressed: () async {
                      await TeamFirebaseAPI(userData.teamID).leaveTeam(userData);
                      Navigator.pop(context);
                    },
                    child: const Text('Yes'),
                  ),
                ],
              );
            },
          );
        },
        child: const Text('Leave Team'),
      ),
    );
  }

  ListTile _membersTile(BuildContext context, WidgetRef ref) {
    return ListTile(
      title: const Text('Members'),
      trailing: IconButton(
        icon: wcTrailingIcon,
        onPressed: () async {
          await ref.read(membersListProvider.notifier).initMemberList();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) {
                return const MembersListPage();
              },
            ),
          );
        },
      ),
    );
  }

  Visibility _teamInvitesTile({
    required bool isOpen,
    required bool isAdminOrLeader,
    required String teamID,
  }) {
    return Visibility(
      visible: isAdminOrLeader,
      child: ListTile(
        title: const Text('Allow Team Invites'),
        trailing: Switch(
          value: isOpen,
          onChanged: (value) async {
            TeamFirebaseAPI(teamID).toggleIsTeamOpen(isOpen);
          },
        ),
      ),
    );
  }

  ListTile _teamIDTile(String _teamID) {
    return ListTile(
      title: Text(_teamID),
      subtitle: const Text('Team ID'),
      trailing: IconButton(
        icon: const Icon(Icons.copy),
        onPressed: () async {
          if (_teamID.isEmpty) {
            WCUtils().wcShowError('Unable to copy team ID');
            return;
          }
          await FlutterClipboard.copy(_teamID);
          WCUtils().wcShowSuccess('Team ID copied to clipboard');
        },
      ),
    );
  }

  ListTile _teamNameTile({
    required String teamName,
    required bool isAdminOrLeader,
    required BuildContext context,
  }) {
    return ListTile(
      title: Text(teamName),
      subtitle: const Text('Team Name'),
      trailing: Visibility(
        visible: isAdminOrLeader,
        child: Hero(
          tag: 'teamName',
          child: IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                WCCustomRoute(
                  builder: (context) {
                    return ChangeTeamNameCard(
                      teamName: teamName,
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TeamData _teamData = ref.watch(wcTeamDataStream).asData?.value ?? TeamData.empty();
    WCUserInfoData? _userData = ref.watch(wcUserInfoDataStream).asData?.value;
    bool _isAdminOrLeader = WCUtils().isAdminOrLeader(_userData!);

    return Card(
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Align(
              child: Text('Team Settings'),
              alignment: Alignment.centerLeft,
            ),
            const Divider(),
            _teamNameTile(
              context: context,
              teamName: _teamData.teamName,
              isAdminOrLeader: _isAdminOrLeader,
            ),
            _teamIDTile(_teamData.teamID),
            _teamInvitesTile(
              isOpen: _teamData.isOpen,
              teamID: _teamData.teamID,
              isAdminOrLeader: _isAdminOrLeader,
            ),
            _membersTile(context, ref),
            _leaveTeamButton(userData: _userData, context: context)
          ],
        ),
      ),
    );
  }
}
