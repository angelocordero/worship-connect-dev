import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worship_connect/announcements/screens/announcements_home_page.dart';
import 'package:worship_connect/wc_core/worship_connect_utilities.dart';

class SendAnnouncementForm extends StatelessWidget {
  const SendAnnouncementForm({Key? key, required this.tag, required this.sendOrEdit}) : super(key: key);

  final String tag;
  final String sendOrEdit;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Hero(
          tag: tag,
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
                    '$sendOrEdit Announcement',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  _announcementTextField(),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: (WCUtils().screenWidth(context)! - 96) / 3,
                        ),
                        TextButton(
                          onPressed: () {
                            //TODO: add confirmation popup
                            Navigator.pop(context);
                          },
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            //TODO: send announcement
                          },
                          child: Text(sendOrEdit),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Consumer _announcementTextField() {
    return Consumer(
      builder: (context, ref, _) {
        final _announcement = ref.watch(sendAnnouncementProvider);

        return TextFormField(
          initialValue: _announcement.announcementText,
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
      },
    );
  }
}
