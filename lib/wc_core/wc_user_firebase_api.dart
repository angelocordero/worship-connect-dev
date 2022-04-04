import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:worship_connect/wc_core/worship_connect_constants.dart';
import 'package:worship_connect/sign_in/utils/wc_user_info_data.dart';
import 'package:worship_connect/wc_core/worship_connect_utilities.dart';

class WCUSerFirebaseAPI {
  final CollectionReference wcUserDataCollection = FirebaseFirestore.instance.collection('WCUsers');

  initializeWCUserData(String userID) {
    try {
      wcUserDataCollection.doc(userID).set(<String, dynamic>{
        WCUserInfoDataEnum.userID.name: userID,
        WCUserInfoDataEnum.userName.name: '',
        WCUserInfoDataEnum.userStatusString.name: UserStatusEnum.noTeam.name,
        WCUserInfoDataEnum.teamID.name: '',
      });
    } catch (e, st) {
      debugPrint('WCError: ' + e.toString());
      WCUtils.wcShowError(e: e, st: st, wcError: 'Failed to initialize user data');
    }
  }

  Stream<WCUserInfoData?> wcUserInfoDataStream(String? userID) {
    if (userID == null) {
      return Stream.value(null);
    } else {
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
  }

  Future updateUserName({required String userID, required String userName, String? teamID}) async {
    EasyLoading.show();

    try {
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

    } catch (e, st) {
      WCUtils.wcShowError(e: e, st: st, wcError: 'Failed to update user name');
    }
  }
}
