import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:worship_connect/wc_core/worship_connect_utilities.dart';

enum ScheduleDataEnum {
  scheduleTitle,
  scheduleID,
  scheduleDateCode,
  timestamp,
}

class WCScheduleData {
  final String scheduleTitle;
  final String scheduleID;
  final String scheduleDateCode;
  final Timestamp timestamp;

  late String dateString;
  late String timeString;

  WCScheduleData({
    required this.scheduleTitle,
    required this.scheduleID,
    required this.timestamp,
    required this.scheduleDateCode,
  }) {
    dateString = WCUtils().dateTimeToString(timestamp.toDate());
    timeString = WCUtils().timeToString(timestamp.toDate());
  }

  WCScheduleData.empty(Timestamp _timestamp)
      : scheduleTitle = '',
        scheduleID = '',
        scheduleDateCode = '',
        timestamp = _timestamp {
    dateString = WCUtils().dateTimeToString(timestamp.toDate());
    timeString = WCUtils().timeToString(timestamp.toDate());
  }

  WCScheduleData copyWith({
    String? scheduleTitle,
    String? scheduleID,
    String? scheduleDateCode,
    Timestamp? timestamp,
  }) {
    return WCScheduleData(
      scheduleTitle: scheduleTitle ?? this.scheduleTitle,
      scheduleID: scheduleID ?? this.scheduleID,
      scheduleDateCode: scheduleDateCode ?? this.scheduleDateCode,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
