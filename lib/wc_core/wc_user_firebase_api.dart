import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:worship_connect/wc_core/worship_connect_constants.dart';
import 'package:worship_connect/sign_in/data_classes/wc_user_info_data.dart';

class WCUSerFirebaseAPI {
  final CollectionReference wcUserDataCollection = FirebaseFirestore.instance.collection('WCUsers');

  initializeWCUserData(String userID) {
    wcUserDataCollection.doc(userID).set({
      WCUserInfoDataEnum.userID.name: userID,
      WCUserInfoDataEnum.userName.name: '',
      WCUserInfoDataEnum.userStatusString: UserStatusEnum.noTeam.name,
      WCUserInfoDataEnum.teamID.name: '',
    });
  }

  Stream<WCUserInfoData?> wcUserInfoDataStream(String? userID) {
    return wcUserDataCollection.doc(userID).snapshots().map(
      (DocumentSnapshot snapshot) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

        return WCUserInfoData(
          userID: data[WCUserInfoDataEnum.userID.name],
          userName: data[WCUserInfoDataEnum.userName.name],
          userStatusString: data[WCUserInfoDataEnum.userStatusString.name],
          teamID: data[WCUserInfoDataEnum.teamID.name],
        );
      },
    );
  }

  Future updateUserName({required String userID, required String userName, String? teamID}) async {
    EasyLoading.show();

    if (userName.isEmpty) {
      EasyLoading.showError('User name must not be empty');
      return;
    }

    await wcUserDataCollection.doc(userID).update({
      WCUserInfoDataEnum.userName.name: userName,
    });

    EasyLoading.dismiss();

    // TODO: also change user name in team member list
    // TODO: also change user name in announcements data
  }
}
