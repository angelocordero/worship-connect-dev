import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worship_connect/schedules/providers/schedule_songs_provider.dart';
import 'package:worship_connect/schedules/utils/schedules_providers_definition.dart';
import 'package:worship_connect/schedules/utils/song_data.dart';
import 'package:worship_connect/schedules/widgets/add_song_card.dart';
import 'package:worship_connect/schedules/widgets/song_tile.dart';
import 'package:worship_connect/sign_in/utils/wc_user_info_data.dart';
import 'package:worship_connect/wc_core/wc_custom_route.dart';
import 'package:worship_connect/wc_core/worship_connect.dart';
import 'package:worship_connect/wc_core/worship_connect_utilities.dart';

class ScheduleInfoSongsPage extends ConsumerWidget {
  const ScheduleInfoSongsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    WCUserInfoData? _wcUserInfoData = ref.watch(wcUserInfoDataStream).asData!.value;
    ScheduleSongsProvider _songsNotifier = ref.watch(schedulesSongsProvider.notifier);

    List _songList = ref.watch(schedulesSongsProvider);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Expanded(
            child: ReorderableListView.builder(
              itemBuilder: (context, index) {
                SongData _songData = SongData(
                  songTitle: _songList[index][SongDataEnum.songTitle.name],
                  songKey: _songList[index][SongDataEnum.songKey.name],
                  songURL: _songList[index][SongDataEnum.songURL.name],
                  songID: _songList[index][SongDataEnum.songID.name],
                );
                return SongTile(
                  songData: _songData,
                  key: ValueKey(_songList[index]),
                );
              },
              itemCount: _songList.length,
              buildDefaultDragHandles: true,
              onReorder: (oldIndex, newIndex) {
                _songsNotifier.reorderSongs(oldIndex, newIndex);
              },
            ),
          ),
          if (WCUtils().isAdminOrLeader(_wcUserInfoData!))
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Hero(
                    tag: 'song',
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          WCCustomRoute(
                            builder: (context) {
                              return const AddSongCard();
                            },
                          ),
                        );
                      },
                      child: const Text('Add Song'),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      await _songsNotifier.saveSchedule();
                    },
                    child: const Text('Save'),
                  ),
                ),
              ],
            )
        ],
      ),
    );
  }
}
