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
      leading: AnimatedSwitcher(
        child: _customTileExpanded
            ? const Icon(
                Icons.remove_circle_outline,
                key: Key('1'),
              )
            : const Icon(
                Icons.add_circle_outline,
                key: Key('2'),
              ),
        duration: const Duration(milliseconds: 500),
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
      children: <Widget>[
        TextFormField(
          initialValue: '',
          minLines: 1,
          maxLines: 1,
          autocorrect: true,
          enableSuggestions: true,
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
