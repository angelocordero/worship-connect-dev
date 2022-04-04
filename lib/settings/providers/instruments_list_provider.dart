import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worship_connect/settings/services/team_firebase_api.dart';

class CustomInstrumentsListProvider extends StateNotifier<List<String>> {
  CustomInstrumentsListProvider({required this.teamID}) : super([]);

  final String teamID;

  init() async {
    try {
      DocumentSnapshot _doc = await TeamFirebaseAPI(teamID).getInstrumentsDocument();

      Map<String, dynamic>? _map = _doc.data() as Map<String, dynamic>;

      state = List.from(_map['customInstruments'] ?? []);
    } catch (e) {
      state = [];
    }
  }
}
