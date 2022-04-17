import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tap_debouncer/tap_debouncer.dart';
import 'package:worship_connect/sign_in/utils/wc_user_info_data.dart';
import 'package:worship_connect/wc_core/wc_user_firebase_api.dart';
import 'package:worship_connect/wc_core/worship_connect_utilities.dart';
import 'package:worship_connect/wc_core/core_providers_definition.dart';

class ChangeUserNameCard extends ConsumerWidget {
  const ChangeUserNameCard({Key? key, required this.userName}) : super(key: key);

  static String newName = '';

  final String userName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    WCUserInfoData _userData = ref.watch(wcUserInfoDataStream).asData!.value!;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Material(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'Change username',
                  style: Theme.of(context).textTheme.headline6,
                ),
                const SizedBox(
                  height: 10,
                ),
                _nameTextField(context),
                _changeNameButtons(
                  context: context,
                  userData: _userData,
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

  SingleChildScrollView _changeNameButtons({
    required BuildContext context,
    required WCUserInfoData userData,
  }) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: (WCUtils.screenWidth(context) - 96) / 3,
          ),
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
              if (newName.isNotEmpty && newName.trim() != userName) {
                WCUSerFirebaseAPI().updateUserName(
                  userID: userData.userID,
                  userName: newName,
                  teamID: userData.teamID,
                  userStatus: userData.userStatus,
                );
              }
              newName = '';
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  TextFormField _nameTextField(BuildContext context) {
    return TextFormField(
      style: Theme.of(context).textTheme.bodyText2,
      initialValue: userName,
      onChanged: (value) {
        newName = value;
      },
      minLines: 1,
      maxLines: 1,
      decoration: const InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.all(12),
        hintText: 'User name',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(12.0),
          ),
        ),
      ),
    );
  }
}
