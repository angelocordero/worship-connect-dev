import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worship_connect/announcements/utils/announcements_data.dart';
import 'package:worship_connect/announcements/services/announcements_firebase_api.dart';

class SendAnnouncementProvider extends StateNotifier<WCAnnouncementsData> {
  SendAnnouncementProvider({
    required WCAnnouncementsData data,
    required this.teamID,
  }) : super(data);

  String teamID;

  void setNewAnnouncement(WCAnnouncementsData data) {
    state = data;
  }

  Future<void> sendNewAnnouncement({
    required String announcementText,
    required String announcementPosterName,
    required String announcementPosterID,
  }) async {
    await AnnouncementsFirebaseAPI(teamID).sendAnnouncement(
      announcementText: announcementText,
      announcementPosterName: announcementPosterName,
      announcementPosterID: announcementPosterID,
    );
  }

  Future<void> sendEditedAnnouncement({
    required String announcementText,
    required String announcementID,
  }) async {
    await AnnouncementsFirebaseAPI(teamID).editAnnouncement(
      announcementText: state.announcementText,
      announcementID: state.announcementID,
    );
  }

  Future<void> deleteAnnouncement({
    required String teamID,
    required String announcementID,
  }) async {
    await AnnouncementsFirebaseAPI(teamID).deleteAnnouncement(
      announcementID: announcementID,
    );
  }
}
