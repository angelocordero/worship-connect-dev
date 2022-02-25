import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:worship_connect/schedules/data_classes/schedule_data.dart';
import 'package:worship_connect/wc_core/worship_connect_utilities.dart';

class SchedulesFirebaseAPI {
  SchedulesFirebaseAPI(this.teamID) {
    _scheduleDoc = FirebaseFirestore.instance.collection('WCTeams').doc(teamID).collection('data').doc('schedules');
  }

  final String teamID;
  late DocumentReference<Map<String, dynamic>> _scheduleDoc;

  Future<void> addSchedule(WCScheduleData _scheduleData) async {
    EasyLoading.show();

    try {
      DocumentSnapshot<Map> _doc = await _scheduleDoc.get();

      if (_doc.exists) {
        _scheduleDoc.update(
          {
            _scheduleData.scheduleDateCode: FieldValue.arrayUnion(
              [
                <String, dynamic>{
                  WCScheduleDataEnum.timestamp.name: _scheduleData.timestamp,
                  WCScheduleDataEnum.scheduleTitle.name: _scheduleData.scheduleTitle,
                  WCScheduleDataEnum.scheduleID.name: _scheduleData.scheduleID,
                  WCScheduleDataEnum.scheduleDateCode.name: _scheduleData.scheduleDateCode,
                }
              ],
            ),
          },
        );
      } else {
        _scheduleDoc.set(
          {
            _scheduleData.scheduleDateCode: [
              <String, dynamic>{
                WCScheduleDataEnum.timestamp.name: _scheduleData.timestamp,
                WCScheduleDataEnum.scheduleTitle.name: _scheduleData.scheduleTitle,
                WCScheduleDataEnum.scheduleID.name: _scheduleData.scheduleID,
                WCScheduleDataEnum.scheduleDateCode.name: _scheduleData.scheduleDateCode,
              }
            ],
          },
        );
      }
      EasyLoading.dismiss();
    } catch (e) {
      WCUtils().wcShowError('Failed to add schedule');
    }
  }

  Future<DocumentSnapshot<Map<String, dynamic>>?> getScheduleDocument() async {
    EasyLoading.show();

    try {
      return _scheduleDoc.get().then((value) {
        EasyLoading.dismiss();
        return value;
      });
    } catch (error) {
      WCUtils().wcShowError('Unable to get schedule data');
      return null;
    }
  }

  Future<void> deleteSchedule(WCScheduleData _scheduleData) async {
    EasyLoading.show();

    try {
      await _scheduleDoc.update({
        _scheduleData.scheduleDateCode: FieldValue.arrayRemove([
          <String, dynamic>{
            WCScheduleDataEnum.timestamp.name: _scheduleData.timestamp,
            WCScheduleDataEnum.scheduleTitle.name: _scheduleData.scheduleTitle,
            WCScheduleDataEnum.scheduleDateCode.name: _scheduleData.scheduleDateCode,
            WCScheduleDataEnum.scheduleID.name: _scheduleData.scheduleID,
          }
        ]),
      });

      EasyLoading.dismiss();
    } catch (e) {
      WCUtils().wcShowError('Failed to delete schedule');
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
    } catch (e) {
      WCUtils().wcShowError('Failed to edit schedule');
    }
  }
}
