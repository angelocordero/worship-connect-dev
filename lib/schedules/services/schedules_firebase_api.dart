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

  addSchedule(WCScheduleData _scheduleData) async {
    EasyLoading.show();

    try {
      DocumentSnapshot<Map> _doc = await _scheduleDoc.get();

      if (_doc.exists) {
        _scheduleDoc.update(
          {
            _scheduleData.scheduleDateCode: FieldValue.arrayUnion(
              [
                <String, dynamic>{
                  ScheduleDataEnum.timestamp.name: _scheduleData.timestamp,
                  ScheduleDataEnum.scheduleTitle.name: _scheduleData.scheduleTitle,
                  ScheduleDataEnum.scheduleID.name: _scheduleData.scheduleID,
                  ScheduleDataEnum.scheduleDateCode.name: _scheduleData.scheduleDateCode,
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
                ScheduleDataEnum.timestamp.name: _scheduleData.timestamp,
                ScheduleDataEnum.scheduleTitle.name: _scheduleData.scheduleTitle,
                ScheduleDataEnum.scheduleID.name: _scheduleData.scheduleID,
                ScheduleDataEnum.scheduleDateCode.name: _scheduleData.scheduleDateCode,
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
}
