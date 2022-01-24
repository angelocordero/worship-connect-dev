import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worship_connect/announcements/data_classes/announcements_data.dart';
import 'package:worship_connect/announcements/services/announcements_firebase_api.dart';

class SendAnnouncementNotifier extends StateNotifier<WCAnnouncementsData> {
  SendAnnouncementNotifier({
    required WCAnnouncementsData data,
    required this.teamID,
  }) : super(data);

  String teamID;

  void setNewAnnouncement(WCAnnouncementsData data) {
    state = data;
  }

  void sendNewAnnouncement() async {
    await AnnouncementsFirebaseAPI(teamID).sendAnnouncement(
      announcementText: state.announcementText,
      announcementPosterName: state.announcementPosterName,
      announcementPosterID: state.announcementPosterID,
    );
  }

  void sendEditedAnnouncement() async {
    await AnnouncementsFirebaseAPI(teamID).editAnnouncement(
      announcementText: state.announcementText,
      announcementID: state.announcementID,
    );
  }

  void deleteAnnouncement({
    required String teamID,
    required String announcementID,
  }) async {
    await AnnouncementsFirebaseAPI(teamID).deleteAnnouncement(
      announcementID: announcementID,
    );
  }
}
