import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worship_connect/schedules/utils/schedules_providers_definition.dart';
import 'package:worship_connect/schedules/utils/song_data.dart';
import 'package:worship_connect/schedules/widgets/edit_song_card.dart';
import 'package:worship_connect/wc_core/wc_url_utilities.dart';

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
          _songInfo(context),
          _dragHandle(ref),
          _popupMenu(context, ref),
        ],
      ),
    );
  }

  Expanded _songInfo(BuildContext context) {
    TextStyle style = Theme.of(context).textTheme.bodyText2!;

    return Expanded(
      flex: 8,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              songData.songTitle,
              style: style.copyWith(fontSize: 16),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              'Key of ${songData.songKey}',
              style: style,
            ),
            Visibility(
              replacement: const SizedBox(
                height: 8,
              ),
              visible: songData.songURL != null,
              child: ListTile(
                contentPadding: const EdgeInsets.all(0),
                horizontalTitleGap: 5,
                dense: true,
                leading: _leadingIcon(),
                title: Text(
                  songData.songURLTitle ?? songData.songURL ?? '',
                  textAlign: TextAlign.start,
                  style: style.copyWith(color: Colors.blue),
                ),
                onTap: () async {
                  if (songData.songURL != null) {
                    await WCUrlUtils.openURL(songData.songURL!);
                  }
                },
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
    } else if (songData.songURL!.contains('youtube') || songData.songURL!.contains('youtu.be')) {
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
      child: ReorderableDelayedDragStartListener(
        index: index,
        child: Tooltip(
          message: 'Long press and drag to reorder songs',
          triggerMode: TooltipTriggerMode.tap,
          child: AnimatedCrossFade(
            firstChild: const SizedBox(height: 48, width: 48),
            secondChild: const SizedBox(
              height: 48,
              width: 48,
              child: Icon(Icons.drag_handle_rounded),
            ),
            crossFadeState:
                ref.watch(schedulesSongsProvider).length > 1 && ref.watch(isEditingProvider) ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 250),
          ),
        ),
      ),
    );
  }

  Expanded _popupMenu(BuildContext context, WidgetRef ref) {
    return Expanded(
      flex: 1,
      child: AnimatedCrossFade(
        firstChild: const SizedBox(height: 48, width: 48),
        secondChild: PopupMenuButton<int>(
          onSelected: (item) async {
            switch (item) {
              case 0:
                ref.read(songKeyProvider.state).state = songData.songKey;
                showDialog(
                  context: context,
                  builder: (context) {
                    return EditSongCard(
                      songData: songData,
                      index: index,
                    );
                  },
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
        crossFadeState: ref.watch(isEditingProvider) ? CrossFadeState.showSecond : CrossFadeState.showFirst,
        duration: const Duration(milliseconds: 250),
      ),
    );
  }
}
