import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worship_connect/announcements/screens/announcements_home_page.dart';
import 'package:worship_connect/announcements/utils/announcements_providers_definition.dart';
import 'package:worship_connect/schedules/screens/schedules_home_page.dart';
import 'package:worship_connect/schedules/utils/schedules_providers_definition.dart';
import 'package:worship_connect/settings/screens/settings_home_page.dart';
import 'package:worship_connect/sign_in/utils/wc_user_auth_data.dart';
import 'package:worship_connect/sign_in/utils/wc_user_info_data.dart';
import 'package:worship_connect/wc_core/core_providers_definition.dart';

class HomeNavigator extends ConsumerWidget {
  const HomeNavigator({Key? key}) : super(key: key);
  final List<Widget> homeScreens = const <Widget>[
    SchedulesHomePage(),
    AnnouncementsHomePage(),
    SettingsHomePage(),
  ];

  final List<BottomNavigationBarItem> bottomNavBarItems = const <BottomNavigationBarItem>[
    BottomNavigationBarItem(icon: Icon(Icons.assignment), label: 'Schedules'),
    BottomNavigationBarItem(icon: Icon(Icons.messenger), label: 'Announcements'),
    BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final WCUserInfoData? _wcUserInfoData = ref.watch(wcUserInfoDataStream).value;
    final WCUserAuthData? _wcUserAuthData = ref.watch(wcUserAuthStateStream).value;

    if (_wcUserAuthData == null || _wcUserInfoData != null && _wcUserInfoData.teamID.isEmpty) {

      WidgetsBinding.instance?.addPostFrameCallback(
        (_) async {
          await Navigator.pushReplacementNamed(context, '/');
        },
      );
      return Container();
    }

    _initData(ref);

    return Consumer(
      builder: (context, ref, child) {
        return Scaffold(
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: ref.watch(homeNavigationIndexProvider),
            onTap: (index) {
              ref.read(homeNavigationIndexProvider.state).state = index;
            },
            items: bottomNavBarItems,
          ),
          body: IndexedStack(
            index: ref.watch(homeNavigationIndexProvider),
            children: homeScreens,
          ),
        );
      },
    );
  }

  void _initData(WidgetRef ref) {
    ref.read(calendarScheduleListProvider.notifier).initScheduleProvider();
    ref.read(scheduleInfoProvider.state);
    ref.read(announcementListProvider.notifier).getAnnouncements();
  }
}
