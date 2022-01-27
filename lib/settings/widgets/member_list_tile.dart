import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worship_connect/settings/widgets/role_icon.dart';
import 'package:worship_connect/sign_in/data_classes/wc_user_info_data.dart';
import 'package:worship_connect/wc_core/worship_connect.dart';
import 'package:worship_connect/wc_core/worship_connect_utilities.dart';

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
            if (WCUtils().isAdminOrLeader(memberData)) RoleIcon(role: memberData.userStatus), //role icon
            if (WCUtils().isAdminOrLeader(_userData)) _popupMenuButton(), // popup menu
          ],
        ),
      ),
    );
  }

// TODO: implement buttons function
  PopupMenuButton<int> _popupMenuButton() {
    return PopupMenuButton<int>(
      onSelected: (item) {
        switch (item) {
          case 0:
            //promote to leader
            break;
          case 1:
            // promote to admin
            break;
          case 2:
            // demote to member
            break;
          case 4:
            // remove from team
            break;
          case 5:
            // become a
            break;
        }
      },
      itemBuilder: (BuildContext context) {
        return <PopupMenuEntry<int>>[

//TOOD: change visibility if the function can be done or not

          const PopupMenuItem<int>(
            value: 0,
            child: Text('Promote to Leader'),
          ),
          const PopupMenuItem<int>(
            value: 1,
            child: Text('Promote to Admin'),
          ),
          const PopupMenuItem<int>(
            value: 2,
            child: Text('Demote to Member'),
          ),
          const PopupMenuItem<int>(
            value: 3,
            child: Text('Remove from team'),
          ),
          const PopupMenuItem<int>(
            value: 4,
            child: Text('Demote urself to member'),
          ),
        ];
      },
    );
  }
}
