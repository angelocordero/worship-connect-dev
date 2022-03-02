import 'package:flutter/material.dart';
import 'package:worship_connect/schedules/utils/song_data.dart';

class SongTile extends StatelessWidget {
  const SongTile({Key? key, required this.songData}) : super(key: key);

  final SongData songData;

  @override
  Widget build(BuildContext context) {
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
             TextButton(
                child: Text(songData.songURL),
                onPressed: () {
                  //LinksService.openSongLink(songData.url);
                },
              ),
          ],
        ),
      ),
    );
  }
}
