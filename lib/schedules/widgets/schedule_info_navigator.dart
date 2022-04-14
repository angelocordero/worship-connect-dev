import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worship_connect/schedules/screens/schedule_info_musicians_page.dart';
import 'package:worship_connect/schedules/screens/schedule_info_songs_page.dart';
import 'package:worship_connect/schedules/utils/schedule_data.dart';
import 'package:worship_connect/schedules/utils/schedules_providers_definition.dart';

class ScheduleInfoNavigator extends ConsumerStatefulWidget {
  const ScheduleInfoNavigator({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ScheduleInfoNavigatorState();
}

class _ScheduleInfoNavigatorState extends ConsumerState<ScheduleInfoNavigator> {
  final screens = const [
    ScheduleInfoSongsPage(),
    ScheduleInfoMusiciansPage(),
  ];
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    WCScheduleData _scheduleData = ref.watch(scheduleInfoProvider);

    return Scaffold(
      appBar: AppBar(
        title: ListTile(
          title: Text(
            _scheduleData.scheduleTitle,
          ),
          subtitle: Text(
            _scheduleData.timeString,
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.my_library_music,
            ),
            label: 'Songs',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.my_library_books,
            ),
            label: 'Musicians',
          ),
        ],
      ),
      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),
    );
  }
}
