import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worship_connect/schedules/data_classes/schedule_data.dart';
import 'package:worship_connect/sign_in/data_classes/wc_user_info_data.dart';
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
      subtitle:  Text(scheduleData.timeString),
      trailing: Visibility(
        visible: WCUtils().isAdminOrLeader(_wcUserInfoData!), 
        child: PopupMenuButton<int>(
          onSelected: (item) async {
            switch (item) {
              case 0:
                //edit
                break;
              case 1:
                // delete
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
