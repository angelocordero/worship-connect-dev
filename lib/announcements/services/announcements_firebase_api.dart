import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
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

    String _announcementID = WCUtils().generateRandomID();
    Timestamp _timestamp = Timestamp.now();

    await _teamAnnouncementsData.update({
      _announcementID: <String, dynamic>{
        'announcementText': announcementText,
        'announcementPosterName': announcementPosterName,
        'announcementPosterID': announcementPosterID,
        'announcementID': _announcementID,
        'timestamp': _timestamp,
      }
    });

    EasyLoading.dismiss();
  }

  Future<void> editAnnouncement({
    required String announcementText,
    required String announcementID,
  }) async {
    EasyLoading.show();

    await _teamAnnouncementsData.update({
      '$announcementID.announcementText': announcementText,
    });

    EasyLoading.dismiss();
  }

  Future<void> deleteAnnouncement({required String announcementID}) async {
    EasyLoading.show();

    await _teamAnnouncementsData.update({
      announcementID: FieldValue.delete(),
    });

    EasyLoading.dismiss();
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
