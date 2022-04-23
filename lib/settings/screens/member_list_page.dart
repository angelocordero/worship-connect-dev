import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worship_connect/settings/utils/settings_providers_definition.dart';
import 'package:worship_connect/settings/widgets/member_list_tile.dart';
import 'package:worship_connect/sign_in/utils/wc_user_info_data.dart';
import 'package:worship_connect/wc_core/worship_connect_constants.dart';

class MembersListPage extends ConsumerWidget {
  const MembersListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void _resetMemberList() async {
      await ref.read(membersListProvider.notifier).reset();
    }

    final _membersListNotifier = ref.watch(membersListProvider.notifier);
    final List<WCUserInfoData> _adminList = ref.watch(membersListProvider).values.where(
      (element) {
        return element.userStatus == UserStatusEnum.admin;
      },
    ).toList();

    final List<WCUserInfoData> _membersList = ref.watch(membersListProvider).values.where(
      (element) {
        return element.userStatus == UserStatusEnum.member;
      },
    ).toList();

    _adminList.sort(
      (a, b) {
        return a.userName.compareTo(b.userName);
      },
    );
    _membersList.sort(
      (a, b) {
        return a.userName.compareTo(b.userName);
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Members',
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await _membersListNotifier.reset();
        },
        child: ListView(
          children: [
            MemberListTile(
              reset: _resetMemberList,
              memberData: ref.watch(membersListProvider).values.firstWhere(
                (element) {
                  return element.userStatus == UserStatusEnum.leader;
                },
                orElse: () {
                  return WCUserInfoData.empty();
                },
              ),
            ),
            ..._adminList.map(
              (admin) {
                return MemberListTile(
                  reset: _resetMemberList,
                  memberData: admin,
                );
              },
            ),
            ..._membersList.map(
              (member) {
                return MemberListTile(
                  reset: _resetMemberList,
                  memberData: member,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
