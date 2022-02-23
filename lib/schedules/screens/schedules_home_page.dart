import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:worship_connect/schedules/data_classes/schedule_data.dart';
import 'package:worship_connect/schedules/providers/add_schedule_provider.dart';
import 'package:worship_connect/schedules/providers/calendar_schedule_list_provider.dart';
import 'package:worship_connect/schedules/widgets/create_schedule_card.dart';
import 'package:worship_connect/schedules/widgets/schedule_calendar.dart';
import 'package:worship_connect/schedules/widgets/schedules_calendar_tile.dart';
import 'package:worship_connect/sign_in/data_classes/wc_user_info_data.dart';
import 'package:worship_connect/wc_core/wc_custom_route.dart';
import 'package:worship_connect/wc_core/worship_connect.dart';
import 'package:worship_connect/wc_core/worship_connect_utilities.dart';

final calendarSelectedDayProvider = StateProvider<DateTime>((ref) {
  return DateTime.now();
});

final addScheduleProvider = StateNotifierProvider.autoDispose<AddScheduleProvider, WCScheduleData>((ref) {
  return AddScheduleProvider(
    data: WCScheduleData.empty(Timestamp.now()),
  );
});

final calendarScheduleListProvider = StateNotifierProvider<CalendarScheduleListProvider, Map<String, dynamic>>((ref) {
  WCUserInfoData? _wcUserInfoData = ref.watch(wcUserInfoDataStream).asData!.value;

  return CalendarScheduleListProvider(teamID: _wcUserInfoData!.teamID);
});

class SchedulesHomePage extends ConsumerStatefulWidget {
  const SchedulesHomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SchedulesHomePageState();
}

class _SchedulesHomePageState extends ConsumerState<SchedulesHomePage> {
  @override
  void initState() {
    ref.read(calendarScheduleListProvider.notifier).initScheduleProvider();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final calendarSelectedDay = ref.watch(calendarSelectedDayProvider);

    return Scaffold(
      floatingActionButton: Visibility(
        child: FloatingActionButton.extended(
          heroTag: 'schedule',
          onPressed: () {
            Navigator.push(
              context,
              WCCustomRoute(
                builder: (context) {
                  Timestamp _timestamp = Timestamp.fromDate(
                    WCUtils().setDateTimeFromDayAndTime(
                      dateTime: calendarSelectedDay,
                      timeOfDay: TimeOfDay.now(),
                    ),
                  );

                  final _newScheduleProvider = ref.watch(addScheduleProvider.notifier);
                  _newScheduleProvider.initScheduleProvider(WCScheduleData.empty(_timestamp));

                  return CreateScheduleCard();
                },
              ),
            );
          },
          label: const Text('Add Schedule'),
        ),
      ),
      appBar: AppBar(
        title: const Text('Schedules'),
      ),
      body: RefreshIndicator(
        onRefresh: () {
          return Future.delayed(const Duration(seconds: 1));
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            height: WCUtils().screenHeightSafeAreaAppBarBottomBar(context),
            child: Column(
              children: [
                const ScheduleCalendar(),
                Expanded(
                  child: Container(
                    width: WCUtils().screenWidth(context),
                    padding: const EdgeInsets.all(12),
                    child: Builder(
                      builder: (context) {
                        List scheduleList = ref.watch(calendarScheduleListProvider)[DateFormat('yyyyMMdd').format(calendarSelectedDay)] ?? [];

                        if (scheduleList.isEmpty) {
                          return Center(
                            child: Text(
                              'No schedules for\n${WCUtils().dateToString(calendarSelectedDay)}',
                              textAlign: TextAlign.center,
                            ),
                          );
                        } else {
                          return ListView.builder(
                            itemCount: scheduleList.length,
                            itemBuilder: (BuildContext context, int index) {
                              Map<String, dynamic> _scheduleDataFromList = scheduleList[index];
                              WCScheduleData _scheduleData = WCScheduleData(
                                scheduleTitle: _scheduleDataFromList[WCScheduleDataEnum.scheduleTitle.name],
                                scheduleID: _scheduleDataFromList[WCScheduleDataEnum.scheduleID.name],
                                timestamp: _scheduleDataFromList[WCScheduleDataEnum.timestamp.name],
                                scheduleDateCode: _scheduleDataFromList[WCScheduleDataEnum.scheduleDateCode.name],
                              );

                              return SchedulesCalendarTile(
                                scheduleData: _scheduleData,
                              );
                            },
                          );
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
