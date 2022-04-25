import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:worship_connect/schedules/utils/schedule_data.dart';
import 'package:worship_connect/wc_core/worship_connect_utilities.dart';

class SchedulesFirebaseAPI {
  SchedulesFirebaseAPI(this.teamID) {
    _scheduleDoc = FirebaseFirestore.instance.collection('WCTeams').doc(teamID).collection('data').doc('schedules');
  }

  final String teamID;
  late DocumentReference<Map<String, dynamic>> _scheduleDoc;

  Future<void> addSchedule({
    required Timestamp timestamp,
    required String scheduleTitle,
    required String? posterName,
    required String posterID,
  }) async {
    String scheduleID = WCUtils.generateRandomID();
    String scheduleDateCode = WCUtils.setDateCode(timestamp.toDate());

    EasyLoading.show();

    try {
      DocumentSnapshot<Map> _doc = await _scheduleDoc.get();

      WriteBatch _writeBatch = FirebaseFirestore.instance.batch();

      if (_doc.exists) {
        _writeBatch.update(
          _scheduleDoc,
          {
            scheduleDateCode: FieldValue.arrayUnion(
              [
                <String, dynamic>{
                  WCScheduleDataEnum.timestamp.name: timestamp,
                  WCScheduleDataEnum.scheduleTitle.name: scheduleTitle,
                  WCScheduleDataEnum.scheduleID.name: scheduleID,
                  WCScheduleDataEnum.scheduleDateCode.name: scheduleDateCode,
                }
              ],
            ),
          },
        );
      } else {
        _writeBatch.set(
          _scheduleDoc,
          {
            scheduleDateCode: [
              <String, dynamic>{
                WCScheduleDataEnum.timestamp.name: timestamp,
                WCScheduleDataEnum.scheduleTitle.name: scheduleTitle,
                WCScheduleDataEnum.scheduleID.name: scheduleID,
                WCScheduleDataEnum.scheduleDateCode.name: scheduleDateCode,
              }
            ],
          },
        );
      }

      _writeBatch.set(
        _scheduleDoc.collection('scheduleData').doc(scheduleID),
        {
          'songs': [],
          'musicians': {},
        },
      );

      _writeBatch.commit();

      WCUtils.sendTeamNotification(
        title: 'New Schedule',
        body: 'New schedule added by $posterName',
        teamID: teamID,
        notificationType: 'schedule',
      );

      EasyLoading.dismiss();
    } catch (e, st) {
      WCUtils.wcShowError(e: e, st: st, wcError: 'Failed to add schedule');
    }
  }

  // Future<int> getScheduleDataDocuments() async {
  //   EasyLoading.show();

  //   try {
  //     QuerySnapshot<Map<String, dynamic>> _scheduleData = await _scheduleDoc.collection('scheduleData').get();
  //     return _scheduleData.docs.length;
  //   } catch (e, st) {
  //     WCUtils.wcShowError(e: e, st: st, wcError: 'Failed to get schedule data');
  //     return Future.value(0);
  //   }
  // }

  Future<DocumentSnapshot<Map<String, dynamic>>?> getScheduleDocument() async {
    EasyLoading.show();

    try {
      return _scheduleDoc.get().then((value) {
        EasyLoading.dismiss();
        return value;
      });
    } catch (e, st) {
      WCUtils.wcShowError(e: e, st: st, wcError: 'Failed to get schedule data');
      return null;
    }
  }

  Future<void> deleteSchedule(WCScheduleData _scheduleData) async {
    EasyLoading.show();

    try {
      WriteBatch _writeBatch = FirebaseFirestore.instance.batch();

      _writeBatch.update(_scheduleDoc, {
        _scheduleData.scheduleDateCode: FieldValue.arrayRemove([
          <String, dynamic>{
            WCScheduleDataEnum.timestamp.name: _scheduleData.timestamp,
            WCScheduleDataEnum.scheduleTitle.name: _scheduleData.scheduleTitle,
            WCScheduleDataEnum.scheduleDateCode.name: _scheduleData.scheduleDateCode,
            WCScheduleDataEnum.scheduleID.name: _scheduleData.scheduleID,
          }
        ]),
      });

      _writeBatch.delete(_scheduleDoc.collection('scheduleData').doc(_scheduleData.scheduleID));

      await _writeBatch.commit();

      EasyLoading.dismiss();
    } catch (e, st) {
      WCUtils.wcShowError(e: e, st: st, wcError: 'Failed to delete schedule');
    }
  }

