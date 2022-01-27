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

  final CollectionReference teamsDataCollection = FirebaseFirestore.instance.collection('WCTeams');

  Stream<TeamData> teamData() {
    return teamsDataCollection.doc(teamID).snapshots().map(
      (DocumentSnapshot object) {
        Map<String, dynamic>? data = (object as DocumentSnapshot<Map<String, dynamic>>).data();

//TODO: change string to enum
        return TeamData(
          creatorID: data?[TeamDataEnum.creatorID.name] ?? '',
          teamID: data?[TeamDataEnum.teamID.name] ?? '',
          teamName: data?[TeamDataEnum.teamName.name] ?? '',
          isOpen: data?[TeamDataEnum.isOpen.name] ?? '',
        );
      },
    );
  }

  void toggleIsTeamOpen(bool currentStatus) async {
    EasyLoading.show();
    await teamsDataCollection.doc(teamID).update({
      TeamDataEnum.isOpen.name: !currentStatus,
    });

    EasyLoading.dismiss();
  }

  Future<void> leaveTeam(WCUserInfoData _userData) async {
    if (WCUtils().isAdminOrLeader(_userData)) {
      String error = 'Team leader and admins cannot leave team';
      WCUtils().wcShowError(error);
      return;
    }

    EasyLoading.show();

    try {
      //TODO: implement leave team

      WriteBatch _writeBatch = FirebaseFirestore.instance.batch();

      // update user data
      _writeBatch.update(WCUSerFirebaseAPI().wcUserDataCollection.doc(_userData.userID), {
        WCUserInfoDataEnum.teamID.name: '',
        WCUserInfoDataEnum.userStatusString.name: UserStatusEnum.noTeam.name,
      });

      _writeBatch.update(CreateJoinTeamFirebaseAPI().wcTeamDataCollection.doc(teamID).collection('data').doc('members'), {
        'normalMembers.${_userData.userID}': FieldValue.delete(),
      });

      await _writeBatch.commit();

      EasyLoading.dismiss();
    } catch (error) {
      WCUtils().wcShowError('Unable to leave team');
    }
  }
}
