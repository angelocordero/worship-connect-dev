import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worship_connect/announcements/data_classes/announcements_data.dart';
import 'package:worship_connect/announcements/models/send_announcement_model.dart';
import 'package:worship_connect/announcements/widgets/send_announcement_form.dart';
import 'package:worship_connect/sign_in/data_classes/wc_user_info_data.dart';
import 'package:worship_connect/wc_core/wc_custom_route.dart';
import 'package:worship_connect/wc_core/worship_connect.dart';

final sendAnnouncementProvider = StateNotifierProvider.autoDispose<SendAnnouncementNotifier, WCAnnouncementsData>((ref) {
  AsyncData<WCUserInfoData?>? wcUserInfoData = ref.watch(wcUserInfoDataStream).asData;

  return SendAnnouncementNotifier(data: WCAnnouncementsData.empty(), teamID: wcUserInfoData!.value!.teamID);
});

class AnnouncementsHomePage extends StatelessWidget {
  const AnnouncementsHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Announcements'),
      ),
      floatingActionButton: _newAnnouncementButton(context),
    );
  }

  Consumer _newAnnouncementButton(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final _announcement = ref.watch(sendAnnouncementProvider.notifier);
        _announcement.setNewAnnouncement(WCAnnouncementsData.empty());
        return child!;
      },
      child: FloatingActionButton.extended(
        heroTag: 'new',
        onPressed: () {
          Navigator.push(
            context,
            WCCustomRoute(
              builder: (BuildContext context) {
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
