import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worship_connect/announcements/screens/announcements_home_page.dart';
import 'package:worship_connect/schedules/screens/schedules_home_page.dart';
import 'package:worship_connect/settings/screens/settings_home_page.dart';
import 'package:worship_connect/sign_in/utils/wc_user_info_data.dart';
import 'package:worship_connect/wc_core/core_providers_definition.dart';

class HomeNavigator extends ConsumerStatefulWidget {
  const HomeNavigator({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeNavigatorState();
}

class _HomeNavigatorState extends ConsumerState<HomeNavigator> {
  int currentIndex = 0;

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
  Widget build(BuildContext context) {


    final WCUserInfoData? _wcUserInfoData = ref.watch(wcUserInfoDataStream).value;

    if (_wcUserInfoData != null && _wcUserInfoData.userName.isNotEmpty && _wcUserInfoData.teamID.isEmpty) {
      WidgetsBinding.instance?.addPostFrameCallback(
        (_) async {
          await Navigator.pushReplacementNamed(context, '/');
        },
      );
    }

    

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(
            () {
              currentIndex = index;
            },
          );
        },
        items: bottomNavBarItems,
      ),
      body: IndexedStack(
        index: currentIndex,
        children: homeScreens,
      ),
    );
  }
}
