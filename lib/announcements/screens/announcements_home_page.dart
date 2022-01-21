import 'package:flutter/material.dart';
import 'package:worship_connect/announcements/widgets/send_announcement_form.dart';
import 'package:worship_connect/wc_core/wc_custom_route.dart';

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

  FloatingActionButton _newAnnouncementButton(BuildContext context) {
    return FloatingActionButton.extended(
      heroTag: 'send',
      onPressed: () {
        Navigator.push(
          context,
          WCCustomRoute(
            builder: (BuildContext context) {
              return const SendAnnouncementForm(tag: 'send');
            },
          ),
        );
      },
      label: const Text('New Announcement'),
    );
  }
}
