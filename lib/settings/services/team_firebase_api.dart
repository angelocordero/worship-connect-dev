import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:worship_connect/settings/data_classes/wc_team_data.dart';

class TeamFirebaseAPI {
  TeamFirebaseAPI(this.teamID);

  String teamID;

  final CollectionReference teamsDataCollection = FirebaseFirestore.instance.collection('WCTeams');

  Stream<TeamData> teamData() {
    return teamsDataCollection.doc(teamID).snapshots().map(
      (DocumentSnapshot object) {
        Map<String, dynamic>? data = (object as DocumentSnapshot<Map<String, dynamic>>).data();

        return TeamData(
          creatorID: data?['creatorID'] ?? '',
          teamID: data?['teamID'] ?? '',
          teamName: data?['teamName'] ?? '',
          isOpen: data?['isOpen'] ?? '',
        );
      },
    );
  }

  void toggleIsTeamOpen(bool currentStatus) async {
    EasyLoading.show();
    await teamsDataCollection.doc(teamID).update({
      'isOpen': !currentStatus,
    });

    EasyLoading.dismiss();
  }

  Future<void> leaveTeam({
    required String userID,
    required String teamID,
  }) {

    //TODO: implement leave team


  }
}
