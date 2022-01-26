import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worship_connect/settings/data_classes/wc_team_data.dart';
import 'package:worship_connect/settings/services/team_firebase_api.dart';
import 'package:worship_connect/sign_in/data_classes/wc_user_info_data.dart';
import 'package:worship_connect/wc_core/worship_connect.dart';

final wcTeamDataStream = StreamProvider<TeamData>((ref) {
  final WCUserInfoData _wcUserInfoData = ref.watch(wcUserInfoDataStream).asData!.value!;

  return TeamFirebaseAPI(_wcUserInfoData.teamID).teamData();
});

class TeamSettings extends ConsumerWidget {
  const TeamSettings({Key? key}) : super(key: key);

  static Icon trailingIcon = const Icon(Icons.arrow_forward_ios);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TeamData? _teamData = ref.watch(wcTeamDataStream).asData?.value;


    return Card(
      margin: const EdgeInsets.all(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Team Settings'),
          ListTile(
            title: Text(_teamData?.teamName ?? ''),
            subtitle: const Text('Team Name'),
            trailing: trailingIcon,
          ),
        ],
      ),
    );
  }
}
