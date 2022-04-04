import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:worship_connect/settings/utils/wc_team_data.dart';
import 'package:worship_connect/sign_in/utils/wc_user_info_data.dart';
import 'package:worship_connect/wc_core/wc_user_firebase_api.dart';
import 'package:worship_connect/wc_core/worship_connect_constants.dart';
import 'package:worship_connect/wc_core/worship_connect_utilities.dart';
import 'package:worship_connect/welcome/services/create_join_team_firebase_api.dart';

class TeamFirebaseAPI {
  TeamFirebaseAPI(this.teamID);

  String teamID;

  final FirebaseFirestore _firebaseInstance = FirebaseFirestore.instance;

  late final CollectionReference teamsDataCollection = _firebaseInstance.collection('WCTeams');

  Stream<TeamData> teamData() {
    try {
      return teamsDataCollection.doc(teamID).snapshots().map(
        (DocumentSnapshot object) {
          Map<String, dynamic>? data = (object as DocumentSnapshot<Map<String, dynamic>>).data();

          return TeamData(
            creatorID: data?[TeamDataEnum.creatorID.name] ?? '',
            teamID: data?[TeamDataEnum.teamID.name] ?? '',
            teamName: data?[TeamDataEnum.teamName.name] ?? '',
            isOpen: data?[TeamDataEnum.isOpen.name] ?? '',
          );
        },
      );
    } catch (e) {
      debugPrint(e.toString());
      return const Stream.empty();
    }
  }

  Future<void> changeTeamName(String newTeamName) async {
    EasyLoading.show();

    try {
      await teamsDataCollection.doc(teamID).update({TeamDataEnum.teamName.name: newTeamName});
      EasyLoading.dismiss();
    } catch (e, st) {
      WCUtils.wcShowError(e: e, st: st, wcError: 'Change name failed');
    }
  }

  Future<void> toggleIsTeamOpen(bool currentStatus) async {
    EasyLoading.show();

    try {
      await teamsDataCollection.doc(teamID).update({
        TeamDataEnum.isOpen.name: !currentStatus,
      });
      EasyLoading.dismiss();
    } catch (e, st) {
      WCUtils.wcShowError(e: e, st: st, wcError: e.toString());
    }
  }

  Future<void> leaveTeam(WCUserInfoData _userData) async {
    EasyLoading.show();

    try {
      WriteBatch _writeBatch = FirebaseFirestore.instance.batch();

      // update user data
      _writeBatch.update(WCUSerFirebaseAPI().wcUserDataCollection.doc(_userData.userID), {
        WCUserInfoDataEnum.teamID.name: '',
        WCUserInfoDataEnum.userStatusString.name: UserStatusEnum.noTeam.name,
      });

      // update team members list
      _writeBatch.update(CreateJoinTeamFirebaseAPI().wcTeamDataCollection.doc(teamID).collection('data').doc('members'), {
        'normalMembers.${_userData.userID}': FieldValue.delete(),
      });

      await _writeBatch.commit();

      EasyLoading.dismiss();
    } catch (e, st) {
      WCUtils.wcShowError(e: e, st: st, wcError: 'Unable to leave team');
    }
  }

  Future<DocumentSnapshot> getMembersDocument() async {
    try {
      return await teamsDataCollection.doc(teamID).collection('data').doc('members').get();
    } catch (e, st) {
      WCUtils.wcShowError(e: e, st: st, wcError: 'Failed to get members list');
      return Future.error(e.toString());
    }
  }

  Future<DocumentSnapshot> getInstrumentsDocument() async {
    try {
      return await teamsDataCollection.doc(teamID).collection('data').doc('instruments').get();
    } catch (e, st) {
      debugPrint(e.toString());
      WCUtils.wcShowError(e: e, st: st, wcError: 'Failed to get instruments list');
      return Future.error(e.toString());
    }
  }

