import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worship_connect/schedules/services/schedules_firebase_api.dart';

class CalendarScheduleListProvider extends StateNotifier<Map<String, dynamic>> {
  String teamID;

  CalendarScheduleListProvider({required this.teamID}) : super({});

  _fetchScheduleList() async {
    DocumentSnapshot<Map<String, dynamic>>? doc = await SchedulesFirebaseAPI(teamID).getScheduleDocument();
    if (mounted) {
      state = doc?.data() ?? {};
    }
  }

  resetScheduleProvider() async {
    await _fetchScheduleList();
  }

  initScheduleProvider() async {
    await _fetchScheduleList();
  }
}
