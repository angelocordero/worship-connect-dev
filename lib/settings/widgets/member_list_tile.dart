import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worship_connect/settings/services/team_firebase_api.dart';
import 'package:worship_connect/settings/utils/settings_providers_definition.dart';
import 'package:worship_connect/settings/widgets/role_icon.dart';
import 'package:worship_connect/sign_in/utils/wc_user_info_data.dart';
import 'package:worship_connect/wc_core/worship_connect_constants.dart';
import 'package:worship_connect/wc_core/worship_connect_utilities.dart';
import 'package:worship_connect/wc_core/core_providers_definition.dart';


class MemberListTile extends ConsumerWidget {
  const MemberListTile({Key? key, required this.memberData}) : super(key: key);

  final WCUserInfoData memberData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final WCUserInfoData _userData = ref.watch(wcUserInfoDataStream).asData!.value!;

    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(),
        ),
      ),
      child: ListTile(
        title: Text(memberData.userName),
        trailing: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (WCUtils.isAdminOrLeader(memberData)) RoleIcon(role: memberData.userStatus), //role icon
            Visibility(
              visible: WCUtils.isAdminOrLeader(_userData) && _userData.userID != memberData.userID,
              replacement: const SizedBox(
                width: 46,
              ),
              child: _popupMenuButton(_userData, ref),
            ), // popup menu
          ],
        ),
      ),
    );
  }

  PopupMenuButton<int> _popupMenuButton(WCUserInfoData _userData, WidgetRef ref) {
    UserStatusEnum _userStatus = _userData.userStatus;
    UserStatusEnum _memberStatus = memberData.userStatus;

    bool _canPassLeader = _userStatus == UserStatusEnum.leader && _memberStatus == UserStatusEnum.admin;
    bool _canPromoteMemberToAdmin = _userStatus == UserStatusEnum.leader && _memberStatus == UserStatusEnum.member;
    bool _canDemoteAdminToMember = _userStatus == UserStatusEnum.leader && _memberStatus == UserStatusEnum.admin;
    bool _canRemoveFromTeam = WCUtils.isAdminOrLeader(_userData) && _memberStatus == UserStatusEnum.member;
    bool _canDemoteSelfToMember = _userStatus == UserStatusEnum.admin;

    return PopupMenuButton<int>(
      onSelected: (item) async {
        switch (item) {
          case 0:
            await TeamFirebaseAPI(_userData.teamID).promoteToLeader(
              userData: _userData,
              memberData: memberData,
            );
            ref.read(membersListProvider.notifier).reset();
            break;
          case 1:
            await TeamFirebaseAPI(_userData.teamID).promoteToAdmin(memberData);
            ref.read(membersListProvider.notifier).reset();
            break;
          case 2:
            await TeamFirebaseAPI(_userData.teamID).demoteToMember(memberData);
            ref.read(membersListProvider.notifier).reset();
            break;
          case 3:
            await TeamFirebaseAPI(_userData.teamID).removeFromTeam(memberData);
            ref.read(membersListProvider.notifier).reset();
            break;
          case 4:
            await TeamFirebaseAPI(_userData.teamID).demoteToMember(memberData);
            ref.read(membersListProvider.notifier).reset();
            break;
          default:
            WCUtils.wcShowError('Error');
            break;
        }
      },
      itemBuilder: (BuildContext context) {
        return <PopupMenuEntry<int>>[
          if (_canPassLeader)
            const PopupMenuItem<int>(
              value: 0,
              child: Text('Promote to Leader'),
            ),
          if (_canPromoteMemberToAdmin)
            const PopupMenuItem<int>(
              value: 1,
              child: Text('Promote to Admin'),
            ),
          if (_canDemoteAdminToMember)
            const PopupMenuItem<int>(
              value: 2,
              child: Text('Demote to Member'),
            ),
          if (_canRemoveFromTeam)
            const PopupMenuItem<int>(
              value: 3,
              child: Text('Remove from team'),
            ),
          if (_canDemoteSelfToMember)
            const PopupMenuItem<int>(
              value: 4,
              child: Text('Demote to Member'),
            ),
        ];
      },
    );
  }
}
