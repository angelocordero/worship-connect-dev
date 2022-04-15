import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worship_connect/settings/widgets/change_user_name_card.dart';
import 'package:worship_connect/sign_in/utils/wc_user_info_data.dart';
import 'package:worship_connect/wc_core/core_providers_definition.dart';
import 'package:worship_connect/wc_core/worship_connect_utilities.dart';

class UserSettings extends ConsumerWidget {
  const UserSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    WCUserInfoData? _userData = ref.watch(wcUserInfoDataStream).asData?.value;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'User Settings',
              style: Theme.of(context).textTheme.subtitle1,
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

  ListTile _userIDListTile(WCUserInfoData? _userData, BuildContext context) {
    String _userID = _userData?.userID ?? '';

    return ListTile(
      onTap: () async {
        if (_userID.isEmpty) {
          WCUtils.wcShowError(wcError: 'Unable to copy User ID');
          return;
        }
        await FlutterClipboard.copy(_userID);
        WCUtils.wcShowSuccess('User ID copied to clipboard');
      },
      title: Text(
        _userID,
        softWrap: false,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: const Text('User ID'),
      trailing: const Icon(Icons.copy),
    );
  }

  ListTile _userNameListTIle({required String userName, required BuildContext context}) {
    return ListTile(
      title: Text(userName),
      subtitle: const Text('Username'),
      trailing: const Icon(Icons.edit_outlined),
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return ChangeUserNameCard(
              userName: userName,
            );
          },
        );
      },
    );
  }
}
