import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:worship_connect/schedules/utils/schedule_data.dart';
import 'package:worship_connect/schedules/utils/schedules_providers_definition.dart';
import 'package:worship_connect/schedules/widgets/create_schedule_card.dart';
import 'package:worship_connect/schedules/widgets/schedule_calendar.dart';
import 'package:worship_connect/schedules/widgets/schedules_calendar_tile.dart';
import 'package:worship_connect/wc_core/wc_custom_route.dart';
import 'package:worship_connect/wc_core/worship_connect_utilities.dart';

class SchedulesHomePage extends ConsumerStatefulWidget {
  const SchedulesHomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SchedulesHomePageState();
}

class _SchedulesHomePageState extends ConsumerState<SchedulesHomePage> {
  @override
  void initState() {
    ref.read(calendarScheduleListProvider.notifier).initScheduleProvider();
    ref.read(scheduleInfoProvider.state);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final calendarSelectedDay = ref.watch(calendarSelectedDayProvider);

    return Scaffold(
      floatingActionButton: _addScheduleButton(context),
      appBar: AppBar(
        title: Text(
          'Schedules',
          style: GoogleFonts.exo2(),
        ),
      ),
      body: SizedBox(
        height: WCUtils.screenHeightSafeAreaAppBarBottomBar(context),
        child: RefreshIndicator(
          onRefresh: () async {
            await ref.read(calendarScheduleListProvider.notifier).resetScheduleProvider();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: SizedBox(
              height: WCUtils.screenHeightSafeAreaAppBarBottomBar(context),
              child: Column(
                children: [
                  const ScheduleCalendar(),
                  Expanded(
                    child: Container(
                      width: WCUtils.screenWidth(context),
                      padding: const EdgeInsets.all(12),
                      child: Builder(
                        builder: (context) {
                          return _buildScheduleList(calendarSelectedDay);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Visibility _addScheduleButton(BuildContext context) {
    return Visibility(
      child: WCUtils.wcExtendedFloatingActionButton(
        heroTag: 'addSchedule',
        labelText: 'Add Schedule',
        onPressed: () {
          Navigator.push(
            context,
            WCCustomRoute(
              builder: (context) {
                return const CreateScheduleCard();
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildScheduleList(DateTime calendarSelectedDay) {
    List scheduleList = ref.watch(calendarScheduleListProvider)[DateFormat('yyyyMMdd').format(calendarSelectedDay)] ?? [];

    if (scheduleList.isEmpty) {
      return Center(
        child: Text(
          'No schedules for\n${WCUtils.dateToString(calendarSelectedDay)}',
          textAlign: TextAlign.center,
        ),
      );
    } else {
      return ListView.builder(
        itemCount: scheduleList.length,
        itemBuilder: (BuildContext context, int index) {
          return _buildScheduleCalendarTiles(scheduleList, index);
        },
      );
    }
  }

  SchedulesCalendarTile _buildScheduleCalendarTiles(List<dynamic> scheduleList, int index) {
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
  }
}
