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
  const MemberListTile({Key? key, required this.memberData, required this.reset}) : super(key: key);

  static bool _showPopupButton = false;
  final WCUserInfoData memberData;
  final Function() reset;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final WCUserInfoData _userData = ref.watch(wcUserInfoDataStream).asData!.value!;
    Text _nameText = Text(memberData.userName);

    if (_userData.userStatus == UserStatusEnum.leader && memberData.userID != _userData.userID) {
      _showPopupButton = true;
    } else if (_userData.userStatus == UserStatusEnum.admin &&
        memberData.userStatus == UserStatusEnum.admin &&
        _userData.userID == memberData.userID) {
      _showPopupButton = true; // if the user is admin, it should show the popup to demote himself
    } else if (_userData.userStatus == UserStatusEnum.admin &&
        memberData.userStatus == UserStatusEnum.admin &&
        _userData.userID != memberData.userID) {
      _showPopupButton = false; // if the user is admin, it would not show the popup to fellow admins
    } else if (_userData.userStatus == UserStatusEnum.admin && memberData.userStatus == UserStatusEnum.member) {
      _showPopupButton = true;
    } else {
      _showPopupButton = false;
    }

    if (_userData.userID == memberData.userID) {
      _nameText = Text(
        memberData.userName,
        style: Theme.of(context).textTheme.subtitle1?.copyWith(fontStyle: FontStyle.italic),
      );
    }

    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 0.5),
        ),
      ),
      child: ListTile(
        title: _nameText,
        trailing: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (WCUtils.isAdminOrLeader(memberData)) RoleIcon(role: memberData.userStatus), //role icon
            Visibility(
              visible: _showPopupButton,
              replacement: const SizedBox(
                width: 46,
              ),
              child: _popupMenuButton(_userData, ref),
            ),
          ],
        ),
      ),
    );
  }

  PopupMenuButton<int> _popupMenuButton(WCUserInfoData _userData, WidgetRef ref) {
    UserStatusEnum _userStatus = _userData.userStatus;
    UserStatusEnum _memberStatus = memberData.userStatus;
    String _teamName = ref.watch(wcWCTeamDataStream).value?.teamName ?? '';

    bool _canPassLeader = _userStatus == UserStatusEnum.leader && _memberStatus == UserStatusEnum.admin && _userData.userID != memberData.userID;
    bool _canPromoteMemberToAdmin =
        _userStatus == UserStatusEnum.leader && _memberStatus == UserStatusEnum.member && _userData.userID != memberData.userID;
    bool _canDemoteAdminToMember =
        _userStatus == UserStatusEnum.leader && _memberStatus == UserStatusEnum.admin && _userData.userID != memberData.userID;
    bool _canRemoveFromTeam = WCUtils.isAdminOrLeader(_userData) && _memberStatus == UserStatusEnum.member && _userData.userID != memberData.userID;
    bool _canDemoteSelfToMember = _userStatus == UserStatusEnum.admin && _userData.userID == memberData.userID;

    return PopupMenuButton<int>(
      onSelected: (item) async {
        switch (item) {
          case 0:
            await TeamFirebaseAPI(_userData.teamID).promoteToLeader(userData: _userData, memberData: memberData, teamName: _teamName);
            reset();
            break;
          case 1:
            await TeamFirebaseAPI(_userData.teamID).promoteToAdmin(memberData, _userData.userName, _teamName);
            reset();
            break;
          case 2:
            await TeamFirebaseAPI(_userData.teamID).demoteToMember(memberData, _userData.userName, _teamName);
            reset();
            break;
          case 3:
            await TeamFirebaseAPI(_userData.teamID).removeFromTeam(memberData, _userData.userName, _teamName);
            reset();
            break;
          case 4:
            await TeamFirebaseAPI(_userData.teamID).demoteSelfToMember(memberData);
            reset();
            break;
          default:
            WCUtils.wcShowError(wcError: 'Error');
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
              child: Text('Demote self to Member'),
            ),
        ];
      },
    );
  }
}
