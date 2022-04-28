import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worship_connect/schedules/utils/schedule_data.dart';
import 'package:worship_connect/schedules/utils/schedules_providers_definition.dart';
import 'package:worship_connect/schedules/widgets/schedules_calendar_tile.dart';
import 'package:worship_connect/wc_core/worship_connect_utilities.dart';

class SchedulesSummaryPage extends ConsumerWidget {
  const SchedulesSummaryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Map<String, dynamic> _scheduleData = ref.watch(calendarScheduleListProvider);

    List<String> _scheduleKeys = _scheduleData.keys.toList();

    _scheduleKeys.sort(
      (a, b) {
        return a.compareTo(b);
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedules Summary'),
      ),
      body: ListView.builder(
        itemCount: _scheduleKeys.length,
        itemBuilder: (context, index) {
          String _indexKey = _scheduleKeys[index];

          List _scheduleList = _scheduleData[_indexKey];

          if (_scheduleList.isEmpty) {
            return Container();
          }

          List<WCScheduleData> _scheduleDataList = _scheduleList.map(
            (element) {
              return WCScheduleData(
                scheduleTitle: element['scheduleTitle'],
                scheduleID: element['scheduleID'],
                timestamp: element['timestamp'],
                scheduleDateCode: element['scheduleDateCode'],
              );
            },
          ).toList();

          _scheduleDataList.sort(
            (a, b) {
              return a.timestamp.compareTo(b.timestamp);
            },
          );

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(
                  WCUtils.dateToString(
                    DateTime.parse(_indexKey),
                  ),
                  style: Theme.of(context).textTheme.bodyText1?.copyWith(fontSize: 16),
                ),
                dense: true,
                visualDensity: VisualDensity.compact,
              ),
              ..._scheduleDataList.map(
                (element) {
                  return SchedulesCalendarTile(scheduleData: element);
                },
              ),
              const Divider(
                height: 2,
              ),
            ],
          );
        },
      ),
    );
  }
}
