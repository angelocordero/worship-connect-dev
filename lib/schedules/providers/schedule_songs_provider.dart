import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worship_connect/schedules/services/schedules_firebase_api.dart';
import 'package:worship_connect/schedules/utils/song_data.dart';
import 'package:worship_connect/wc_core/worship_connect_utilities.dart';

class ScheduleSongsProvider extends StateNotifier<List<Map<String, dynamic>>> {
  String teamID;
  String scheduleID;

  ScheduleSongsProvider({required this.teamID, required this.scheduleID}) : super([]);

  init() async {
    DocumentSnapshot<Map<String, dynamic>>? doc = await SchedulesFirebaseAPI(teamID).getScheduleInfo(scheduleID);

    if (doc == null) {
      return;
    }

    if (!doc.exists) {
      return;
    }

    List temp = doc['songs'] ?? <Map<String, dynamic>>[];

    state = List<Map<String, dynamic>>.from(temp);
  }

  reset() async {
    state.clear();
    await init();
  }

  addSong({
    required String title,
    required String key,
    required String url,
  }) {
    List<Map<String, dynamic>> temp = state;

    temp.add({
      WCSongDataEnum.songTitle.name: title,
      WCSongDataEnum.songKey.name: key,
      WCSongDataEnum.songURL.name: url,
      WCSongDataEnum.songID.name: WCUtils().generateRandomID(),
    });

    state = temp.toList();
  }

  saveSchedule() async {
    await SchedulesFirebaseAPI(teamID).saveScheduleData(state, scheduleID);
  }

  reorderSongs(int oldIndex, int newIndex) {
    int index;
    List<Map<String, dynamic>> temp = state;

    if (newIndex > oldIndex) {
      index = newIndex - 1;
    } else {
      index = newIndex;
    }

    final Map<String, dynamic> song = temp.removeAt(oldIndex);
    temp.insert(index, song);
    state = temp.toList();
  }

  deleteSong(int index) {
    List<Map<String, dynamic>> temp = state;

    temp.removeAt(index);

    state = temp.toList();
  }

  editSong({
    required String title,
    required String key,
    required String url,
    required String songID,
    required int index,
  }) {
    List<Map<String, dynamic>> temp = state;

    temp.removeAt(index);

    temp.insert(index, {
      WCSongDataEnum.songTitle.name: title,
      WCSongDataEnum.songKey.name: key,
      WCSongDataEnum.songURL.name: url,
      WCSongDataEnum.songID.name: songID,
    });

    state = temp.toList();
  }
}
