import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worship_connect/schedules/providers/schedule_songs_provider.dart';
import 'package:worship_connect/schedules/utils/schedules_providers_definition.dart';
import 'package:worship_connect/schedules/utils/song_data.dart';
import 'package:worship_connect/schedules/widgets/add_song_card.dart';
import 'package:worship_connect/schedules/widgets/song_tile.dart';
import 'package:worship_connect/sign_in/utils/wc_user_info_data.dart';
import 'package:worship_connect/wc_core/worship_connect_utilities.dart';
import 'package:worship_connect/wc_core/core_providers_definition.dart';

class ScheduleInfoSongsPage extends ConsumerWidget {
  const ScheduleInfoSongsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    WCUserInfoData? _wcUserInfoData = ref.watch(wcUserInfoDataStream).asData!.value;
    ScheduleSongsProvider _songsNotifier = ref.watch(schedulesSongsProvider.notifier);

    List _songList = ref.watch(schedulesSongsProvider);

    return Column(
      children: [
        Expanded(
          child: RefreshIndicator(
            onRefresh: () {
              return _songsNotifier.reset();
            },
            child: Visibility(
              visible: _songList.isNotEmpty,
              replacement: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: SizedBox(
                  height: WCUtils.screenHeightSafeAreaAppBarBottomBar(context) - 100,
                  child: Center(
                    child: Text(
                      'No songs for this schedule',
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ),
                ),
              ),
              child: ReorderableListView.builder(
                padding: const EdgeInsets.all(4),
                itemBuilder: (context, index) {
                  return _buildSongTile(_songList, index);
                },
                itemCount: _songList.length,
                buildDefaultDragHandles: true,
                onReorder: (oldIndex, newIndex) {
                  _songsNotifier.reorderSongs(oldIndex, newIndex);
                },
              ),
            ),
          ),
        ),
        if (WCUtils.isAdminOrLeader(_wcUserInfoData!)) _buildButtons(context, ref, _songsNotifier, _wcUserInfoData.userName, _wcUserInfoData.userID),
        const SizedBox(
          height: 4,
        ),
      ],
    );
  }

  Row _buildButtons(
    BuildContext context,
    WidgetRef ref,
    ScheduleSongsProvider _songsNotifier,
    String posterName,
    String posterID,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SizedBox(
          width: 12,
        ),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              ref.read(songKeyProvider.state).state = 'A';
              showDialog(
                context: context,
                builder: (context) {
                  return const AddSongCard();
                },
              );
            },
            child: const Text('Add Song'),
          ),
        ),
        const SizedBox(
          width: 12,
        ),
        Expanded(
          child: ElevatedButton(
            onPressed: () async {
              await _songsNotifier.saveSongs(posterID, posterName);
            },
            child: const Text('Save'),
          ),
        ),
        const SizedBox(
          width: 12,
        ),
      ],
    );
  }

  SongTile _buildSongTile(List<dynamic> _songList, int index) {
    WCSongData _songData = WCSongData(
        songTitle: _songList[index][WCSongDataEnum.songTitle.name],
        songKey: _songList[index][WCSongDataEnum.songKey.name],
        songURL: _songList[index][WCSongDataEnum.songURL.name],
        songID: _songList[index][WCSongDataEnum.songID.name],
        songURLTitle: _songList[index][WCSongDataEnum.songURLTitle.name]);
    return SongTile(
      songData: _songData,
      key: ValueKey(_songList[index]),
      index: index,
    );
  }
}
