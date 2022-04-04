import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worship_connect/schedules/services/schedules_firebase_api.dart';
import 'package:worship_connect/settings/services/team_firebase_api.dart';
import 'package:worship_connect/wc_core/worship_connect_constants.dart';

class ScheduleMusiciansProvider extends StateNotifier<Map<String, dynamic>> {
  ScheduleMusiciansProvider({required this.teamID, required this.scheduleID}) : super({});

  String teamID;
  String scheduleID;
  static final List<String> _alreadyAssignedMembers = [];

  init() async {
    _alreadyAssignedMembers.clear();

    DocumentSnapshot<Map<String, dynamic>>? doc = await SchedulesFirebaseAPI(teamID).getScheduleInfo(scheduleID);

    if (doc == null) {
      return;
    }

    if (!doc.exists) {
      return;
    }

    Map<String, dynamic> temp = doc['musicians'];

    state = Map<String, dynamic>.from(temp);

    state.forEach((key, value) {
      _alreadyAssignedMembers.addAll(List<String>.from(value));
    });
  }

  reset() async {
    state.clear();
    _alreadyAssignedMembers.clear();
    await init();
  }

  saveMusicians() async {
    await SchedulesFirebaseAPI(teamID).saveMusiciansData(state, scheduleID);
  }

  addInstrumentsList(List<String> totalInstrumentsList) {
    List<String> alreadyAddedInstruments = [];

    alreadyAddedInstruments.addAll(state.keys);

    return totalInstrumentsList.toSet().difference(alreadyAddedInstruments.toSet()).toList();
  }

  addInstrument(String _instrument) {
    state[_instrument] = [];

    SplayTreeMap<String, dynamic> _tempSTMap = SplayTreeMap<String, dynamic>.from(state, (a, b) {
      return wcCoreInstruments.indexOf(a).compareTo(wcCoreInstruments.indexOf(b));
    });

    state = Map<String, dynamic>.from(_tempSTMap);
  }

  addCustomInstrument(String _instrument) async {
    await TeamFirebaseAPI(teamID).addCustomInstrument(_instrument);
    addInstrument(_instrument);
  }

  removeInstruments(String _instrument) {
    for (var element in state[_instrument]) {
      _alreadyAssignedMembers.remove(element);
    }

    state.remove(_instrument);

    state = Map<String, dynamic>.from(state);
  }

  addMusicians({required String instrument, required List<String> musicians}) {

    state[instrument].addAll(musicians);
    _alreadyAssignedMembers.addAll(musicians);

    state = Map<String, dynamic>.from(state);
  }

  removeMusician({required String instrument, required String musician}) {

    state[instrument].remove(musician);
    _alreadyAssignedMembers.remove(musician);
    state = Map<String, dynamic>.from(state);
  }

  List<String> getUnassignedMembersList(List<String> completeMembersList) {
    return completeMembersList.toSet().difference(_alreadyAssignedMembers.toSet()).toList();
  }

  deleteCustomInstrument(String _instrument) async {
    await TeamFirebaseAPI(teamID).deleteCustomInstrument(_instrument);
  }
}
