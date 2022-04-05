import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worship_connect/settings/widgets/change_user_name_card.dart';
import 'package:worship_connect/sign_in/utils/wc_user_info_data.dart';
import 'package:worship_connect/wc_core/wc_custom_route.dart';
import 'package:worship_connect/wc_core/worship_connect_utilities.dart';
import 'package:worship_connect/wc_core/core_providers_definition.dart';

class UserSettings extends ConsumerWidget {
  const UserSettings({Key? key}) : super(key: key);

  ListTile _userIDListTile(WCUserInfoData? _userData, BuildContext context) {
    String _userID = _userData?.userID ?? '';

    return ListTile(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(_userID),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Exit'),
                )
              ],
            );
          },
        );
      },
      title: Text(
        _userID,
        softWrap: false,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: const Text('User ID'),
      trailing: IconButton(
        icon: const Icon(Icons.copy),
        onPressed: () async {
          if (_userID.isEmpty) {
            WCUtils.wcShowError(wcError: 'Unable to copy User ID');
            return;
          }
          await FlutterClipboard.copy(_userID);
          WCUtils.wcShowSuccess('User ID copied to clipboard');
        },
      ),
    );
  }

  ListTile _userNameListTIle({required String userName, required BuildContext context}) {
    return ListTile(
      title: Text(userName),
      subtitle: const Text('User Name'),
      trailing: Hero(
        tag: 'userName',
        child: IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () {
            Navigator.push(
              context,
              WCCustomRoute(
                builder: (context) {
                  return ChangeUserNameCard(
                    userName: userName,
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    WCUserInfoData? _userData = ref.watch(wcUserInfoDataStream).asData?.value;

    return Card(
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Align(
              child: Text('User Settings'),
              alignment: Alignment.centerLeft,
            ),
            const Divider(),
            _userNameListTIle(
              userName: _userData?.userName ?? '',
              context: context,
            ),
            _userIDListTile(_userData, context),
          ],
        ),
      ),
    );
  }
}
