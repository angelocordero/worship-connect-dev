import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:worship_connect/schedules/utils/schedules_providers_definition.dart';

class ScheduleCalendar extends ConsumerStatefulWidget {
  const ScheduleCalendar({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ScheduleCalendarState();
}

class _ScheduleCalendarState extends ConsumerState<ScheduleCalendar> {
  static final DateTime _currentDate = DateTime.now();
  DateTime _selectedDay = _currentDate;
  DateTime _focusedDay = _currentDate;

  @override
  Widget build(BuildContext context) {
    final selectedDayProvider = ref.watch(calendarSelectedDayProvider.state);

    return TableCalendar(
      headerStyle: const HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
      ),
      firstDay: DateTime(DateTime.now().year - 1),
      lastDay: DateTime(DateTime.now().year + 5),
      focusedDay: _focusedDay,
      selectedDayPredicate: (day) {
        return isSameDay(_selectedDay, day);
      },
      onDaySelected: (selectedDay, focusedDay) {
        setState(
          () {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          },
        );

        selectedDayProvider.state = selectedDay;
      },
      onPageChanged: (focusedDay) {
        _focusedDay = focusedDay;
      },
      calendarBuilders: const CalendarBuilders(),
      eventLoader: schedulesForDay,
    );
  }

  List schedulesForDay(DateTime day) {
    String dateString = DateFormat('yyyyMMdd').format(day);

    return ref.watch(calendarScheduleListProvider)[dateString] ?? [];
  }
}
