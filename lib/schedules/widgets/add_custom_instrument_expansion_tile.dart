import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worship_connect/schedules/utils/schedules_providers_definition.dart';

class AddCustomInstrumentExpansionTile extends ConsumerStatefulWidget {
  const AddCustomInstrumentExpansionTile({Key? key, required this.scrollToBottom}) : super(key: key);

  final Function() scrollToBottom;

  @override
  ConsumerState<AddCustomInstrumentExpansionTile> createState() => AddCustomInstrumentExpansionTileState();
}

class AddCustomInstrumentExpansionTileState extends ConsumerState<AddCustomInstrumentExpansionTile> {
  bool _customTileExpanded = false;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      controlAffinity: ListTileControlAffinity.leading,
      title: const Text('Add Custom Instrument'),
      leading: Icon(
        _customTileExpanded ? Icons.remove_circle_outline : Icons.add_circle_outline,
      ),
      children: <Widget>[
        TextFormField(
          initialValue: '',
          minLines: 1,
          maxLines: 1,
          autocorrect: true,
          enableSuggestions: true,
          cursorColor: Colors.black,
          decoration: const InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.all(12),
            hintText: 'Instrument name',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(12.0),
              ),
            ),
          ),
          onChanged: (input) {
            ref.read(customInstrumentProvider.state).state = input;
          },
        ),
      ],
      onExpansionChanged: (bool expanded) async {
        ref.read(selectedInstrumentsProvider.state).state = '';

        setState(
          () {
            _customTileExpanded = expanded;
          },
        );

        await Future.delayed(const Duration(milliseconds: 250));

        if (expanded) {
          widget.scrollToBottom();
        }
      },
    );
  }
}
