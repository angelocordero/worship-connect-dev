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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _songInfo(),
          _dragHandle(ref),
          _popupMenu(context, ref),
        ],
      ),
    );
  }

  Expanded _songInfo() {
    return Expanded(
      flex: 8,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              songData.songTitle,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              'Key of ${songData.songKey}',
              style: const TextStyle(fontSize: 14),
            ),
            Visibility(
              replacement: const SizedBox(
                height: 16,
              ),
              visible: songData.songURL != null,
              child: ListTile(
                contentPadding: const EdgeInsets.all(0),
                horizontalTitleGap: 5,
                dense: true,
                leading: _leadingIcon(),
                title: TextButton(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      songData.songURLTitle ?? songData.songURL ?? '',
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  onPressed: () {},
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _leadingIcon() {
    if (songData.songURL == null) {
      return Container();
    } else if (songData.songURL!.contains('facebook')) {
      return Image.asset(
        'assets/facebook_logo.png',
        width: 30,
        height: 30,
      );
    } else if (songData.songURL!.contains('youtube')) {
      return Image.asset(
        'assets/youtube_logo.png',
        height: 30,
        width: 30,
      );
    } else {
      return const Icon(Icons.my_library_music);
    }
  }

  Expanded _dragHandle(WidgetRef ref) {
    return Expanded(
      flex: 1,
      child: Visibility(
        visible: ref.watch(schedulesSongsProvider).length > 1,
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
    );
  }

  Expanded _popupMenu(BuildContext context, WidgetRef ref) {
    return Expanded(
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
    );
  }
}
