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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 6,
              child: _songInfoWidget(ref, context),
            ),
            Expanded(
              flex: 2,
              child: Container(),
            ),
            Expanded(
              flex: 1,
              child: ReorderableDelayedDragStartListener(
                index: index,
                child: const Tooltip(
                  message: 'Long press and drag to reorder songs',
                  triggerMode: TooltipTriggerMode.tap,
                  child: IconButton(
                    icon: Icon(Icons.drag_handle_rounded),
                    onPressed: null,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: PopupMenuButton<int>(
                onSelected: (item) async {
                  switch (item) {
                    case 0:
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
                      break;
                    case 1:
                      ref.read(schedulesSongsProvider.notifier).deleteSong(index);
                      break;
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem<int>(
                    value: 0,
                    child: Text('Edit'),
                  ),
                  const PopupMenuItem<int>(
                    value: 1,
                    child: Text('Delete'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Column _songInfoWidget(WidgetRef ref, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          height: 10,
        ),
        const SizedBox(
          width: 10,
        ),
        Text(
          songData.songURLTitle ?? '',
          softWrap: true,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 18,
          ),
        ),
        Row(
          children: [
            const Text(
              'Title: ',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              songData.songTitle,
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          'Key of ${songData.songKey}',
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Visibility(
          visible: songData.songURL != null,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Link: ',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                songData.songURL ?? '',
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
