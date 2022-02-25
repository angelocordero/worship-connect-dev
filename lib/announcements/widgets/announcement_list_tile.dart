import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worship_connect/announcements/utils/announcements_data.dart';
import 'package:worship_connect/announcements/providers/announcement_list_provider.dart';
import 'package:worship_connect/announcements/providers/send_announcement_provider.dart';
import 'package:worship_connect/announcements/utils/announcements_providers_definition.dart';
import 'package:worship_connect/announcements/widgets/send_announcement_card.dart';
import 'package:worship_connect/sign_in/utils/wc_user_info_data.dart';
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
    SendAnnouncementProvider _sendAnnouncementNotifier = ref.watch(sendAnnouncementProvider.notifier);
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
                sendAnnouncementNotifier: _sendAnnouncementNotifier,
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
        style: const TextStyle(
          fontSize: 15,
        ),
      ),
    );
  }

  Widget _announcementInfo({
    required SendAnnouncementProvider sendAnnouncementNotifier,
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
                      sendAnnouncementNotifier.setNewAnnouncement(
                        announcementData,
                      );

                      return SendAnnouncementCard(
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
              await sendAnnouncementNotifier
                  .deleteAnnouncement(
                teamID: userInfoData.teamID,
                announcementID: announcementData.announcementID,
              )
                  .then(
                (_) async {
                  await announcementListNotifier.getAnnouncements();
                },
              );
            },
          ),
      ],
    );
  }
}
