import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worship_connect/announcements/data_classes/announcements_data.dart';
import 'package:worship_connect/announcements/services/announcements_firebase_api.dart';

class AnnouncementListProvider extends StateNotifier<List> {
  AnnouncementListProvider({required this.teamID}) : super([]);

  final String teamID;

  Future<void> getAnnouncements() async {
    List<WCAnnouncementsData> _announcementList = [];

    DocumentSnapshot<Map>? _announcementsDoc = await AnnouncementsFirebaseAPI(teamID).getAnnouncementsDocument();

    if (_announcementsDoc != null && mounted) {

      _announcementsDoc.data()!.forEach(
        (key, value) {
          _announcementList.add(
            WCAnnouncementsData(
              announcementText: value[WCAnnouncementsDataEnum.announcementText.name],
              announcementID: value[WCAnnouncementsDataEnum.announcementID.name],
              announcementPosterName: value[WCAnnouncementsDataEnum.announcementPosterName.name],
              announcementPosterID: value[WCAnnouncementsDataEnum.announcementPosterID.name],
              timestamp: value[WCAnnouncementsDataEnum.timestamp.name],
            ),
          );
        },
      );

      _announcementList.sort(
        (a, b) {
          return a.timestamp!.compareTo(b.timestamp!);
        },
      );
      state = _announcementList;
    }
  }
}
