import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:worship_connect/wc_core/worship_connect_utilities.dart';

enum WCAnnouncementsDataEnum {
  announcementText,
  announcementID,
  announcementPosterName,
  announcementPosterID,
  timestamp,
}

class WCAnnouncementsData {
  final String announcementText;
  final String announcementID;
  final String announcementPosterName;
  final String announcementPosterID;
  final Timestamp? timestamp;

  late String announcementDateString;

  WCAnnouncementsData({
    required this.announcementText,
    required this.announcementID,
    required this.announcementPosterName,
    required this.announcementPosterID,
    this.timestamp,
  }) {
    announcementDateString = WCUtils().dateTimeToString(timestamp?.toDate() ?? Timestamp.now().toDate());
  }

  WCAnnouncementsData.empty()
      : announcementID = '',
        announcementPosterID = '',
        announcementText = '',
        announcementPosterName = '',
        timestamp = null;
}
