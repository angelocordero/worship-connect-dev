import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worship_connect/schedules/services/schedules_firebase_api.dart';
import 'package:worship_connect/schedules/utils/schedule_data.dart';
import 'package:worship_connect/schedules/utils/song_data.dart';
import 'package:worship_connect/wc_core/wc_url_utilities.dart';
import 'package:worship_connect/wc_core/worship_connect_utilities.dart';

class ScheduleSongsProvider extends StateNotifier<List<Map<String, dynamic>>> {
  ScheduleSongsProvider({required this.teamID, required this.scheduleData}) : super([]);

  String teamID;
  WCScheduleData scheduleData;

  init() async {
    DocumentSnapshot<Map<String, dynamic>>? doc = await SchedulesFirebaseAPI(teamID).getScheduleInfo(scheduleData.scheduleID);

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

  Future addSong({
    required String title,
    required String key,
    required String? url,
  }) async {
    List<Map<String, dynamic>> temp = state;

    temp.add({
      WCSongDataEnum.songTitle.name: title,
      WCSongDataEnum.songKey.name: key,
      WCSongDataEnum.songURL.name: url,
      WCSongDataEnum.songID.name: WCUtils.generateRandomID(),
      WCSongDataEnum.songURLTitle.name: await _getUrlTitle(url),
    });

    state = temp.toList();
  }

  saveSongs(String posterID, String posterName) async {
    await SchedulesFirebaseAPI(teamID).saveSongsData(
      songsData: state,
      scheduleData: scheduleData,
      posterName: posterName,
      posterID: posterID,
    );
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

  Future editSong({
    required String title,
    required String key,
    required String? url,
    required String songID,
    required int index,
  }) async {
    List<Map<String, dynamic>> temp = state;

    temp.removeAt(index);

    temp.insert(index, {
      WCSongDataEnum.songTitle.name: title,
      WCSongDataEnum.songKey.name: key,
      WCSongDataEnum.songURL.name: url,
      WCSongDataEnum.songID.name: songID,
      WCSongDataEnum.songURLTitle.name: await _getUrlTitle(url),
    });

    state = temp.toList();
  }

  Future<String?> _getUrlTitle(String? url) async {
    if (url != null) {
      return await WCUrlUtils.getYoutubeLinkTitle(url);
    } else {
      return null;
    }
  }
}