  Future<void> editSchedule({
    required WCScheduleData oldSchedule,
    required WCScheduleData newSchedule,
  }) async {
    EasyLoading.show();

    try {
      WriteBatch _writeBatch = FirebaseFirestore.instance.batch();

      _writeBatch.update(_scheduleDoc, {
        oldSchedule.scheduleDateCode: FieldValue.arrayRemove([
          <String, dynamic>{
            WCScheduleDataEnum.timestamp.name: oldSchedule.timestamp,
            WCScheduleDataEnum.scheduleTitle.name: oldSchedule.scheduleTitle,
            WCScheduleDataEnum.scheduleDateCode.name: oldSchedule.scheduleDateCode,
            WCScheduleDataEnum.scheduleID.name: oldSchedule.scheduleID,
          }
        ]),
      });

      _writeBatch.update(
        _scheduleDoc,
        {
          newSchedule.scheduleDateCode: FieldValue.arrayUnion(
            [
              <String, dynamic>{
                WCScheduleDataEnum.timestamp.name: newSchedule.timestamp,
                WCScheduleDataEnum.scheduleTitle.name: newSchedule.scheduleTitle,
                WCScheduleDataEnum.scheduleID.name: newSchedule.scheduleID,
                WCScheduleDataEnum.scheduleDateCode.name: newSchedule.scheduleDateCode,
              }
            ],
          ),
        },
      );

      await _writeBatch.commit();
      EasyLoading.dismiss();
    } catch (e, st) {
      WCUtils.wcShowError(e: e, st: st, wcError: 'Failed to edit schedule');
    }
  }

  Future<DocumentSnapshot<Map<String, dynamic>>?> getScheduleInfo(String scheduleID) async {
    EasyLoading.show();

    try {
      return await _scheduleDoc.collection('scheduleData').doc(scheduleID).get().then((value) {
        EasyLoading.dismiss();

        return value;
      });
    } catch (e) {
      EasyLoading.dismiss();
      return null;
    }
  }

  Future saveSongsData({
    required List<dynamic> songsData,
    required WCScheduleData scheduleData,
    required String posterName,
    required String posterID,
  }) async {
    EasyLoading.show();

    try {
      await _scheduleDoc.collection('scheduleData').doc(scheduleData.scheduleID).update({
        'songs': songsData,
      });

      WCUtils.sendTeamNotification(
        title: 'Song List Updated',
        body: 'The song list for ${scheduleData.scheduleTitle} on ${scheduleData.dateString} has been updated by $posterName',
        teamID: teamID,
        notificationType: 'schedule',
      );

      EasyLoading.dismiss();
    } catch (e, st) {
      WCUtils.wcShowError(e: e, st: st, wcError: 'Failed to save schedule data');
    }
  }

  Future saveMusiciansData({
    required Map<String, dynamic> musiciansData,
    required WCScheduleData scheduleData,
    required String posterName,
    required String posterID,
  }) async {
    EasyLoading.show();

    try {
      await _scheduleDoc.collection('scheduleData').doc(scheduleData.scheduleID).update({
        'musicians': musiciansData,
      });

      WCUtils.sendTeamNotification(
        title: 'Song List Updated',
        body: 'The musicians list for ${scheduleData.scheduleTitle} on ${scheduleData.dateString} has been updated by $posterName',
        teamID: teamID,
        notificationType: 'schedule',
      );

      EasyLoading.dismiss();
    } catch (e, st) {
      WCUtils.wcShowError(e: e, st: st, wcError: 'Failed to save musicians data');
    }
  }
}
