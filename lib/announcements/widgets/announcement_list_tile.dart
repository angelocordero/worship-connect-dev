import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worship_connect/announcements/data_classes/announcements_data.dart';
import 'package:worship_connect/announcements/providers/send_announcement_provider.dart';
import 'package:worship_connect/announcements/screens/announcements_home_page.dart';
import 'package:worship_connect/announcements/widgets/send_announcement_form.dart';
import 'package:worship_connect/sign_in/data_classes/wc_user_info_data.dart';
import 'package:worship_connect/wc_core/wc_custom_route.dart';
import 'package:worship_connect/wc_core/worship_connect.dart';
import 'package:worship_connect/wc_core/worship_connect_constants.dart';

class AnnouncementListTile extends ConsumerWidget {
  const AnnouncementListTile({Key? key, required this.index}) : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    WCAnnouncementsData _announcementData = ref.watch(announcementListProvider)[index];
    WCUserInfoData _userInfoData = ref.watch(wcUserInfoDataStream).asData!.value!;
    SendAnnouncementProvider _announcementNotifier = ref.watch(sendAnnouncementProvider.notifier);

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
                  context: context, userInfoData: _userInfoData, announcementData: _announcementData, announcementNotifier: _announcementNotifier),
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
        style: const TextStyle(
          fontSize: 15,
        ),
      ),
    );
  }

  Widget _announcementInfo({
    required BuildContext context,
    required WCUserInfoData userInfoData,
    required WCAnnouncementsData announcementData,
    required SendAnnouncementProvider announcementNotifier,
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
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                announcementData.announcementDateString,
                style: const TextStyle(fontSize: 12),
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
                      announcementNotifier.setNewAnnouncement(
                        announcementData,
                      );

                      return SendAnnouncementForm(
                        tag: announcementData.announcementID,
                        sendOrEdit: 'Edit',
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
              await announcementNotifier.deleteAnnouncement(
                teamID: userInfoData.teamID,
                announcementID: announcementData.announcementID,
              );
            },
          ),
      ],
    );
  }
}
