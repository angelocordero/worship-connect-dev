import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worship_connect/schedules/services/schedules_firebase_api.dart';
import 'package:worship_connect/schedules/utils/schedule_data.dart';
import 'package:worship_connect/settings/services/team_firebase_api.dart';
import 'package:worship_connect/wc_core/worship_connect_constants.dart';

class ScheduleMusiciansProvider extends StateNotifier<Map<String, dynamic>> {
  ScheduleMusiciansProvider({required this.teamID, required this.scheduleData}) : super({});

  WCScheduleData scheduleData;
  String teamID;

  static final List<String> _alreadyAssignedMembers = [];

  addCustomInstrument(String _instrument) async {
    await TeamFirebaseAPI(teamID).addCustomInstrument(_instrument);
    addInstrument(_instrument);
  }

  addInstrument(String _instrument) {
    state[_instrument] = [];

    SplayTreeMap<String, dynamic> _tempSTMap = _sortUsingSTMap(state);

    state = Map<String, dynamic>.from(_tempSTMap);
  }

  addInstrumentsList(List<String> totalInstrumentsList) {
    List<String> alreadyAddedInstruments = [];

    alreadyAddedInstruments.addAll(state.keys);

    return totalInstrumentsList.toSet().difference(alreadyAddedInstruments.toSet()).toList();
  }

  addMusicians({required String instrument, required List<String> musicians}) {
    state[instrument].addAll(musicians);
    _alreadyAssignedMembers.addAll(musicians);

    state = Map<String, dynamic>.from(state);
  }

  deleteCustomInstrument(String _instrument) async {
    await TeamFirebaseAPI(teamID).deleteCustomInstrument(_instrument);
  }

  List<String> getUnassignedMembersList(List<String> completeMembersList) {
    return completeMembersList.toSet().difference(_alreadyAssignedMembers.toSet()).toList();
  }

  init() async {
    _alreadyAssignedMembers.clear();

    DocumentSnapshot<Map<String, dynamic>>? doc = await SchedulesFirebaseAPI(teamID).getScheduleInfo(scheduleData.scheduleID);

    if (doc == null) {
      return;
    }

    if (!doc.exists) {
      return;
    }

    SplayTreeMap<String, dynamic> _tempSTMap = _sortUsingSTMap(doc['musicians']);

    state = Map<String, dynamic>.from(_tempSTMap);

    //adds already assigned members to list so duplicate assignments are not allowed
    state.forEach((key, value) {
      _alreadyAssignedMembers.addAll(List<String>.from(value));
    });
  }

  removeInstruments(String _instrument) {
    for (var element in state[_instrument]) {
      _alreadyAssignedMembers.remove(element);
    }

    state.remove(_instrument);

    state = Map<String, dynamic>.from(state);
  }

  removeMusician({required String instrument, required String musician}) {
    state[instrument].remove(musician);
    _alreadyAssignedMembers.remove(musician);
    state = Map<String, dynamic>.from(state);
  }

  reset() async {
    state.clear();
    _alreadyAssignedMembers.clear();
    await init();
  }

  saveMusicians(String posterID, String posterName) async {
    await SchedulesFirebaseAPI(teamID).saveMusiciansData(
      musiciansData: state,
      scheduleData: scheduleData,
      posterName: posterName,
      posterID: posterID,
    );
  }

  // sorts instrument map based on core instruments list order
  SplayTreeMap<String, dynamic> _sortUsingSTMap(Map input) {
    return SplayTreeMap<String, dynamic>.from(input, (a, b) {
      if (!wcCoreInstruments.contains(a)) {
        return 1;
      }

      if (!wcCoreInstruments.contains(b)) {
        return -1;
      }

      return wcCoreInstruments.indexOf(a).compareTo(wcCoreInstruments.indexOf(b));
    });
  }
}
