import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeleton_loader/skeleton_loader.dart';
import 'package:worship_connect/settings/utils/settings_providers_definition.dart';
import 'package:worship_connect/settings/widgets/member_list_tile.dart';
import 'package:worship_connect/settings/widgets/role_icon.dart';
import 'package:worship_connect/sign_in/utils/wc_user_info_data.dart';
import 'package:worship_connect/wc_core/worship_connect_constants.dart';
import 'package:worship_connect/wc_core/worship_connect_utilities.dart';

class MembersListPage extends ConsumerWidget {
  const MembersListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void _resetMemberList() async {
      await ref.read(membersListProvider.notifier).reset();
    }

    final _membersListNotifier = ref.watch(membersListProvider.notifier);
    ref.watch(membersListProvider);

    //gets admins list and sort alphabetically
    final List<WCUserInfoData> _adminList = ref.watch(membersListProvider).values.where(
      (element) {
        return element.userStatus == UserStatusEnum.admin;
      },
    ).toList();
    _adminList.sort(
      (a, b) {
        return a.userName.compareTo(b.userName);
      },
    );

    //gets members list and sort alphabetically
    final List<WCUserInfoData> _membersList = ref.watch(membersListProvider).values.where(
      (element) {
        return element.userStatus == UserStatusEnum.member;
      },
    ).toList();
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
      body: Visibility(
        replacement: _skeletonLoader(context),
        visible: !_membersListNotifier.isLoading,
        child: RefreshIndicator(
          onRefresh: () async {
            _membersListNotifier.reset();
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
      ),
    );
  }

  SkeletonLoader _skeletonLoader(BuildContext context) {
    return SkeletonLoader(
      builder: Container(
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 0.5),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        height: 56,
        width: WCUtils.screenWidth(context),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 5,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade700,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(4),
                  ),
                ),
                height: 20,
              ),
            ),
            const SizedBox(
              width: 50,
            ),
            const RoleIcon(
              role: UserStatusEnum.admin,
            ),
            const IconButton(
              onPressed: null,
              icon: Icon(Icons.more_vert),
            ),
          ],
        ),
      ),
      items: 10,
      highlightColor: wcAccentColor,
      baseColor: Colors.grey.shade700,
    );
  }
}
