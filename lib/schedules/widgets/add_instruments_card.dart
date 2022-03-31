import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worship_connect/settings/utils/settings_providers_definition.dart';
import 'package:worship_connect/settings/utils/wc_team_data.dart';
import 'package:worship_connect/wc_core/worship_connect_utilities.dart';

class AddInstrumentsCard extends ConsumerWidget {
  const AddInstrumentsCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TeamData _teamData = ref.watch(wcTeamDataStream).asData?.value ?? TeamData.empty();

    List<String> _instrumentsList = [
      ..._teamData.coreInstruments,
      ..._teamData.customInstruments,
    ];

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
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          'Add Instruments',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: WCUtils.screenHeightSafeArea(context) / 2,
                        child: ListView.builder(
                          itemCount: _instrumentsList.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(_instrumentsList[index]),
                            );
                          },
                        ),
                      ),
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
}
