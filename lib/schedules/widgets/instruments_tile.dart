import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worship_connect/schedules/screens/assign_members_page.dart';
import 'package:worship_connect/schedules/utils/schedules_providers_definition.dart';
import 'package:worship_connect/settings/services/team_firebase_api.dart';
import 'package:worship_connect/sign_in/utils/wc_user_info_data.dart';
import 'package:worship_connect/wc_core/core_providers_definition.dart';
import 'package:worship_connect/wc_core/worship_connect_utilities.dart';

class InstrumentsTile extends ConsumerWidget {
  const InstrumentsTile({Key? key, required this.instrument}) : super(key: key);

  final Map<String, dynamic> instrument;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List _musicians = instrument.values.first;
    WCUserInfoData? _wcUserInfoData = ref.watch(wcUserInfoDataStream).asData!.value;
    bool _isAdminOrLeader = WCUtils.isAdminOrLeader(_wcUserInfoData!);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _buildHeader(ref, _isAdminOrLeader),
        if (_musicians.isNotEmpty)
          ..._musicians.map(
            (element) {
              return _buildMusicianTile(context, ref, element, _isAdminOrLeader);
            },
          ),
        if (_musicians.isEmpty)
          Align(
            child: Text(
              'No musician for this instrument',
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
        _buildAddButton(context, ref),
      ],
    );
  }

  SizedBox _buildAddButton(BuildContext context, WidgetRef ref) {
    WCUserInfoData? _wcUserInfoData = ref.watch(wcUserInfoDataStream).asData!.value;

    return SizedBox(
      width: MediaQuery.of(context).size.width * 2 / 3,
      child: ListTile(
        leading: const Icon(Icons.add_circle_outline),
        title: const Text('Add'),
        onTap: () async {
          List<String> _completeMembersList = await TeamFirebaseAPI(_wcUserInfoData!.teamID).getCompleteMembersNamesList();
          List<String> _unassignedMembersList = ref.read(scheduleMusiciansProvider.notifier).getUnassignedMembersList(_completeMembersList);

          _unassignedMembersList.sort(
            (a, b) {
              return a.toLowerCase().compareTo(b.toLowerCase());
            },
          );

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return AssignMembersPage(
                  unassignedMembersList: _unassignedMembersList,
                  instrumentName: instrument.keys.first,
                );
              },
            ),
          );
        },
      ),
    );
  }

  ListTile _buildHeader(WidgetRef ref, bool _isAdminOrLeader) {
    return ListTile(
      trailing: Visibility(
        visible: _isAdminOrLeader,
        child: IconButton(
          onPressed: () {
            ref.read(scheduleMusiciansProvider.notifier).removeInstruments(instrument.keys.first);
          },
          icon: const Icon(Icons.delete_outline),
        ),
      ),
      title: Text(instrument.keys.first),
    );
  }

  SizedBox _buildMusicianTile(BuildContext context, WidgetRef ref, dynamic _element, bool _isAdminOrLeader) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 2 / 3,
      child: ListTile(
        trailing: Visibility(
          visible: _isAdminOrLeader,
          child: IconButton(
            onPressed: () {
              ref.read(scheduleMusiciansProvider.notifier).removeMusician(instrument: instrument.keys.first, musician: _element.toString());
            },
            icon: const Icon(Icons.delete_outline),
          ),
        ),
        title: Text(_element.toString()),
      ),
    );
  }
}
