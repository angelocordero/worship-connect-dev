import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worship_connect/schedules/data_classes/schedule_data.dart';
import 'package:worship_connect/schedules/screens/schedules_home_page.dart';
import 'package:worship_connect/schedules/services/schedules_firebase_api.dart';
import 'package:worship_connect/schedules/widgets/create_schedule_card.dart';
import 'package:worship_connect/sign_in/data_classes/wc_user_info_data.dart';
import 'package:worship_connect/wc_core/wc_custom_route.dart';
import 'package:worship_connect/wc_core/worship_connect.dart';
import 'package:worship_connect/wc_core/worship_connect_utilities.dart';

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
        visible: WCUtils().isAdminOrLeader(_wcUserInfoData!),
        child: PopupMenuButton<int>(
          onSelected: (item) async {
            switch (item) {
              case 0:
                Navigator.push(
                  context,
                  WCCustomRoute(
                    builder: (context) {
                      final _newScheduleProvider = ref.watch(addScheduleProvider.notifier);
                      _newScheduleProvider.initScheduleProvider(scheduleData);
                      _newScheduleProvider.setOriginalScheduleData();

                      return const CreateScheduleCard(
                        tag: 'editSchedule',
                        addOrEdit: 'Edit',
                      );
                    },
                  ),
                );

                break;
              case 1:
                SchedulesFirebaseAPI(_wcUserInfoData.teamID).deleteSchedule(scheduleData);
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
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              //display schedule info
              return Container();
            },
          ),
        );
      },
    );
  }
}
