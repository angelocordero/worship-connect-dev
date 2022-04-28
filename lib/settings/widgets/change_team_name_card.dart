import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tap_debouncer/tap_debouncer.dart';
import 'package:worship_connect/settings/services/team_firebase_api.dart';
import 'package:worship_connect/wc_core/core_providers_definition.dart';

class ChangeTeamNameCard extends ConsumerWidget {
  const ChangeTeamNameCard({Key? key, required this.teamName}) : super(key: key);

  static String newName = '';

  final String teamName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String _teamID = ref.watch(wcUserInfoDataStream).asData!.value!.teamID;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Change Team Name',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                _nameTextField(context),
                _changeNameButtons(
                  context: context,
                  teamID: _teamID,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<dynamic> showCancelDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm cancel?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                FocusScope.of(context).unfocus();
                Navigator.pop(context);
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  _changeNameButtons({
    required BuildContext context,
    required String teamID,
  }) {
    return Row(
      children: [
        const Spacer(),
        TextButton(
          onPressed: () async {
            if (newName.isNotEmpty) {
              await showCancelDialog(context);
            } else {
              Navigator.pop(context);
            }
            newName = '';
          },
          child: const Text('Cancel'),
        ),
        TapDebouncer(
          builder: (BuildContext context, TapDebouncerFunc? onTap) {
            return TextButton(
              onPressed: onTap,
              child: const Text('Update'),
            );
          },
          onTap: () async {
            if (newName.isNotEmpty && newName.trim() != teamName) {
              await TeamFirebaseAPI(teamID).changeTeamName(newName.trim());
            }
            newName = '';
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  TextFormField _nameTextField(BuildContext context) {
    return TextFormField(
      style: Theme.of(context).textTheme.bodyText2,
      initialValue: teamName,
      onChanged: (value) {
        newName = value;
      },
      minLines: 1,
      maxLines: 1,
      decoration: const InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.all(12),
        hintText: 'Team name',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(12.0),
          ),
        ),
      ),
    );
  }
}
