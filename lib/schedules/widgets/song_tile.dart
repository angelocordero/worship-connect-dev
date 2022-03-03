import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worship_connect/schedules/utils/schedules_providers_definition.dart';
import 'package:worship_connect/schedules/utils/song_data.dart';
import 'package:worship_connect/schedules/widgets/edit_song_card.dart';
import 'package:worship_connect/wc_core/wc_custom_route.dart';

class SongTile extends ConsumerWidget {
  const SongTile({
    Key? key,
    required this.songData,
    required this.index,
  }) : super(key: key);

  final WCSongData songData;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              songData.songTitle,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(
              height: 4,
            ),
            Text(
              'Key of ${songData.songKey}',
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(
              height: 4,
            ),
            Visibility(
              visible: songData.songURL != null,
              child: TextButton(
                child: Text(songData.songURL ?? ''),
                onPressed: () {
                  //LinksService.openSongLink(WCSongData.url);
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                ref.read(schedulesSongsProvider.notifier).deleteSong(index);
              },
              child: const Text('delete'),
            ),
            ElevatedButton(
              child: const Text('edit'),
              onPressed: () {
                ref.read(songKeyProvider.state).state = songData.songKey;

                Navigator.push(
                  context,
                  WCCustomRoute(
                    builder: (context) {
                      return EditSongCard(
                        songData: songData,
                        index: index,
                      );
                    },
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
