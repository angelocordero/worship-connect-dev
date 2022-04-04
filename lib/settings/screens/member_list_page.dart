import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:worship_connect/settings/utils/settings_providers_definition.dart';
import 'package:worship_connect/settings/widgets/member_list_tile.dart';
import 'package:worship_connect/sign_in/utils/wc_user_info_data.dart';
import 'package:worship_connect/wc_core/worship_connect_constants.dart';

class MembersListPage extends ConsumerWidget {
  const MembersListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _membersListNotifier = ref.watch(membersListProvider.notifier);
    final List<WCUserInfoData> _adminsList = ref.watch(membersListProvider).values.where(
      (element) {
        return element.userStatus == UserStatusEnum.admin;
      },
    ).toList();

    final List<WCUserInfoData> _membersList = ref.watch(membersListProvider).values.where(
      (element) {
        return element.userStatus == UserStatusEnum.member;
      },
    ).toList();

    _adminsList.sort((a, b) {
      return a.userName.compareTo(b.userName);
    });
    _membersList.sort((a, b) {
      return a.userName.compareTo(b.userName);
    });


    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Members',
            style: GoogleFonts.exo2(),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            await _membersListNotifier.reset();
          },
          child: ListView(
            children: [
              MemberListTile(
                memberData: ref.watch(membersListProvider).values.firstWhere(
                  (element) {
                    return element.userStatus == UserStatusEnum.leader;
                  },
                ),
              ),
              ..._adminsList.map(
                (admin) {
                  return MemberListTile(memberData: admin);
                },
              ),
              ..._membersList.map(
                (member) {
                  return MemberListTile(memberData: member);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
