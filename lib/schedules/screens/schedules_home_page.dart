import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worship_connect/schedules/data_classes/schedule_data.dart';
import 'package:worship_connect/schedules/providers/add_schedule_provider.dart';
import 'package:worship_connect/schedules/widgets/create_schedule_card.dart';
import 'package:worship_connect/schedules/widgets/schedule_calendar.dart';
import 'package:worship_connect/wc_core/wc_custom_route.dart';
import 'package:worship_connect/wc_core/worship_connect_utilities.dart';

//TODO: add a new schedule provider

final calendarSelectedDayProvider = StateProvider<DateTime>((ref) {
  return DateTime.now();
});

final addScheduleProvider = StateNotifierProvider.autoDispose<AddScheduleProvider, WCScheduleData>((ref) {
  return AddScheduleProvider(
    data: WCScheduleData.empty(Timestamp.now()),
  );
});

class SchedulesHomePage extends ConsumerWidget {
  const SchedulesHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                    color: Colors.red,
                    child: const Text('schedule list'),
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
