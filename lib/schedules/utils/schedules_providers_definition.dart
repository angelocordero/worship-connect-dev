import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worship_connect/schedules/utils/schedule_data.dart';
import 'package:worship_connect/schedules/providers/add_schedule_provider.dart';
import 'package:worship_connect/schedules/providers/calendar_schedule_list_provider.dart';
import 'package:worship_connect/sign_in/utils/wc_user_info_data.dart';
import 'package:worship_connect/wc_core/worship_connect.dart';

final calendarSelectedDayProvider = StateProvider<DateTime>((ref) {
  return DateTime.now();
});

final addScheduleProvider = StateNotifierProvider.autoDispose<AddScheduleProvider, WCScheduleData>((ref) {
  WCUserInfoData? _wcUserInfoData = ref.watch(wcUserInfoDataStream).asData!.value;

  return AddScheduleProvider(
    data: WCScheduleData.empty(Timestamp.now()),
    teamID: _wcUserInfoData!.teamID,
  );
});

final calendarScheduleListProvider = StateNotifierProvider<CalendarScheduleListProvider, Map<String, dynamic>>((ref) {
  WCUserInfoData? _wcUserInfoData = ref.watch(wcUserInfoDataStream).asData?.value;

  return CalendarScheduleListProvider(teamID: _wcUserInfoData?.teamID ?? '');
});
