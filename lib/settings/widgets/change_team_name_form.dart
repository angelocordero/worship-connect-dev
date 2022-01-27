import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tap_debouncer/tap_debouncer.dart';
import 'package:worship_connect/settings/services/team_firebase_api.dart';
import 'package:worship_connect/wc_core/worship_connect.dart';
import 'package:worship_connect/wc_core/worship_connect_utilities.dart';

class ChangeTeamNameForm extends ConsumerWidget {
  const ChangeTeamNameForm({Key? key, required this.teamName}) : super(key: key);

  final String teamName;

  static final TextEditingController _changeNameController = TextEditingController();

  TextFormField _nameTextField() {
    _changeNameController.text = teamName;
    _changeNameController.selection = TextSelection.fromPosition(
      TextPosition(offset: teamName.length),
    );

    return TextFormField(
      controller: _changeNameController,
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

  SingleChildScrollView _changeNameButtons({
    required BuildContext context,
    required String teamID,
  }) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: (WCUtils().screenWidth(context)! - 96) / 3,
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
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
              if (_changeNameController.text.isEmpty) {
                WCUtils().wcShowError('Team name cannot be empty');
                return;
              }
              if (_changeNameController.text.trim() == teamName) {
                Navigator.pop(context);
                return;
              }

              await TeamFirebaseAPI(teamID).changeTeamName(_changeNameController.text.trim());
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String _teamID = ref.watch(wcUserInfoDataStream).asData!.value!.teamID;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Hero(
          tag: 'changeName',
          child: Material(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Text(
                    'Change name',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  _nameTextField(),
                  _changeNameButtons(
                    context: context,
                    teamID: _teamID,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
