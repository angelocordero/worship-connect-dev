import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worship_connect/announcements/providers/announcement_list_provider.dart';
import 'package:worship_connect/announcements/utils/announcements_providers_definition.dart';
import 'package:worship_connect/announcements/widgets/announcement_list_tile.dart';
import 'package:worship_connect/announcements/widgets/send_announcement_card.dart';
import 'package:worship_connect/sign_in/utils/wc_user_info_data.dart';
import 'package:worship_connect/wc_core/core_providers_definition.dart';
import 'package:worship_connect/wc_core/wc_custom_route.dart';
import 'package:worship_connect/wc_core/worship_connect_utilities.dart';

class AnnouncementsHomePage extends ConsumerStatefulWidget {
  const AnnouncementsHomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AnnouncementsHomePageState();
}

class _AnnouncementsHomePageState extends ConsumerState<AnnouncementsHomePage> {
  @override
  Widget build(BuildContext context) {
    WCUserInfoData? _wcUserInfoData = ref.watch(wcUserInfoDataStream).asData?.value;
    List _announcementList = ref.watch(announcementListProvider);
    AnnouncementListProvider _announcementNotifier = ref.watch(announcementListProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Announcements',
        ),
      ),
      floatingActionButton: _newAnnouncementButton(context, _wcUserInfoData),
      body: Builder(
        builder: (context) {
          if (_announcementList.isEmpty) {
            return Center(
              child: Text(
                "No announcement",
                style: Theme.of(context).textTheme.subtitle1,
              ),
            );
          } else {
            return RefreshIndicator(
              onRefresh: () async {
                return await _announcementNotifier.getAnnouncements();
              },
              child: ListView.builder(
                reverse: true,
                padding: const EdgeInsets.all(4),
                itemCount: _announcementList.length,
                itemBuilder: (BuildContext context, int index) {
                  return AnnouncementListTile(
                    index: index,
                    key: UniqueKey(),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }

  Visibility _newAnnouncementButton(BuildContext context, WCUserInfoData? wcUserInfoData) {
    return Visibility(
      visible: WCUtils.isAdminOrLeader(wcUserInfoData),
      child: WCUtils.wcExtendedFloatingActionButton(
        heroTag: 'newAnnouncement',
        labelText: 'New Announcement',
        onPressed: () {
          if (ref.read(announcementListProvider).length >= 10) {
            WCUtils.wcShowError(wcError: 'You can only post up to 10 announcements.');
            return;
          }
          Navigator.push(
            context,
            WCCustomRoute(
              builder: (BuildContext context) {
                return const SendAnnouncementCard();
              },
            ),
          );
        },
      ),
    );
  }
}
