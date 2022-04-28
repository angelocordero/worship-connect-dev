import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tap_debouncer/tap_debouncer.dart';
import 'package:worship_connect/schedules/utils/schedules_providers_definition.dart';
import 'package:worship_connect/schedules/widgets/keys_dropdown.dart';
import 'package:worship_connect/wc_core/worship_connect_utilities.dart';

class AddSongCard extends ConsumerStatefulWidget {
  const AddSongCard({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddSongCardState();
}

class _AddSongCardState extends ConsumerState<AddSongCard> {
  final TextEditingController _linkEditingController = TextEditingController();
  final TextEditingController _titleEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final String _songKey = ref.watch(songKeyProvider);

    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Add Song',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                  ),
                  TextField(
                    style: Theme.of(context).textTheme.bodyText2,
                    controller: _titleEditingController,
                    autocorrect: true,
                    enableSuggestions: true,
                    decoration: const InputDecoration(
                      isDense: true,
                      hintText: 'Title (Required)',
                      contentPadding: EdgeInsets.all(12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(12.0),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const SizedBox(
                    width: 150,
                    child: SongKeyDropdown(),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    maxLines: 2,
                    minLines: 2,
                    style: Theme.of(context).textTheme.bodyText2,
                    controller: _linkEditingController,
                    autocorrect: true,
                    enableSuggestions: true,
                    decoration: const InputDecoration(
                      isDense: true,
                      hintText: 'Link (Optional)',
                      contentPadding: EdgeInsets.all(12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(12.0),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      const Spacer(),
                      TapDebouncer(
                        onTap: () async {
                          if (_titleEditingController.text.isNotEmpty) {
                            showCancelDialog(context);
                          } else {
                            Navigator.pop(context);
                          }
                        },
                        builder: (BuildContext context, TapDebouncerFunc? onTap) {
                          return TextButton(
                            onPressed: onTap,
                            child: const Text(
                              'Cancel',
                              style: TextStyle(
                                fontSize: 12.0,
                              ),
                            ),
                          );
                        },
                      ),
                      TapDebouncer(
                        onTap: () async {
                          if (_titleEditingController.text.isEmpty) {
                            WCUtils.wcShowError(wcError: 'Song title can not be empty');
                            return;
                          }

                          await ref.read(schedulesSongsProvider.notifier).addSong(
                                title: _titleEditingController.text.trim(),
                                key: _songKey,
                                url: _linkEditingController.text.trim().isNotEmpty ? _linkEditingController.text.trim() : null,
                              );
                          Navigator.pop(context);
                        },
                        builder: (BuildContext context, TapDebouncerFunc? onTap) {
                          return TextButton(
                            onPressed: onTap,
                            child: const Text(
                              'Add',
                              style: TextStyle(
                                fontSize: 12.0,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<dynamic> showCancelDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm cancel?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'no',
                style: TextStyle(
                  fontSize: 12.0,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                FocusScope.of(context).unfocus();
                Navigator.pop(context);
              },
              child: const Text(
                'yes',
                style: TextStyle(
                  fontSize: 12.0,
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
