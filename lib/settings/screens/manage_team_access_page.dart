import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worship_connect/settings/services/team_firebase_api.dart';
import 'package:worship_connect/settings/utils/settings_providers_definition.dart';
import 'package:worship_connect/settings/utils/wc_team_data.dart';

class ManageTeamAccessPage extends ConsumerWidget {
  const ManageTeamAccessPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    WCTeamData _teamData = ref.watch(wcWCTeamDataStream).asData?.value ?? WCTeamData.empty();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Team Access'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            RadioListTile<bool>(
              controlAffinity: ListTileControlAffinity.trailing,
              title: const Text('Allow Team ID Access'),
              visualDensity: VisualDensity.compact,
              value: true,
              groupValue: _teamData.isOpen,
              onChanged: (value) async {
                await TeamFirebaseAPI(_teamData.teamID).toggleIsTeamOpen(value!);
              },
            ),
            RadioListTile<bool>(
              controlAffinity: ListTileControlAffinity.trailing,
              title: const Text('Disallow Team ID Access'),
              visualDensity: VisualDensity.compact,
              value: false,
              groupValue: _teamData.isOpen,
              onChanged: (value) async {
                await TeamFirebaseAPI(_teamData.teamID).toggleIsTeamOpen(value!);
              },
            ),
            const SizedBox(
              height: 16,
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: _teamData.isOpen
                    ? const Text('When allowed, anyone with the Team ID can join the team.')
                    : const Text('When disallowed, all requests to join the team will be blocked.'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
