import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worship_connect/schedules/utils/schedules_providers_definition.dart';
import 'package:worship_connect/schedules/widgets/add_custom_instrument_expansion_tile.dart';
import 'package:worship_connect/settings/utils/settings_providers_definition.dart';
import 'package:worship_connect/wc_core/worship_connect_constants.dart';
import 'package:worship_connect/wc_core/worship_connect_utilities.dart';

class AddInstrumentsCard extends ConsumerWidget {
  const AddInstrumentsCard({Key? key}) : super(key: key);

  static final ScrollController _scrollController = ScrollController();
  static List<String> _instrumentsList = [];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _instrumentsList = ref.watch(scheduleMusiciansProvider.notifier).addInstrumentsList([
      ...wcCoreInstruments,
      ...ref.watch(customInstrumentsListProvider) ?? [],
    ]);

    return SafeArea(
      child: SingleChildScrollView(
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
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                        child: Text(
                          'Add Instrument',
                          style: Theme.of(context).textTheme.headline6?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      _buildInstrumentList(context, ref),
                      _buildButtons(context, ref),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  SizedBox _buildInstrumentList(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: WCUtils.screenHeightSafeArea(context) / 3,
      child: Scrollbar(
        isAlwaysShown: true,
        controller: _scrollController,
        child: ListView.builder(
          controller: _scrollController,
          itemCount: _instrumentsList.length + 1,
          itemBuilder: (context, index) {
            if (index < _instrumentsList.length) {
              return _buildInstumentsListTile(ref, _instrumentsList[index]);
            } else {
              return AddCustomInstrumentExpansionTile(
                scrollToBottom: scrollToBottom,
              );
            }
          },
        ),
      ),
    );
  }

  Row _buildButtons(BuildContext context, WidgetRef ref) {
    return Row(
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
            String _selectedInstrument = ref.read(selectedInstrumentsProvider);
            String _customInstrument = ref.read(customInstrumentProvider);

            if (_selectedInstrument.isEmpty && _customInstrument.isEmpty) {
              WCUtils.wcShowError(wcError: 'No instrument selected');
              return;
            }

            if (wcCoreInstruments.contains(_selectedInstrument)) {
              ref.read(scheduleMusiciansProvider.notifier).addInstrument(_selectedInstrument);
            } else {
              ref.read(scheduleMusiciansProvider.notifier).addCustomInstrument(_customInstrument);
            }

            Navigator.pop(context);
          },
          child: const Text('Add'),
        ),
      ],
    );
  }

  void scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 100),
      curve: Curves.linear,
    );
  }

  Container _buildInstumentsListTile(WidgetRef ref, String _instrument) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(width: 1),
        ),
      ),
      child: ListTile(
        title: Text(_instrument),
        trailing: Visibility(
          visible: !wcCoreInstruments.contains(_instrument),
          child: IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () async {
              await ref.read(scheduleMusiciansProvider.notifier).deleteCustomInstrument(_instrument);
              await ref.read(customInstrumentsListProvider.notifier).init();
            },
          ),
        ),
        onTap: () {
          ref.watch(selectedInstrumentsProvider.state).state = _instrument;
        },
        selected: ref.watch(selectedInstrumentsProvider) == _instrument,
      ),
    );
  }
}
