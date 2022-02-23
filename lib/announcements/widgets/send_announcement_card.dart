import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tap_debouncer/tap_debouncer.dart';
import 'package:worship_connect/announcements/data_classes/announcements_data.dart';
import 'package:worship_connect/announcements/providers/send_announcement_provider.dart';
import 'package:worship_connect/announcements/screens/announcements_home_page.dart';
import 'package:worship_connect/sign_in/data_classes/wc_user_info_data.dart';
import 'package:worship_connect/wc_core/worship_connect.dart';
import 'package:worship_connect/wc_core/worship_connect_utilities.dart';

class SendAnnouncementCard extends ConsumerStatefulWidget {
  const SendAnnouncementCard({Key? key, required this.sendOrEdit, required this.tag}) : super(key: key);

  final String sendOrEdit;
  final String tag;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SendAnnouncementCardState();
}

class _SendAnnouncementCardState extends ConsumerState<SendAnnouncementCard> {
  late final WCAnnouncementsData _announcement;
  final TextEditingController _announcementTextController = TextEditingController();

  @override
  void dispose() {
    _announcementTextController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _announcement = ref.read(sendAnnouncementProvider);
    _announcementTextController.text = _announcement.announcementText;
    _announcementTextController.selection = TextSelection.fromPosition(
      TextPosition(offset: _announcement.announcementText.length),
    );

    super.initState();
  }

  Future<dynamic> showCancelDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm cancel?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                FocusScope.of(context).unfocus();
                Navigator.pop(context);
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  SingleChildScrollView _announcementButtons(BuildContext context) {
    AsyncData<WCUserInfoData?>? wcUserInfoData = ref.watch(wcUserInfoDataStream).asData;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: (WCUtils().screenWidth(context) - 96) / 3,
          ),
          TextButton(
            onPressed: () async {
              if (_announcementTextController.text.isNotEmpty && _announcement.announcementText != _announcementTextController.text) {
                await showCancelDialog(context);
              } else {
                Navigator.pop(context);
              }
            },
            child: const Text('Cancel'),
          ),
          TapDebouncer(
            builder: (BuildContext context, TapDebouncerFunc? onTap) {
              return TextButton(
                onPressed: onTap,
                child: Text(widget.sendOrEdit),
              );
            },
            onTap: () async {
              SendAnnouncementProvider notifier = ref.watch(sendAnnouncementProvider.notifier);

              if (_announcement.announcementText.isEmpty) {
                // sending new announcement
                await notifier.sendNewAnnouncement(
                  announcementText: _announcementTextController.text.trim(),
                  announcementPosterID: wcUserInfoData!.value!.userID,
                  announcementPosterName: wcUserInfoData.value!.userName,
                );
              } else if (_announcement.announcementText != _announcementTextController.text) {
                // editing announcement
                await notifier.sendEditedAnnouncement(
                  announcementText: _announcementTextController.text.trim(),
                  announcementID: _announcement.announcementID,
                );
              }

              await ref.watch(announcementListProvider.notifier).getAnnouncements();

              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  TextFormField _announcementTextField() {
    return TextFormField(
      controller: _announcementTextController,
      minLines: 5,
      maxLines: 5,
      keyboardType: TextInputType.multiline,
      autocorrect: true,
      enableSuggestions: true,
      cursorColor: Colors.black,
      decoration: const InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.all(12),
        hintText: 'Announcement',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(12.0),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Hero(
          tag: widget.tag,
          child: Material(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    '${widget.sendOrEdit} Announcement',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  _announcementTextField(),
                  _announcementButtons(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
