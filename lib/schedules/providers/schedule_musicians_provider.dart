import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worship_connect/schedules/services/schedules_firebase_api.dart';

class ScheduleMusiciansProvider extends StateNotifier<Map<String, dynamic>> {
  ScheduleMusiciansProvider({required this.teamID, required this.scheduleID}) : super({});

  String teamID;
  String scheduleID;
  static final List<String> _alreadyAssignedMembers = [];

  init() async {
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
    Map<String, dynamic> _temp = state;

    _temp[_instrument] = [];

    state = Map<String, dynamic>.from(_temp);
  }

  removeInstruments(String _instrument) {
    Map<String, dynamic> _temp = state;

    _temp.remove(_instrument);

    state = Map<String, dynamic>.from(_temp);
  }

  addMusicians({required String instrument, required List<String> musicians}) {
    Map<String, dynamic> _temp = state;

    _temp[instrument].addAll(musicians);
    _alreadyAssignedMembers.addAll(musicians);

    state = Map<String, dynamic>.from(_temp);
  }

  removeMusician({required String instrument, required String musician}) {
    Map<String, dynamic> _temp = state;

    _temp[instrument].remove(musician);
    _alreadyAssignedMembers.remove(musician);
    state = Map<String, dynamic>.from(_temp);
  }

  List<String> getUnassignedMembersList(List<String> completeMembersList) {
    return completeMembersList.toSet().difference(_alreadyAssignedMembers.toSet()).toList();
  }
}
