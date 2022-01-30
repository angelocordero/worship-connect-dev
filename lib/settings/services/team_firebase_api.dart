import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:worship_connect/settings/data_classes/wc_team_data.dart';
import 'package:worship_connect/sign_in/data_classes/wc_user_info_data.dart';
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
  }

  Future<void> changeTeamName(String newTeamName) async {
    EasyLoading.show();

    await teamsDataCollection.doc(teamID).update({TeamDataEnum.teamName.name: newTeamName});

    EasyLoading.dismiss();
  }

  Future<void> toggleIsTeamOpen(bool currentStatus) async {
    EasyLoading.show();
    await teamsDataCollection.doc(teamID).update({
      TeamDataEnum.isOpen.name: !currentStatus,
    });

    EasyLoading.dismiss();
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
    } catch (error) {
      WCUtils().wcShowError('Unable to leave team');
    }
  }

  Future<DocumentSnapshot> getMembersDocument() async {
    return await teamsDataCollection.doc(teamID).collection('data').doc('members').get();
  }

  Future<void> promoteToAdmin(WCUserInfoData _memberData) async {

    EasyLoading.show();
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
  }

  Future<void> promoteToLeader({required WCUserInfoData userData, required WCUserInfoData memberData}) async {
    
    EasyLoading.show();
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
  }

  Future<void> demoteToMember(WCUserInfoData _memberData) async {

    EasyLoading.show();
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
  }

  Future<void> removeFromTeam(WCUserInfoData _memberData) async {
    await leaveTeam(_memberData);
  }
}
