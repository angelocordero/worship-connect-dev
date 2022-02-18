import 'package:flutter/material.dart';

class SongKeyDropdown extends StatelessWidget {
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
  Widget build(BuildContext context) {
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
        value: songKeyList.first,
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
        onChanged: (String? newValue) {},
      ),
    );
  }
}
