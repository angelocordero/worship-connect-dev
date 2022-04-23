import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worship_connect/schedules/providers/schedule_musicians_provider.dart';
import 'package:worship_connect/schedules/providers/schedule_songs_provider.dart';
import 'package:worship_connect/schedules/utils/schedule_data.dart';
import 'package:worship_connect/schedules/providers/calendar_schedule_list_provider.dart';
import 'package:worship_connect/sign_in/utils/wc_user_info_data.dart';
import 'package:worship_connect/wc_core/core_providers_definition.dart';


final calendarSelectedDayProvider = StateProvider<DateTime>((ref) {
  return DateTime.now();
});

final calendarScheduleListProvider = StateNotifierProvider<CalendarScheduleListProvider, Map<String, dynamic>>((ref) {
  WCUserInfoData? _wcUserInfoData = ref.watch(wcUserInfoDataStream).asData?.value;

  return CalendarScheduleListProvider(teamID: _wcUserInfoData?.teamID ?? '');
});

final scheduleInfoProvider = StateProvider<WCScheduleData>((ref) {
  return WCScheduleData.empty(Timestamp.now());
});

final schedulesSongsProvider = StateNotifierProvider<ScheduleSongsProvider, List>((ref) {
  WCUserInfoData? _wcUserInfoData = ref.watch(wcUserInfoDataStream).asData?.value;
  WCScheduleData _scheduleData = ref.watch(scheduleInfoProvider);

  return ScheduleSongsProvider(
    teamID: _wcUserInfoData!.teamID,
  scheduleData: _scheduleData,
  );
});

final songKeyProvider = StateProvider<String>((ref) {
  return 'A';
});

final scheduleMusiciansProvider = StateNotifierProvider<ScheduleMusiciansProvider, Map<String, dynamic>>((ref) {
  WCUserInfoData? _wcUserInfoData = ref.watch(wcUserInfoDataStream).asData?.value;
  WCScheduleData _scheduleData = ref.watch(scheduleInfoProvider);

  return ScheduleMusiciansProvider(
    teamID: _wcUserInfoData!.teamID,
    scheduleData: _scheduleData,
  );
});

final selectedInstrumentsProvider = StateProvider.autoDispose<String>((ref) {
  return '';
});

final customInstrumentProvider = StateProvider<String>((ref) {
  return '';
});
