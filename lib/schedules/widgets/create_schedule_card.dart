import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tap_debouncer/tap_debouncer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:worship_connect/schedules/data_classes/schedule_data.dart';
import 'package:worship_connect/schedules/providers/add_schedule_provider.dart';
import 'package:worship_connect/schedules/screens/schedules_home_page.dart';
import 'package:worship_connect/sign_in/data_classes/wc_user_info_data.dart';
import 'package:worship_connect/wc_core/worship_connect.dart';

class CreateScheduleCard extends ConsumerWidget {
  CreateScheduleCard({Key? key}) : super(key: key);

  final TextEditingController _textEditingController = TextEditingController();

  Future<dynamic> showCancelDialog(BuildContext context) {
    return showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text('Confirm cancel?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'no',
                style: TextStyle(
                  fontSize: 12.0,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                FocusScope.of(context).unfocus();
                Navigator.pop(context);
              },
              child: const Text(
                'yes',
                style: TextStyle(
                  fontSize: 12.0,
                ),
              ),
            )
          ],
        );
      },
    );
  }

  SingleChildScrollView _scheduleButtons(
    //TODO: code cleanup. make parameters named

    BuildContext context,
    AddScheduleProvider scheduleNotifier,
    WCUserInfoData wcUserInfoData,
  ) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width / 4 - 16,
          ),
          TapDebouncer(
            onTap: () async {
              if (_textEditingController.text.isNotEmpty) {
                showCancelDialog(context);
              } else {
                Navigator.pop(context);
              }
            },
            builder: (BuildContext context, TapDebouncerFunc? onTap) {
              return TextButton(
                onPressed: onTap,
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    fontSize: 12.0,
                  ),
                ),
              );
            },
          ),
          const SizedBox(
            width: 16,
          ),
          TapDebouncer(
            onTap: () async {
              if (_textEditingController.text.isNotEmpty) {
                await scheduleNotifier.addSchedule(title: _textEditingController.text, teamID: wcUserInfoData.teamID);

                if (true == true /*editScheduleData == null*/) {
                  // context.read<AddScheduleModel>().setScheduleDay(selectedDay!);
                  // context.read<AddScheduleModel>().setScheduleTitle(_textEditingController.text.trim());
                  // await context.read<AddScheduleModel>().addSchedule();
                } else {
                  // context.read<AddScheduleModel>().setScheduleDay(editScheduleData!.timeStamp.toDate());
                  // context.read<AddScheduleModel>().setScheduleTitle(_textEditingController.text.trim());
                  // await context.read<AddScheduleModel>().editSchedule(editScheduleData!);
                }
                //await reset!();
                Navigator.pop(context);
              }
            },
            builder: (BuildContext context, TapDebouncerFunc? onTap) {
              return TextButton(
                onPressed: onTap,
                child: const Text(
                  'Create Schedule',
                  style: TextStyle(
                    fontSize: 12.0,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  ListTile _timeListTile({
    required AddScheduleProvider scheduleNotifier,
    required BuildContext context,
    required WCScheduleData scheduleData,
  }) {
    return ListTile(
      title: Text(scheduleData.timeString),
      onTap: () => _timePicker(
        context: context,
        scheduleNotifier: scheduleNotifier,
        scheduleData: scheduleData,
      ),
      trailing: const Icon(Icons.timer),
    );
  }

  TextField _scheduleTitleTextField() {
    return TextField(
      controller: _textEditingController,
      minLines: 2,
      maxLines: 2,
      autocorrect: true,
      enableSuggestions: true,
      cursorColor: Colors.black,
      decoration: const InputDecoration(
        hintText: 'Title',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(12.0),
          ),
        ),
      ),
    );
  }

  Future _timePicker({
    required BuildContext context,
    required AddScheduleProvider scheduleNotifier,
    required WCScheduleData scheduleData,
  }) async {
    final _newTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(scheduleData.timestamp.toDate()),
    );

    if (_newTime == null) {
      return;
    } else {
      scheduleNotifier.setScheduleTime(_newTime);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _scheduleData = ref.watch(addScheduleProvider);
    final _scheduleNotifier = ref.watch(addScheduleProvider.notifier);
    WCUserInfoData? _wcUserInfoData = ref.watch(wcUserInfoDataStream).asData!.value;

    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Hero(
            tag: 'schedule',
            child: Material(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          'Create a schedule',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      _scheduleTitleTextField(),
                      _timeListTile(
                        context: context,
                        scheduleData: _scheduleData,
                        scheduleNotifier: _scheduleNotifier,
                      ),
                      _scheduleButtons(
                        context,
                        _scheduleNotifier,
                        _wcUserInfoData!,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
