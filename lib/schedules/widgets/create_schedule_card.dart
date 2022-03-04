import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tap_debouncer/tap_debouncer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:worship_connect/schedules/utils/schedule_data.dart';
import 'package:worship_connect/schedules/providers/add_schedule_provider.dart';
import 'package:worship_connect/schedules/providers/calendar_schedule_list_provider.dart';
import 'package:worship_connect/schedules/utils/schedules_providers_definition.dart';
import 'package:worship_connect/wc_core/worship_connect_utilities.dart';

class CreateScheduleCard extends ConsumerStatefulWidget {
  const CreateScheduleCard({
    Key? key,
    required this.addOrEdit,
    required this.tag,
  }) : super(key: key);
  final String tag;
  final String addOrEdit;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreateScheduleCardState();
}

class _CreateScheduleCardState extends ConsumerState<CreateScheduleCard> {
  final TextEditingController _scheduleEditingController = TextEditingController();
  late final WCScheduleData _scheduleData;

  @override
  void initState() {
    _scheduleData = ref.read(addScheduleProvider);
    _scheduleEditingController.text = _scheduleData.scheduleTitle;
    _scheduleEditingController.selection = TextSelection.fromPosition(
      TextPosition(offset: _scheduleData.scheduleTitle.length),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final WCScheduleData _scheduleData = ref.watch(addScheduleProvider);
    final AddScheduleProvider _scheduleNotifier = ref.watch(addScheduleProvider.notifier);
    final CalendarScheduleListProvider _calendarScheduleListNotifier = ref.watch(calendarScheduleListProvider.notifier);

    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Hero(
            tag: widget.tag,
            child: Material(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          '${widget.addOrEdit} schedule',
                          style: const TextStyle(
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
                        context: context,
                        scheduleNotifier: _scheduleNotifier,
                        calendarScheduleListNotifier: _calendarScheduleListNotifier,
                      )
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

  SingleChildScrollView _scheduleButtons({
    required BuildContext context,
    required AddScheduleProvider scheduleNotifier,
    required CalendarScheduleListProvider calendarScheduleListNotifier,
  }) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            width: WCUtils.screenWidth(context) / 4 - 16,
          ),
          TapDebouncer(
            onTap: () async {
              if (_scheduleEditingController.text.isNotEmpty) {
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
              if (_scheduleEditingController.text.isEmpty) {
                WCUtils.wcShowError('Schedule title cannot be empty');
                return;
              }

              if (_scheduleData.scheduleTitle.isEmpty) {
                //new schedule
                await scheduleNotifier.addSchedule(title: _scheduleEditingController.text.trim());
              } else if (_scheduleData.scheduleTitle != _scheduleEditingController.text.trim() ||
                  scheduleNotifier.temp!.timestamp != ref.read(addScheduleProvider).timestamp) {
                // edit schedule
                await scheduleNotifier.editSchedule(_scheduleEditingController.text.trim());
              }

              await calendarScheduleListNotifier.resetScheduleProvider();
              Navigator.pop(context);
            },
            builder: (BuildContext context, TapDebouncerFunc? onTap) {
              return TextButton(
                onPressed: onTap,
                child: Text(
                  widget.addOrEdit,
                  style: const TextStyle(
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

  TextField _scheduleTitleTextField() {
    return TextField(
      controller: _scheduleEditingController,
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
      trailing: const SizedBox(
        height: 0,
        width: 0,
        child: Icon(Icons.timer),
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
}
