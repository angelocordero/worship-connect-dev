import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worship_connect/schedules/utils/schedules_providers_definition.dart';
import 'package:worship_connect/settings/utils/settings_providers_definition.dart';
import 'package:worship_connect/wc_core/worship_connect_utilities.dart';

class AddInstrumentsCard extends ConsumerWidget {
  const AddInstrumentsCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<String> _instrumentsList = ref.watch(scheduleMusiciansProvider.notifier).addInstrumentsList([
      ...ref.watch(instrumentsListProvider)['coreInstruments'] ?? [],
      ...ref.watch(instrumentsListProvider)['customInstruments'] ?? [],
    ]);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Hero(
          tag: 'instruments',
          child: Material(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                      child: Text(
                        'Add Instrument',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: WCUtils.screenHeightSafeArea(context) / 3,
                      child: ListView.builder(
                        itemCount: _instrumentsList.length + 1,
                        itemBuilder: (context, index) {
                          if (index < _instrumentsList.length) {
                            return _buildInstumentsListTile(_instrumentsList, index, ref);
                          } else {
                            return ListTile(
                              leading: const Icon(Icons.add_circle_outline),
                              title: const Text('Add Custom Instrument'),
                              onTap: () {},
                            );
                          }
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            String _instrument = ref.read(selectedInstrumentsProvider);

                            if (_instrument.isNotEmpty) {
                              ref.read(scheduleMusiciansProvider.notifier).addInstrument(_instrument);
                              Navigator.pop(context);
                            } else {
                              WCUtils.wcShowError('No instrument selected');
                            }
                          },
                          child: const Text('Add'),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container _buildInstumentsListTile(List<String> _instrumentsList, int index, WidgetRef ref) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(width: 0.5),
        ),
      ),
      child: ListTile(
        title: Text(_instrumentsList[index]),
        onTap: () {
          ref.watch(selectedInstrumentsProvider.state).state = _instrumentsList[index];
        },
        selected: ref.watch(selectedInstrumentsProvider) == _instrumentsList[index],
      ),
    );
  }
}
