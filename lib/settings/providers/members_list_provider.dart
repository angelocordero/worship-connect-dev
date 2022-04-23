import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worship_connect/settings/services/team_firebase_api.dart';
import 'package:worship_connect/sign_in/utils/wc_user_info_data.dart';
import 'package:worship_connect/wc_core/worship_connect_constants.dart';

class MembersListProvider extends StateNotifier<Map<String, WCUserInfoData>> {
  MembersListProvider({required this.teamID}) : super({});

  final String teamID;

  static WCUserInfoData _leader = WCUserInfoData.empty();

  Future<DocumentSnapshot> _getMembersDoc() async {
    return await TeamFirebaseAPI(teamID).getMembersDocument();
  }

  Future<void> reset() async {
    state.clear();
    await init();
  }

  Future<void> init() async {
    EasyLoading.show();


    DocumentSnapshot<Map<String, dynamic>> _doc = await _getMembersDoc() as DocumentSnapshot<Map<String, dynamic>>;

    _setMembers(_doc.data()?['members']);
    _setAdmins(_doc.data()?['admin']);
    _setLeader(_doc.data()!['leader']);

    EasyLoading.dismiss();
  }

  void _setMembers(Map<String, dynamic>? _map) {
    try {
      _map?.forEach(
        (key, value) {
          WCUserInfoData _member =
              WCUserInfoData(userID: key, userName: value, userStatusString: UserStatusEnum.member.name, teamID: teamID, fcmToken: '');

          state[_member.userID] = _member;
        },
      );

      state = Map<String, WCUserInfoData>.from(state);
    } catch (e) {
      // return empty list
    }
  }

  void _setAdmins(Map<String, dynamic>? _map) {
    try {
      _map?.forEach(
        (key, value) {
          WCUserInfoData _admin =
              WCUserInfoData(userID: key, userName: value, userStatusString: UserStatusEnum.admin.name, teamID: teamID, fcmToken: '');

          state[_admin.userID] = _admin;
        },
      );

      state = Map<String, WCUserInfoData>.from(state);
    } catch (e) {
      // return empty list
    }
  }

  _setLeader(Map<String, dynamic> _map) {
    _leader = WCUserInfoData(
        userID: _map.keys.first, userName: _map.values.first, userStatusString: UserStatusEnum.leader.name, teamID: teamID, fcmToken: '');

    state[_leader.userID] = _leader;

    state = Map<String, WCUserInfoData>.from(state);
  }
}
