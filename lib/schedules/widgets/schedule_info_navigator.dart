import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worship_connect/schedules/screens/schedule_info_musicians_page.dart';
import 'package:worship_connect/schedules/screens/schedule_info_songs_page.dart';
import 'package:worship_connect/schedules/utils/schedule_data.dart';
import 'package:worship_connect/schedules/utils/schedules_providers_definition.dart';
import 'package:worship_connect/sign_in/utils/wc_user_info_data.dart';
import 'package:worship_connect/wc_core/core_providers_definition.dart';
import 'package:worship_connect/wc_core/worship_connect_utilities.dart';

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
    WCUserInfoData? _wcUserInfoData = ref.watch(wcUserInfoDataStream).asData!.value;

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
        actions: [
          Visibility(
            visible: WCUtils.isAdminOrLeader(_wcUserInfoData),
            child: IconButton(
              onPressed: () {
                bool _isEditing = ref.read(isEditingProvider);

                ref.read(isEditingProvider.state).state = !_isEditing;
              },
              icon: AnimatedCrossFade(
                duration: const Duration(milliseconds: 250),
                firstChild: const Icon(Icons.edit_off_outlined),
                secondChild: const Icon(Icons.edit_outlined),
                crossFadeState: ref.watch(isEditingProvider) ? CrossFadeState.showFirst : CrossFadeState.showSecond,
              ),
            ),
          ),
        ],
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
              Icons.queue_music,
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
