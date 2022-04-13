import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:worship_connect/announcements/services/announcements_firebase_api.dart';
import 'package:worship_connect/announcements/utils/announcements_data.dart';
import 'package:worship_connect/announcements/providers/announcement_list_provider.dart';
import 'package:worship_connect/announcements/utils/announcements_providers_definition.dart';
import 'package:worship_connect/announcements/widgets/edit_announcement_card.dart';
import 'package:worship_connect/sign_in/utils/wc_user_info_data.dart';
import 'package:worship_connect/wc_core/core_providers_definition.dart';
import 'package:worship_connect/wc_core/wc_custom_route.dart';
import 'package:worship_connect/wc_core/worship_connect_constants.dart';

class AnnouncementListTile extends ConsumerWidget {
  const AnnouncementListTile({Key? key, required this.index}) : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    WCAnnouncementsData _announcementData = ref.watch(announcementListProvider)[index];
    WCUserInfoData _userInfoData = ref.watch(wcUserInfoDataStream).asData!.value!;
    AnnouncementListProvider _announcementListNotifier = ref.watch(announcementListProvider.notifier);

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _announcementInfo(
                context: context,
                userInfoData: _userInfoData,
                announcementData: _announcementData,
                announcementListNotifier: _announcementListNotifier,
              ),
              const Divider(),
              _announcementText(_announcementData),
            ],
          ),
        ),
      ),
    );
  }

  Padding _announcementText(WCAnnouncementsData _announcementData) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        _announcementData.announcementText,
        style: GoogleFonts.openSans(
          textStyle: const TextStyle(
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  Widget _announcementInfo({
    required AnnouncementListProvider announcementListNotifier,
    required WCAnnouncementsData announcementData,
    required WCUserInfoData userInfoData,
    required BuildContext context,
  }) {
    bool _adminOrLeader = userInfoData.userStatus == UserStatusEnum.admin || userInfoData.userStatus == UserStatusEnum.leader;

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                announcementData.announcementPosterName,
                style: GoogleFonts.raleway(
                  textStyle: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                announcementData.announcementDateString,
                style: GoogleFonts.raleway(
                  textStyle: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
        if (_adminOrLeader)
          Hero(
            tag: announcementData.announcementID,
            child: IconButton(
              icon: const Icon(
                Icons.edit,
                size: 14,
              ),
              onPressed: () async {
                Navigator.push(
                  context,
                  WCCustomRoute(
                    builder: (BuildContext context) {
                      return EditAnnouncementCard(
                        announcement: announcementData,
                      );
                    },
                  ),
                );
              },
            ),
          ),
        if (_adminOrLeader)
          IconButton(
            icon: const Icon(
              Icons.delete,
              size: 14,
            ),
            onPressed: () async {
              await AnnouncementsFirebaseAPI(userInfoData.teamID).deleteAnnouncement(announcementID: announcementData.announcementID);
              await announcementListNotifier.getAnnouncements();
            },
          ),
      ],
    );
  }
}
