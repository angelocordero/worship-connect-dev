import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worship_connect/announcements/data_classes/announcements_data.dart';
import 'package:worship_connect/announcements/providers/announcement_list_provider.dart';
import 'package:worship_connect/announcements/providers/send_announcement_provider.dart';
import 'package:worship_connect/announcements/widgets/send_announcement_form.dart';
import 'package:worship_connect/sign_in/data_classes/wc_user_info_data.dart';
import 'package:worship_connect/wc_core/wc_custom_route.dart';
import 'package:worship_connect/wc_core/worship_connect.dart';
import 'package:worship_connect/wc_core/worship_connect_utilities.dart';

final sendAnnouncementProvider = StateNotifierProvider.autoDispose<SendAnnouncementProvider, WCAnnouncementsData>((ref) {
  AsyncData<WCUserInfoData?>? wcUserInfoData = ref.watch(wcUserInfoDataStream).asData;

  return SendAnnouncementProvider(data: WCAnnouncementsData.empty(), teamID: wcUserInfoData!.value!.teamID);
});

final announcementListProvider = StateNotifierProvider<AnnouncementListProvider, List>((ref) {
  WCUserInfoData? wcUserInfoData = ref.watch(wcUserInfoDataStream).asData!.value;

  return AnnouncementListProvider(teamID: wcUserInfoData!.teamID);
});

class AnnouncementsHomePage extends ConsumerStatefulWidget {
  const AnnouncementsHomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AnnouncementsHomePageState();
}

class _AnnouncementsHomePageState extends ConsumerState<AnnouncementsHomePage> {
  @override
  void initState()  {
    ref.read(announcementListProvider.notifier).getAnnouncements();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    WCUserInfoData? _wcUserInfoData = ref.watch(wcUserInfoDataStream).asData!.value;
    List _announcementList = ref.watch(announcementListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Announcements'),
      ),
      floatingActionButton: _newAnnouncementButton(context, _wcUserInfoData!),
    );
  }

  Visibility _newAnnouncementButton(BuildContext context, WCUserInfoData wcUserInfoData) {
    return Visibility(
      visible: WCUtils().isAdminOrLeader(wcUserInfoData),
      child: FloatingActionButton.extended(
        heroTag: 'new',
        onPressed: () {
          Navigator.push(
            context,
            WCCustomRoute(
              builder: (BuildContext context) {
                final SendAnnouncementProvider _sendAnnouncementProvider = ref.watch(sendAnnouncementProvider.notifier);
                _sendAnnouncementProvider.setNewAnnouncement(
                  WCAnnouncementsData.empty(),
                );

                return const SendAnnouncementForm(
                  tag: 'new',
                  sendOrEdit: 'Send',
                );
              },
            ),
          );
        },
        label: const Text('New Announcement'),
      ),
    );
  }
}
