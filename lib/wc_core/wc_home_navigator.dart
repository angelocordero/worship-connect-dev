import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worship_connect/announcements/screens/announcements_home_page.dart';
import 'package:worship_connect/announcements/utils/announcements_providers_definition.dart';
import 'package:worship_connect/schedules/screens/schedules_home_page.dart';
import 'package:worship_connect/schedules/utils/schedules_providers_definition.dart';
import 'package:worship_connect/settings/screens/settings_home_page.dart';
import 'package:worship_connect/settings/utils/settings_providers_definition.dart';
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

    _listenForNotifications(_wcUserInfoData, ref);

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

  Future<void> _listenForNotifications(WCUserInfoData? _wcUserInfoData, WidgetRef ref) async {
    FirebaseMessaging.instance.getToken();
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage event) async {
        RemoteNotification? _notification = event.notification;
        String _userID = _wcUserInfoData?.userID ?? '';

        String posterID = event.data['posterID'] ?? '';
        String notificationType = event.data['notificationType'] ?? '';

        if (posterID == _userID) return;

        if (_notification == null) return;

        if (notificationType == 'schedule') {
          await ref.read(calendarScheduleListProvider.notifier).resetScheduleProvider();

          try {
            await ref.read(schedulesSongsProvider.notifier).init();
            await ref.read(scheduleMusiciansProvider.notifier).init();
          } catch (e) {
//
          }
        }

        if (notificationType == 'announcement') {
          await ref.read(announcementListProvider.notifier).getAnnouncements();
        }

        if (notificationType == 'member') {
          await ref.read(membersListProvider.notifier).reset();
        }

        EasyLoading.showToast(
          _notification.body!,
          toastPosition: EasyLoadingToastPosition.top,
          duration: const Duration(seconds: 5),
          dismissOnTap: true,
        );
      },
    );
  }

  Future<void> _initData(WidgetRef ref) async {
    await ref.read(calendarScheduleListProvider.notifier).initScheduleProvider();
    ref.read(scheduleInfoProvider.state);
    await ref.read(announcementListProvider.notifier).getAnnouncements();
  }
}
