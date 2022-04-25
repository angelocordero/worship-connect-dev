import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worship_connect/settings/utils/settings_providers_definition.dart';
import 'package:worship_connect/settings/utils/wc_team_data.dart';
import 'package:worship_connect/settings/services/team_firebase_api.dart';
import 'package:worship_connect/settings/widgets/change_team_name_card.dart';
import 'package:worship_connect/sign_in/utils/wc_user_info_data.dart';
import 'package:clipboard/clipboard.dart';
import 'package:worship_connect/wc_core/worship_connect_constants.dart';
import 'package:worship_connect/wc_core/worship_connect_utilities.dart';
import 'package:worship_connect/wc_core/core_providers_definition.dart';

class TeamSettings extends ConsumerWidget {
  const TeamSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    WCTeamData _teamData = ref.watch(wcWCTeamDataStream).asData?.value ?? WCTeamData.empty();
    WCUserInfoData? _userData = ref.watch(wcUserInfoDataStream).asData?.value;
    bool _isAdminOrLeader = WCUtils.isAdminOrLeader(_userData);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Team Settings',
              style: Theme.of(context).textTheme.subtitle1,
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
            _leaveTeamButton(userData: _userData, context: context),
          ],
        ),
      ),
    );
  }

  Padding _leaveTeamButton({
    required final WCUserInfoData? userData,
    required BuildContext context,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ElevatedButton(
        onPressed: () async {
          if (WCUtils.isAdminOrLeader(userData)) {
            WCUtils.wcShowError(wcError: 'Team leader and admin cannot leave team');
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
                      if (userData != null) {
                        await TeamFirebaseAPI(userData.teamID).leaveTeam(userData);
                      }
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
      trailing: wcTrailingIcon,
      onTap: () async {
        ref.read(membersListProvider.notifier).init();

        Navigator.pushNamed(context, '/memberListPage');
      },
    );
  }

  ListTile _teamIDTile(String _teamID) {
    return ListTile(
      title: Text(_teamID),
      subtitle: const Text('Team ID'),
      trailing: const Icon(Icons.copy),
      onTap: () async {
        if (_teamID.isEmpty) {
          WCUtils.wcShowError(wcError: 'Unable to copy team ID');
          return;
        }
        await FlutterClipboard.copy(_teamID);
        WCUtils.wcShowSuccess('Team ID copied to clipboard');
      },
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
          await TeamFirebaseAPI(teamID).toggleIsTeamOpen(isOpen);
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
        child: const Icon(
          Icons.edit_outlined,
        ),
      ),
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return ChangeTeamNameCard(
              teamName: teamName,
            );
          },
        );
      },
    );
  }
}
