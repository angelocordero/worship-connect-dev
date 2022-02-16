import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worship_connect/schedules/data_classes/schedule_data.dart';
import 'package:worship_connect/schedules/services/schedules_firebase_api.dart';
import 'package:worship_connect/wc_core/worship_connect_utilities.dart';

class AddScheduleProvider extends StateNotifier<WCScheduleData> {
  AddScheduleProvider({
    required WCScheduleData data,
  }) : super(data);

  //TODO: add team id as an constructor argument

  void initScheduleProvider(WCScheduleData _data) {
    state = _data;
  }

  setScheduleTime(TimeOfDay _scheduleTime) {
    DateTime _tempDate = WCUtils().setDateTimeFromDayAndTime(dateTime: state.timestamp.toDate(), timeOfDay: _scheduleTime);
    state = state.copyWith(timestamp: Timestamp.fromDate(_tempDate));
  }

  Future addSchedule({
    required String title,
    required String teamID,
  }) async {
    state = state.copyWith(
      scheduleTitle: title,
      scheduleDateCode: WCUtils().setDateCode(state.timestamp.toDate()),
      scheduleID: WCUtils().generateRandomID(),
    );

    return SchedulesFirebaseAPI(teamID).addSchedule(state);
  }

  editSchedule(String _title) {}
}
