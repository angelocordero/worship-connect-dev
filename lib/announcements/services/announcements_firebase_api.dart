import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:worship_connect/wc_core/worship_connect_utilities.dart';

class AnnouncementsFirebaseAPI {
  String teamID;
  late DocumentReference _teamAnnouncementsData;

  AnnouncementsFirebaseAPI(this.teamID) {
    _teamAnnouncementsData = FirebaseFirestore.instance.collection('WCTeams').doc(teamID).collection('data').doc('announcements');
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
      'announcementText': announcementText,
      'announcementPosterName': announcementPosterName,
      'announcementPosterID': announcementPosterID,
      'announcementID': _announcementID,
      'timestamp': _timestamp,
    });

    EasyLoading.dismiss();
  }

  Future<void> editAnnouncement({
    required String newAnnouncementText,
    required String announcementID,
  }) async {
    EasyLoading.show();

    await _teamAnnouncementsData.update({
      '$announcementID.announcementText': newAnnouncementText,
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

  Future<DocumentSnapshot> getAnnouncementsDocument() async {
    EasyLoading.show();

    return await _teamAnnouncementsData.get().then(
      (value) {
        EasyLoading.dismiss();
        return value;
      },
    );
  }
}
