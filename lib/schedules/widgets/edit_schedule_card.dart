import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tap_debouncer/tap_debouncer.dart';
import 'package:worship_connect/schedules/providers/calendar_schedule_list_provider.dart';
import 'package:worship_connect/schedules/services/schedules_firebase_api.dart';
import 'package:worship_connect/schedules/utils/schedule_data.dart';
import 'package:worship_connect/schedules/utils/schedules_providers_definition.dart';
import 'package:worship_connect/sign_in/utils/wc_user_info_data.dart';
import 'package:worship_connect/wc_core/worship_connect_utilities.dart';
import 'package:worship_connect/wc_core/core_providers_definition.dart';


class EditScheduleCard extends ConsumerStatefulWidget {
  const EditScheduleCard({Key? key, required this.scheduleData}) : super(key: key);

  final WCScheduleData scheduleData;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditScheduleCardState();
}

class _EditScheduleCardState extends ConsumerState<EditScheduleCard> {
  static final TextEditingController _scheduleTextController = TextEditingController();
  late TimeOfDay _selectedTime;

  @override
  void initState() {
    _scheduleTextController.text = widget.scheduleData.scheduleTitle;
    _scheduleTextController.selection = TextSelection.fromPosition(TextPosition(offset: widget.scheduleData.scheduleTitle.length));
    _selectedTime = TimeOfDay.fromDateTime(widget.scheduleData.timestamp.toDate());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Hero(
            tag: widget.scheduleData.scheduleID,
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
                          'Edit schedule',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      _scheduleTitleTextField(),
                      _timeListTile(context),
                      _scheduleButtons(context, ref)
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
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
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
    BuildContext context,
    WidgetRef ref,
  ) {
    final CalendarScheduleListProvider _calendarScheduleListNotifier = ref.watch(calendarScheduleListProvider.notifier);
    WCUserInfoData _userData = ref.watch(wcUserInfoDataStream).asData!.value!;

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
              if (_scheduleTextController.text.trim() != widget.scheduleData.scheduleTitle) {
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
              if (_scheduleTextController.text.isEmpty) {
                WCUtils.wcShowError('Schedule title cannot be empty');
                return;
              }

              if (_scheduleTextController.text.trim() == widget.scheduleData.scheduleTitle &&
                  _selectedTime == TimeOfDay.fromDateTime(widget.scheduleData.timestamp.toDate())) {
                Navigator.pop(context);
                return;
              }

              WCScheduleData _newScheduleData = WCScheduleData(
                scheduleTitle: _scheduleTextController.text.trim(),
                scheduleID: widget.scheduleData.scheduleID,
                timestamp: Timestamp.fromDate(
                  WCUtils.setDateTimeFromDayAndTime(dateTime: widget.scheduleData.timestamp.toDate(), timeOfDay: _selectedTime),
                ),
                scheduleDateCode: widget.scheduleData.scheduleDateCode,
              );

              await SchedulesFirebaseAPI(_userData.teamID).editSchedule(oldSchedule: widget.scheduleData, newSchedule: _newScheduleData);

              await _calendarScheduleListNotifier.resetScheduleProvider();
              Navigator.pop(context);
            },
            builder: (BuildContext context, TapDebouncerFunc? onTap) {
              return TextButton(
                onPressed: onTap,
                child: const Text(
                  'Edit',
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

  TextField _scheduleTitleTextField() {
    return TextField(
      controller: _scheduleTextController,
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

  ListTile _timeListTile(
    BuildContext context,
  ) {
    String _timeString = WCUtils.timeToString(
      WCUtils.setDateTimeFromDayAndTime(dateTime: DateTime.now(), timeOfDay: _selectedTime),
    );

    return ListTile(
      title: Text(_timeString),
      onTap: () => _timePicker(
        context,
      ),
      trailing: const SizedBox(
        height: 0,
        width: 0,
        child: Icon(Icons.timer),
      ),
    );
  }

  Future _timePicker(
    BuildContext context,
  ) async {
    final _newTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );

    if (_newTime == null) {
      return;
    } else {
      setState(() {
        _selectedTime = _newTime;
      });
    }
  }
}
