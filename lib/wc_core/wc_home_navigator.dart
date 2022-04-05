import 'package:flutter/material.dart';
import 'package:worship_connect/announcements/screens/announcements_home_page.dart';
import 'package:worship_connect/schedules/screens/schedules_home_page.dart';
import 'package:worship_connect/settings/screens/settings_home_page.dart';

class HomeNavigator extends StatefulWidget {
  const HomeNavigator({Key? key}) : super(key: key);

  @override
  _HomeNavigatorState createState() => _HomeNavigatorState();
}

class _HomeNavigatorState extends State<HomeNavigator> {
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
