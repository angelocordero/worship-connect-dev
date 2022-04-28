import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worship_connect/schedules/screens/assign_members_page.dart';
import 'package:worship_connect/schedules/utils/schedules_providers_definition.dart';
import 'package:worship_connect/schedules/widgets/wc_custom_collapsible_widget.dart';
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
        _buildHeader(context, ref, _isAdminOrLeader),
        if (_musicians.isNotEmpty)
          ..._musicians.map(
            (element) {
              return _buildMusicianTile(context, ref, element, _isAdminOrLeader);
            },
          ),
        if (_musicians.isEmpty)
          Align(
            child: Text(
              'No member assigned for this instrument',
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
        _buildAddButton(context, ref),
        const Divider(),
      ],
    );
  }

  SizedBox _buildAddButton(BuildContext context, WidgetRef ref) {
    WCUserInfoData? _wcUserInfoData = ref.watch(wcUserInfoDataStream).asData!.value;

    return SizedBox(
      width: WCUtils.screenWidth(context) * 2 / 3,
      child: WCCustomCollapsibleWidget(
        child: ListTile(
          visualDensity: VisualDensity.compact,
          leading: const Icon(Icons.add_circle_outline),
          title: Text(
            'Assign members',
            style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 16),
          ),
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
        axisAlignment: 0.0,
      ),
    );
  }

  ListTile _buildHeader(BuildContext context, WidgetRef ref, bool _isAdminOrLeader) {
    return ListTile(
      visualDensity: VisualDensity.compact,
      // trailing: IconButton(
      //   onPressed: () {

      //       ref.read(scheduleMusiciansProvider.notifier).removeInstruments(instrument.keys.first);

      //   },
      //   icon: AnimatedCrossFade(
      //     duration: const Duration(milliseconds: 300),
      //     crossFadeState: ref.watch(isEditingProvider) ? CrossFadeState.showSecond : CrossFadeState.showFirst,
      //     firstChild: const SizedBox(
      //       width: 24,
      //       height: 24,
      //     ),
      //     secondChild: const Icon(
      //       Icons.delete_outline,
      //     ),
      //   ),
      // ),
      trailing: AnimatedCrossFade(
        firstChild: const SizedBox(
          width: 48,
          height: 48,
        ),
        secondChild: IconButton(
            onPressed: () {
              ref.read(scheduleMusiciansProvider.notifier).removeInstruments(instrument.keys.first);
            },
            icon: const Icon(Icons.delete_outline)),
        crossFadeState: ref.watch(isEditingProvider) ? CrossFadeState.showSecond : CrossFadeState.showFirst,
        duration: const Duration(milliseconds: 250),
      ),
      title: Text(
        instrument.keys.first,
        style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 16),
      ),
    );
  }

  SizedBox _buildMusicianTile(BuildContext context, WidgetRef ref, dynamic _element, bool _isAdminOrLeader) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 2 / 3,
      child: ListTile(
        visualDensity: VisualDensity.compact,
      
        trailing: AnimatedCrossFade(
          firstChild: const SizedBox(
            width: 48,
            height: 48,
          ),
          secondChild: IconButton(
              onPressed: () {
                ref.read(scheduleMusiciansProvider.notifier).removeMusician(instrument: instrument.keys.first, musician: _element.toString());
              },
              icon: const Icon(Icons.delete_outline)),
          crossFadeState: ref.watch(isEditingProvider) ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 250),
        ),
        title: Text(_element.toString()),
      ),
    );
  }
}
