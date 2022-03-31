import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worship_connect/schedules/utils/schedules_providers_definition.dart';

class InstrumentsTile extends ConsumerWidget {
  const InstrumentsTile({Key? key, required this.instrument}) : super(key: key);

  final Map<String, dynamic> instrument;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List _musicians = instrument.values.first;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _buildHeader(ref),
        if (_musicians.isNotEmpty)
          ..._musicians.map(
            (element) {
              return _buildMusicianTile(context, ref, element);
            },
          ),
        if (_musicians.isEmpty)
          const Align(
            child: Text('No musician for this instrument'),
          ),
        _buildAddButton(context, ref),
      ],
    );
  }

  SizedBox _buildAddButton(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 2 / 3,
      child: ListTile(
        leading: const Icon(Icons.add_circle_outline),
        title: const Text('Add'),
        onTap: () {
          ref.read(scheduleMusiciansProvider.notifier).addMusician(instrument: instrument.keys.first, musician: 'Angelo Test');
        },
      ),
    );
  }

  ListTile _buildHeader(WidgetRef ref) {
    return ListTile(
      trailing: IconButton(
        onPressed: () {
          ref.read(scheduleMusiciansProvider.notifier).removeInstruments(instrument.keys.first);
        },
        icon: const Icon(Icons.delete),
      ),
      title: Text(instrument.keys.first),
    );
  }

  SizedBox _buildMusicianTile(BuildContext context, WidgetRef ref, dynamic element) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 2 / 3,
      child: ListTile(
        trailing: IconButton(
          onPressed: () {
            ref.read(scheduleMusiciansProvider.notifier).removeMusician(instrument: instrument.keys.first, musician: element.toString());
          },
          icon: const Icon(Icons.delete),
        ),
        title: Text(element.toString()),
      ),
    );
  }
}
