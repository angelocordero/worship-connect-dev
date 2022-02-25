import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worship_connect/settings/services/team_firebase_api.dart';
import 'package:worship_connect/settings/widgets/member_list_tile.dart';
import 'package:worship_connect/sign_in/utils/wc_user_info_data.dart';
import 'package:worship_connect/wc_core/worship_connect_constants.dart';

class MembersListProvider extends StateNotifier {
  MembersListProvider({required this.teamID}) : super(null);

  final String teamID;

  static final List<WCUserInfoData> _normalMembersList = [];
  static final List<WCUserInfoData> _adminsList = [];
  static WCUserInfoData _leader = WCUserInfoData.empty();

  Future<DocumentSnapshot> _getMembersDoc() async {
    return await TeamFirebaseAPI(teamID).getMembersDocument();
  }

  void _resetMemberList() {
    _normalMembersList.clear();
    _adminsList.clear();
  }

  Future<void> initMemberList() async {
    EasyLoading.show();

    _resetMemberList();

    DocumentSnapshot<Map<String, dynamic>> _doc = await _getMembersDoc() as DocumentSnapshot<Map<String, dynamic>>;

    _setNormalMembers(_doc.data()?['normalMembers']);
    _setAdmins(_doc.data()?['admins']);
    _setLeader(_doc.data()!['leader']);

    // sort lists
    _normalMembersList.sort((a, b) {
      return a.userName.compareTo(b.userName);
    });
    _adminsList.sort((a, b) {
      return a.userName.compareTo(b.userName);
    });

    EasyLoading.dismiss();
  }

  void _setNormalMembers(Map<String, dynamic>? _map) {
    try {
      _map?.forEach(
        (key, value) {
          _normalMembersList.add(
            WCUserInfoData(
              userID: key,
              userName: value,
              userStatusString: UserStatusEnum.member.name,
              teamID: teamID,
            ),
          );
        },
      );
    } catch (e) {
      // return empty list
    }
  }

  void _setAdmins(Map<String, dynamic>? _map) {
    try {
      _map?.forEach(
        (key, value) {
          _adminsList.add(
            WCUserInfoData(
              userID: key,
              userName: value,
              userStatusString: UserStatusEnum.admin.name,
              teamID: teamID,
            ),
          );
        },
      );
    } catch (e) {
      // return empty list
    }
  }

  _setLeader(Map<String, dynamic> _map) {
    _leader = WCUserInfoData(
      userID: _map.keys.first,
      userName: _map.values.first,
      userStatusString: UserStatusEnum.leader.name,
      teamID: teamID,
    );
  }

  List<MemberListTile> getNormalMembers() {
    List<MemberListTile> _normalMemberListTiles = [];

    for (var element in _normalMembersList) {
      _normalMemberListTiles.add(MemberListTile(memberData: element));
    }

    return _normalMemberListTiles;
  }

  List<MemberListTile> getAdmins() {
    List<MemberListTile> _adminsListTiles = [];

    for (var element in _adminsList) {
      _adminsListTiles.add(MemberListTile(memberData: element));
    }

    return _adminsListTiles;
  }

  MemberListTile getLeader() {
    return MemberListTile(memberData: _leader);
  }
}
