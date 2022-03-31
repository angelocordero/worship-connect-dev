import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worship_connect/settings/services/team_firebase_api.dart';

class InstrumentsListProvider extends StateNotifier<Map<String, dynamic>> {
  InstrumentsListProvider({required this.teamID}) : super({});

  final String teamID;

  init() async {
    DocumentSnapshot _doc = await TeamFirebaseAPI(teamID).getInstrumentsDocument();

    state = _doc.data() as Map<String, dynamic>;
  }
}
