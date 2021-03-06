import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worship_connect/schedules/utils/schedules_providers_definition.dart';
import 'package:worship_connect/schedules/widgets/add_instruments_card.dart';
import 'package:worship_connect/schedules/widgets/instruments_tile.dart';
import 'package:worship_connect/settings/utils/settings_providers_definition.dart';
import 'package:worship_connect/sign_in/utils/wc_user_info_data.dart';
import 'package:worship_connect/wc_core/worship_connect_utilities.dart';
import 'package:worship_connect/wc_core/core_providers_definition.dart';

class ScheduleInfoMusiciansPage extends ConsumerWidget {
  const ScheduleInfoMusiciansPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    WCUserInfoData? _wcUserInfoData = ref.watch(wcUserInfoDataStream).asData!.value;

    Map<String, dynamic> _instrumentsList = ref.watch(scheduleMusiciansProvider);

    return Column(
      children: [
        Expanded(
          child: Visibility(
            visible: _instrumentsList.isNotEmpty,
            replacement: Center(
              child: Text(
                'No instrument added for this schedule',
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ),
            child: RefreshIndicator(
              onRefresh: () {
                return Future.delayed(const Duration(seconds: 1)); //TODO make refresh indicator functional
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(4),
                itemBuilder: (context, index) {
                  String _instrumentName = _instrumentsList.keys.elementAt(index);

                  Map<String, dynamic> _instrumentData = Map<String, dynamic>.fromEntries(
                    _instrumentsList.entries.where(
                      (element) {
                        return element.key == _instrumentName;
                      },
                    ),
                  );

                  return InstrumentsTile(instrument: _instrumentData);
                },
                itemCount: _instrumentsList.keys.length,
              ),
            ),
          ),
        ),
        if (WCUtils.isAdminOrLeader(_wcUserInfoData!)) _buildButtons(context, ref),
        const SizedBox(
          height: 4,
        ),
      ],
    );
  }

  Row _buildButtons(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SizedBox(
          width: 12,
        ),
        Expanded(
          child: ElevatedButton(
            onPressed: () async {
              await ref.read(customInstrumentsListProvider.notifier).init();
              ref.read(customInstrumentProvider.state).state = '';

              showDialog(
                context: context,
                builder: (context) {
                  return const AddInstrumentsCard();
                },
              );
            },
            child: const Text('Add Instruments'),
          ),
        ),
        const SizedBox(
          width: 12,
        ),
        Expanded(
          child: ElevatedButton(
            onPressed: () async {
              ref.read(scheduleMusiciansProvider.notifier).saveMusicians();
            },
            child: const Text('Save'),
          ),
        ),
        const SizedBox(
          width: 12,
        ),
      ],
    );
  }
}
