import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:worship_connect/settings/data_classes/wc_team_data.dart';

class TeamFirebaseAPI {
  TeamFirebaseAPI(this.teamID);

  String teamID;

  final CollectionReference teamsDataCollection = FirebaseFirestore.instance.collection('WCTeams');

  Stream<TeamData> teamData() {
    return teamsDataCollection.doc(teamID).snapshots().map(
      (DocumentSnapshot object) {
        Map<String, dynamic> data = (object as DocumentSnapshot<Map<String, dynamic>>).data()!;

        return TeamData(
          creatorID: data['creatorID'],
          teamID: data['teamID'],
          teamName: data['teamName'],
          isOpen: data['isOpen'],
        );
      },
    );
  }

  // Stream<TeamData> get teamData {
  //   return teamsDataCollection.doc(teamID).snapshots().map(_asd);
  // }

  // TeamData _asd(snapshot) {

  //   return TeamData(
  //     teamID: snapshot.data()['teamID'],
  //     teamName: snapshot.data()['teamName'],
  //     creatorID: snapshot.data()['creatorID'],
  //     isOpen: snapshot.data()['isOpen'],
  //   );
  // }
}
