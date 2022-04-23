import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:worship_connect/announcements/utils/announcements_data.dart';
import 'package:worship_connect/settings/utils/wc_team_data.dart';
import 'package:worship_connect/sign_in/utils/wc_user_info_data.dart';
import 'package:worship_connect/wc_core/wc_user_firebase_api.dart';
import 'package:worship_connect/wc_core/worship_connect_constants.dart';
import 'package:worship_connect/wc_core/worship_connect_utilities.dart';

class CreateJoinTeamFirebaseAPI {
  final FirebaseFirestore _firebaseInstance = FirebaseFirestore.instance;
  late final CollectionReference wcWCTeamDataCollection = _firebaseInstance.collection('WCTeams');

  Future createTeam({required String teamName, required String creatorID, required String creatorName, required String fcmToken}) async {
    try {
      if (creatorName.isEmpty) {
        EasyLoading.showError('User name cannot be empty');
        return;
      }

      if (teamName.isEmpty) {
        EasyLoading.showError('Team name cannot be empty');
        return;
      }

      EasyLoading.show();

      String _teamID = WCUtils.generateTeamID();
      String createdDay = WCUtils.dateToString(DateTime.now());

      WriteBatch _writeBatch = _firebaseInstance.batch();

      //set team info
      _writeBatch.set(wcWCTeamDataCollection.doc(_teamID), {
        WCTeamDataEnum.teamName.name: teamName,
        WCTeamDataEnum.creatorID.name: creatorID,
        WCTeamDataEnum.isOpen.name: true,
        WCTeamDataEnum.teamID.name: _teamID,
      });

      //create member file
      _writeBatch.set(wcWCTeamDataCollection.doc(_teamID).collection('data').doc('members'), {
        UserStatusEnum.leader.name: <String, String>{creatorID: creatorName},
      });

      //create team instruments list
      _writeBatch.set(wcWCTeamDataCollection.doc(_teamID).collection('data').doc('instruments'), {
        'customInstruments': [],
      });

      //update creator data
      _writeBatch.update(WCUSerFirebaseAPI().wcUserDataCollection.doc(creatorID), {
        WCUserInfoDataEnum.userName.name: creatorName,
        WCUserInfoDataEnum.teamID.name: _teamID,
        WCUserInfoDataEnum.userStatusString.name: UserStatusEnum.leader.name,
      });

      //sends new team announcement
      String _announcementID = WCUtils.generateRandomID();

      _writeBatch.set(wcWCTeamDataCollection.doc(_teamID).collection('data').doc('announcements'), {
        _announcementID: <String, dynamic>{
          WCAnnouncementsDataEnum.announcementText.name: 'Welcome to $teamName. Created $createdDay by $creatorName.',
          WCAnnouncementsDataEnum.announcementPosterID.name: 'Worship Connect',
          WCAnnouncementsDataEnum.announcementID.name: _announcementID,
          WCAnnouncementsDataEnum.announcementPosterName.name: 'Worship Connect',
          WCAnnouncementsDataEnum.timestamp.name: Timestamp.now(),
        }
      });

      await _writeBatch.commit();

      if (fcmToken.isNotEmpty) {
        FirebaseMessaging.instance.subscribeToTopic(_teamID);
      }

      EasyLoading.dismiss();
    } catch (e, st) {
      WCUtils.wcShowError(e: e, st: st, wcError: e.toString());
      debugPrint(e.toString());
    }
  }

  Future joinTeam({
    required String teamID,
    required String joinerName,
    required String joinerID,
    required String fcmToken,
  }) async {
    if (joinerName.isEmpty) {
      EasyLoading.showError('User name cannot be empty');
      return;
    }

    if (teamID.isEmpty) {
      EasyLoading.showError('Team ID cannot be empty');
      return;
    }

    EasyLoading.show();

    WriteBatch _writeBatch = _firebaseInstance.batch();

    // try to get team document
    DocumentSnapshot _doc = await wcWCTeamDataCollection.doc(teamID).get();

    // check if the team exists
    if (!_doc.exists) {
      EasyLoading.showError(
        'Team does not exist.',
        dismissOnTap: true,
      );
      return;
    }

    // check if team is open
    if (!(_doc.data() as Map<String, dynamic>)[WCTeamDataEnum.isOpen.name]) {
      EasyLoading.showError(
        'Team is not open.',
        dismissOnTap: true,
      );
      return;
    }

    // update member list
    _writeBatch.update(wcWCTeamDataCollection.doc(teamID).collection('data').doc('members'), {
      'members.$joinerID': joinerName,
    });

    // update user data
    _writeBatch.update(WCUSerFirebaseAPI().wcUserDataCollection.doc(joinerID), {
      WCUserInfoDataEnum.userName.name: joinerName,
      WCUserInfoDataEnum.teamID.name: teamID,
      WCUserInfoDataEnum.userStatusString.name: UserStatusEnum.member.name,
    });

    await _writeBatch.commit();

    if (fcmToken.isNotEmpty) {
      FirebaseMessaging.instance.subscribeToTopic(teamID);
    }

    EasyLoading.dismiss();
  }
}
