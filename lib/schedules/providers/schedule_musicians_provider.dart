import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worship_connect/schedules/services/schedules_firebase_api.dart';

class ScheduleMusiciansProvider extends StateNotifier<List<Map<String, dynamic>>> {
  ScheduleMusiciansProvider({required this.teamID, required this.scheduleID}) : super([]);

  String teamID;
  String scheduleID;

  init() async {
    DocumentSnapshot<Map<String, dynamic>>? doc = await SchedulesFirebaseAPI(teamID).getScheduleInfo(scheduleID);

    if (doc == null) {
      return;
    }

    if (!doc.exists) {
      return;
    }

    List temp = doc['musicians'] ?? <Map<String, dynamic>>[];

    state = List<Map<String, dynamic>>.from(temp);
  }

  reset() async {
    state.clear();
    await init();
  }

  addInstrumentsList(List<String> totalInstrumentsList) {
    List<String> alreadyAddedInstruments = [];

    for (var element in state) {
      alreadyAddedInstruments.add(element.keys.first);
    }

    return totalInstrumentsList.toSet().difference(alreadyAddedInstruments.toSet()).toList();
  }

  addInstrument(String _instrument) {
    state.add({
      _instrument: [],
    });

    state = state.toList();
  }

  removeInstruments(String instrument) {
    state.removeWhere((element) {
      return element.keys.first == instrument;
    });

    state = state.toList();
  }

  addMusician({required String instrument, required String musician}) {
    Map<String, dynamic> _instrument = state.firstWhere((element) {
      return element.keys.first == instrument;
    });

    _instrument.values.first.add(musician);

    state = state.toList();
  }

  removeMusician({required String instrument, required String musician}) {
    Map<String, dynamic> _instrument = state.firstWhere((element) {
      return element.keys.first == instrument;
    });

    _instrument.values.first.remove(musician);

    state = state.toList();
  }
}
