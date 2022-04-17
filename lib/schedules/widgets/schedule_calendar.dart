import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:worship_connect/schedules/utils/schedules_providers_definition.dart';
import 'package:worship_connect/wc_core/worship_connect_constants.dart';

class ScheduleCalendar extends ConsumerStatefulWidget {
  const ScheduleCalendar({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ScheduleCalendarState();
}

class _ScheduleCalendarState extends ConsumerState<ScheduleCalendar> {
  static final DateTime _currentDate = DateTime.now();

  late DateTime _focusedDay;
  late DateTime _selectedDay;

  @override
  void initState() {
    _focusedDay = _currentDate;
    _selectedDay = _currentDate;
    super.initState();
  }

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
      eventLoader: schedulesForDay,
      calendarBuilders: CalendarBuilders(
        todayBuilder: (context, day, focusedDay) {
          return _currentDayMarker(context, day);
        },
        markerBuilder: (context, day, events) {
          return _scheduledDayMarker(context, day, events);
        },
        selectedBuilder: (context, day, selectedDay) {
          return _selectedDayMarker(day);
        },
      ),
    );
  }

  List schedulesForDay(DateTime day) {
    String dateString = DateFormat('yyyyMMdd').format(day);

    return ref.watch(calendarScheduleListProvider)[dateString] ?? [];
  }

  Container _currentDayMarker(BuildContext context, DateTime day) {
    final _currentDayString = DateFormat.d().format(day);
    return Container(
      margin: const EdgeInsets.all(8),
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: wcLinearGradient,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(_currentDayString),
        ),
      ),
    );
  }

  Widget _scheduledDayMarker(BuildContext context, DateTime day, List events) {
    if (events.isNotEmpty && day.day == _selectedDay.day && day.month == _selectedDay.month && day.year == _selectedDay.year) {
      return Container(
        width: 25,
        height: 3,
        margin: const EdgeInsets.only(bottom: 13),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(8),
        ),
      );
    } else if (events.isNotEmpty) {
      return Container(
        width: 25,
        height: 3,
        margin: const EdgeInsets.only(bottom: 13),
        decoration: BoxDecoration(
          gradient: wcLinearGradient,
          borderRadius: BorderRadius.circular(8),
        ),
      );
    } else {
      return Container();
    }
  }

  Container _selectedDayMarker(DateTime day) {
    final _selectedDayString = DateFormat.d().format(day);

    if (schedulesForDay(day).isEmpty) {
      return Container(
        margin: const EdgeInsets.all(8),
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: wcLinearGradient,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            _selectedDayString,
            style: TextStyle(
              color: Theme.of(context).scaffoldBackgroundColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    } else {
      return Container(
        margin: const EdgeInsets.all(8),
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: wcLinearGradient,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              bottom: 5,
              child: Container(
                width: 25,
                height: 3,
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            Text(
              _selectedDayString,
              style: TextStyle(
                color: Theme.of(context).scaffoldBackgroundColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }
  }
}
