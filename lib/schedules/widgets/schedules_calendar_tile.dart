import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worship_connect/schedules/utils/schedule_data.dart';
import 'package:worship_connect/schedules/services/schedules_firebase_api.dart';
import 'package:worship_connect/schedules/widgets/edit_schedule_card.dart';
import 'package:worship_connect/sign_in/utils/wc_user_info_data.dart';
import 'package:worship_connect/schedules/utils/schedules_providers_definition.dart';
import 'package:worship_connect/wc_core/wc_custom_route.dart';
import 'package:worship_connect/wc_core/worship_connect_utilities.dart';
import 'package:worship_connect/wc_core/core_providers_definition.dart';

class SchedulesCalendarTile extends ConsumerWidget {
  const SchedulesCalendarTile({Key? key, required this.scheduleData}) : super(key: key);

  final WCScheduleData scheduleData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    WCUserInfoData? _wcUserInfoData = ref.watch(wcUserInfoDataStream).asData!.value;

    return ListTile(
      title: Text(scheduleData.scheduleTitle),
      subtitle: Text(scheduleData.timeString),
      trailing: Visibility(
        visible: WCUtils.isAdminOrLeader(_wcUserInfoData!),
        child: Hero(
          tag: scheduleData.scheduleID,
          child: PopupMenuButton<int>(
            onSelected: (item) async {
              switch (item) {
                case 0:
                  Navigator.push(
                    context,
                    WCCustomRoute(
                      builder: (context) {
                        return EditScheduleCard(
                          scheduleData: scheduleData,
                        );
                      },
                    ),
                  );
                  break;
                case 1:
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Confirm delete?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('No'),
                          ),
                          TextButton(
                            onPressed: () async {
                              await SchedulesFirebaseAPI(_wcUserInfoData.teamID).deleteSchedule(scheduleData);
                              await ref.watch(calendarScheduleListProvider.notifier).resetScheduleProvider();

                              Navigator.pop(context);
                            },
                            child: const Text('Yes'),
                          ),
                        ],
                      );
                    },
                  );

                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem<int>(
                value: 0,
                child: Text('Edit'),
              ),
              const PopupMenuItem<int>(
                value: 1,
                child: Text('Delete'),
              ),
            ],
          ),
        ),
      ),
      onTap: () async {
        ref.read(scheduleInfoProvider.state).state = scheduleData;
        await ref.read(schedulesSongsProvider.notifier).init();
        await ref.read(scheduleMusiciansProvider.notifier).init();

        Navigator.pushNamed(
          context,
          '/scheduleInfoPage',
        );
      },
    );
  }
}
