import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:worship_connect/wc_core/wc_user_firebase_api.dart';
import 'package:worship_connect/wc_core/worship_connect_constants.dart';
import 'package:worship_connect/wc_core/worship_connect_utilities.dart';

class CreateJoinTeamFirebaseAPI {
  final FirebaseFirestore _firebaseInstance = FirebaseFirestore.instance;
  final CollectionReference wcTeamDataCollection = FirebaseFirestore.instance.collection('WCTeams');

  Future createTeam({
    required String teamName,
    required String creatorID,
    required String creatorName,
  }) async {
    if (teamName.isEmpty) {
      EasyLoading.showError('Team name cannot be empty');
      return;
    }

    EasyLoading.show();

    String _teamID = WCUtils().generateTeamID();
    String createdDay = WCUtils().dateToString(DateTime.now());

    WriteBatch _writeBatch = _firebaseInstance.batch();

    //set team info
    _writeBatch.set(wcTeamDataCollection.doc(_teamID), {
      'teamName': teamName,
      'creatorID': creatorID,
      'creatorName': creatorName,
      'isOpen': true,
      'teamiD': _teamID,
    });

    //create member file
    _writeBatch.set(wcTeamDataCollection.doc(_teamID).collection('data').doc('members'), {
      'leader': <String, String>{creatorID: creatorName},
    });

    //update creator data
    _writeBatch.update(WCUSerFirebaseAPI().wcUserDataCollection.doc(creatorID), {
      'teamID': _teamID,
      'userStatusString': UserStatus.leader.name,
    });

    //sends new team announcement
    Timestamp _timestamp = Timestamp.now();
    String _announcementID = WCUtils().generateRandomID();

    _writeBatch.set(wcTeamDataCollection.doc(_teamID).collection('data').doc('announcements'), {
      _announcementID: <String, dynamic>{
        'announcement': 'Welcome to $teamName. Created $createdDay by $creatorName.',
        'posterID': 'Worship Connect',
        'timestamp': _timestamp,
        'announcementID': _announcementID,
        'posterName': 'Worship Connect'
      }
    });

    await _writeBatch.commit();

    EasyLoading.dismiss();
  }

  Future joinTeam({
    required String teamID,
    required String joinerName,
    required String joinerID,
  }) async {
    if (teamID.isEmpty) {
      EasyLoading.showError('Team ID cannot be empty');
      return;
    }

    EasyLoading.show();

    WriteBatch _writeBatch = _firebaseInstance.batch();

    // try to get team document
    DocumentSnapshot _doc = await wcTeamDataCollection.doc(teamID).get();

    // check if the team exists
    if (!_doc.exists) {
      EasyLoading.showError(
        'Team does not exist.',
        dismissOnTap: true,
      );
      return;
    }

    // check if team is open
    if (!(_doc.data() as Map<String, dynamic>)['isOpen']) {
      EasyLoading.showError(
        'Team is not open.',
        dismissOnTap: true,
      );
      return;
    }

    // update member list
    _writeBatch.update(wcTeamDataCollection.doc(teamID).collection('data').doc('members'), {
      'normalMembers.$joinerID': joinerName,
    });

    // update user data
    _writeBatch.update(WCUSerFirebaseAPI().wcUserDataCollection.doc(joinerID), {
      'teamID': teamID,
      'userStatusString': UserStatus.member.name,
    });

    await _writeBatch.commit();

    EasyLoading.dismiss();
  }
}
