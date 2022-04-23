import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tap_debouncer/tap_debouncer.dart';
import 'package:worship_connect/announcements/services/announcements_firebase_api.dart';
import 'package:worship_connect/announcements/utils/announcements_data.dart';
import 'package:worship_connect/announcements/utils/announcements_providers_definition.dart';
import 'package:worship_connect/sign_in/utils/wc_user_info_data.dart';
import 'package:worship_connect/wc_core/worship_connect_utilities.dart';
import 'package:worship_connect/wc_core/core_providers_definition.dart';

class EditAnnouncementCard extends ConsumerStatefulWidget {
  const EditAnnouncementCard({Key? key, required this.announcement}) : super(key: key);
  final WCAnnouncementsData announcement;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditAnnouncementCardState();
}

class _EditAnnouncementCardState extends ConsumerState<EditAnnouncementCard> {
  static final TextEditingController _announcementTextController = TextEditingController();

  @override
  void initState() {
    _announcementTextController.text = widget.announcement.announcementText;
    _announcementTextController.selection = TextSelection.fromPosition(TextPosition(offset: widget.announcement.announcementText.length));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Hero(
          tag: widget.announcement.announcementID,
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
                    'Edit Announcement',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  _announcementTextField(),
                  _announcementButtons(context, ref),
                ],
              ),
            ),
          ),
        ),
      ),
    );
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

  SingleChildScrollView _announcementButtons(BuildContext context, WidgetRef ref) {
    AsyncData<WCUserInfoData?>? wcUserInfoData = ref.watch(wcUserInfoDataStream).asData;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: (WCUtils.screenWidth(context) - 96) / 3,
          ),
          TextButton(
            onPressed: () async {
              if (widget.announcement.announcementText != _announcementTextController.text.trim()) {
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
                child: const Text('Edit'),
              );
            },
            onTap: () async {
              if (_announcementTextController.text.isEmpty) {
                WCUtils.wcShowError(wcError: 'Announcement cannot be empty');
                return;
              }

              if (_announcementTextController.text.trim() == widget.announcement.announcementText) {
                Navigator.pop(context);
                return;
              }

              await AnnouncementsFirebaseAPI(wcUserInfoData!.value!.teamID).editAnnouncement(
                announcementText: _announcementTextController.text.trim(),
                announcementID: widget.announcement.announcementID,
              );
              await ref.watch(announcementListProvider.notifier).getAnnouncements();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  TextField _announcementTextField() {
    return TextField(
      controller: _announcementTextController,
      minLines: 5,
      maxLines: 5,
      keyboardType: TextInputType.multiline,
      autocorrect: true,
      enableSuggestions: true,
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
      style: Theme.of(context).textTheme.bodyText2,
    );
  }
}
