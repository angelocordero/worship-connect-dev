import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:worship_connect/announcements/utils/announcements_data.dart';
import 'package:worship_connect/wc_core/worship_connect_utilities.dart';

class AnnouncementsFirebaseAPI {
  final String _teamID;
  late DocumentReference<Map> _teamAnnouncementsData;

  AnnouncementsFirebaseAPI(this._teamID) {
    _teamAnnouncementsData = FirebaseFirestore.instance.collection('WCTeams').doc(_teamID).collection('data').doc('announcements');
  }

  Future<void> sendAnnouncement({
    required String announcementText,
    required String announcementPosterName,
    required String announcementPosterID,
  }) async {
    EasyLoading.show();

    try {
      String _announcementID = WCUtils().generateRandomID();
      Timestamp _timestamp = Timestamp.now();

      await _teamAnnouncementsData.update({
        _announcementID: <String, dynamic>{
          WCAnnouncementsDataEnum.announcementText.name: announcementText,
          WCAnnouncementsDataEnum.announcementPosterName.name: announcementPosterName,
          WCAnnouncementsDataEnum.announcementPosterID.name: announcementPosterID,
          WCAnnouncementsDataEnum.announcementID.name: _announcementID,
          WCAnnouncementsDataEnum.timestamp.name: _timestamp,
        }
      });

      EasyLoading.dismiss();
    } catch (e) {
      WCUtils().wcShowError('Failed to send announcement');
    }
  }

  Future<void> editAnnouncement({
    required String announcementText,
    required String announcementID,
  }) async {
    EasyLoading.show();

    try {
      await _teamAnnouncementsData.update({
        '$announcementID.${WCAnnouncementsDataEnum.announcementText.name}': announcementText,
      });

      EasyLoading.dismiss();
    } catch (e) {
      WCUtils().wcShowError('Failed to edit announcement');
    }
  }

  Future<void> deleteAnnouncement({required String announcementID}) async {
    EasyLoading.show();

    try {
      await _teamAnnouncementsData.update({
        announcementID: FieldValue.delete(),
      });

      EasyLoading.dismiss();
    } catch (e) {
      WCUtils().wcShowError('Failed to delete announcement');
    }
  }

  Future<DocumentSnapshot<Map>?> getAnnouncementsDocument() async {
    EasyLoading.show();

    try {
      return await _teamAnnouncementsData.get().then(
        (value) async {
          EasyLoading.dismiss();
          return value;
        },
      );
    } catch (error) {
      WCUtils().wcShowError('Failed to get announcements');
      return null;
    }
  }
}
