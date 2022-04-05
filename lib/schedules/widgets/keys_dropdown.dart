import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worship_connect/schedules/utils/schedules_providers_definition.dart';

class SongKeyDropdown extends ConsumerWidget {
  const SongKeyDropdown({Key? key}) : super(key: key);

  static final List<String> songKeyList = [
    'A',
    'A#',
    'B',
    'C',
    'C#',
    'D',
    'D#',
    'E',
    'F',
    'F#',
    'G',
    'G#',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String key = ref.watch(songKeyProvider);

    return ButtonTheme(
      alignedDropdown: true,
      child: DropdownButtonFormField<String>(
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.all(8),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(12.0),
            ),
          ),
        ),
        isDense: true,
        menuMaxHeight: 300,
        value: key,
        style: const TextStyle(
          fontSize: 12,
        ),
        icon: const Icon(Icons.keyboard_arrow_down),
        items: songKeyList.map<DropdownMenuItem<String>>(
          (String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          },
        ).toList(),
        onChanged: (String? newValue) {
          ref.watch(songKeyProvider.state).state = newValue!;
        },
      ),
    );
  }
}