  Future<void> promoteToAdmin(WCUserInfoData _memberData) async {
    EasyLoading.show();

    try {
      WriteBatch _writeBatch = _firebaseInstance.batch();

      _writeBatch.update(WCUSerFirebaseAPI().wcUserDataCollection.doc(_memberData.userID), {
        WCUserInfoDataEnum.userStatusString.name: UserStatusEnum.admin.name,
      });

      _writeBatch.update(teamsDataCollection.doc(teamID).collection('data').doc('members'), {
        'normalMembers.${_memberData.userID}': FieldValue.delete(),
        'admins.${_memberData.userID}': _memberData.userName,
      });

      await _writeBatch.commit();
      EasyLoading.dismiss();
    } catch (e, st) {
      WCUtils.wcShowError(e: e, st: st, wcError: 'Failed to promote');
    }
  }

  Future<void> promoteToLeader({required WCUserInfoData userData, required WCUserInfoData memberData}) async {
    EasyLoading.show();

    try {
      WriteBatch _writeBatch = _firebaseInstance.batch();

      _writeBatch.update(WCUSerFirebaseAPI().wcUserDataCollection.doc(userData.userID), {
        WCUserInfoDataEnum.userStatusString.name: UserStatusEnum.admin.name,
      });

      _writeBatch.update(WCUSerFirebaseAPI().wcUserDataCollection.doc(memberData.userID), {
        WCUserInfoDataEnum.userStatusString.name: UserStatusEnum.leader.name,
      });

      _writeBatch.update(teamsDataCollection.doc(teamID).collection('data').doc('members'), {
        'leader.${memberData.userID}': memberData.userName,
        'leader.${userData.userID}': FieldValue.delete(),
        'admins.${memberData.userID}': FieldValue.delete(),
        'admins.${userData.userID}': userData.userName,
      });

      await _writeBatch.commit();
      EasyLoading.dismiss();
    } catch (e, st) {
      WCUtils.wcShowError(e: e, st: st, wcError: 'Failed to promote');
    }
  }

  Future<void> demoteToMember(WCUserInfoData _memberData) async {
    EasyLoading.show();

    try {
      WriteBatch _writeBatch = _firebaseInstance.batch();

      _writeBatch.update(WCUSerFirebaseAPI().wcUserDataCollection.doc(_memberData.userID), {
        WCUserInfoDataEnum.userStatusString.name: UserStatusEnum.member.name,
      });

      _writeBatch.update(teamsDataCollection.doc(teamID).collection('data').doc('members'), {
        'admins.${_memberData.userID}': FieldValue.delete(),
        'normalMembers.${_memberData.userID}': _memberData.userName,
      });

      await _writeBatch.commit();
      EasyLoading.dismiss();
    } catch (e, st) {
      WCUtils.wcShowError(e: e, st: st, wcError: 'Failed to demote');
    }
  }

  Future<void> removeFromTeam(WCUserInfoData _memberData) async {
    await leaveTeam(_memberData);
  }

  Future getCompleteMembersNamesList() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> _doc = await teamsDataCollection.doc(teamID).collection('data').doc('members').get();

      Map<String, dynamic> _admins = _doc.data()!['admins'] ?? {};
      Map<String, dynamic> _members = _doc.data()?['normalMembers'] ?? {};
      Map<String, dynamic> _leader = _doc.data()?['leader'];

      List<String> _list = [
        _leader.values.first,
        ..._admins.values,
        ..._members.values,
      ];

      return _list;
    } catch (e, st) {
      WCUtils.wcShowError(e: e, st: st, wcError: 'Failed to get members list');
    }
  }

  Future addCustomInstrument(String instrument) async {
    EasyLoading.show();

    try {
      teamsDataCollection.doc(teamID).collection('data').doc('instruments').update({
        'customInstruments': FieldValue.arrayUnion([instrument]),
      });

      await EasyLoading.dismiss();
    } catch (e, st) {
      WCUtils.wcShowError(e: e, st: st, wcError: 'Failed to add custom instrument');
    }
  }

  Future deleteCustomInstrument(String instrument) async {
    EasyLoading.show();

    try {
      teamsDataCollection.doc(teamID).collection('data').doc('instruments').update({
        'customInstruments': FieldValue.arrayRemove([instrument]),
      });

      await EasyLoading.dismiss();
    } catch (e, st) {
      WCUtils.wcShowError(e: e, st: st, wcError: 'Failed to remove custom instrument');
    }
  }
}
