import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:worship_connect/settings/services/team_firebase_api.dart';
import 'package:worship_connect/wc_core/worship_connect_constants.dart';
import 'package:worship_connect/sign_in/utils/wc_user_info_data.dart';
import 'package:worship_connect/wc_core/worship_connect_utilities.dart';

class WCUSerFirebaseAPI {
  final FirebaseFirestore _firebaseInstance = FirebaseFirestore.instance;
  late final CollectionReference wcUserDataCollection = _firebaseInstance.collection('WCUsers');

  initializeWCUserData({
    required String userID,
  }) {
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
    }
    return wcUserDataCollection.doc(userID).snapshots().map(
      (DocumentSnapshot snapshot) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

        return WCUserInfoData(
          userID: data[WCUserInfoDataEnum.userID.name],
          userName: data[WCUserInfoDataEnum.userName.name],
          userStatusString: data[WCUserInfoDataEnum.userStatusString.name],
          teamID: data[WCUserInfoDataEnum.teamID.name],
          fcmToken: data[WCUserInfoDataEnum.fcmToken.name] ?? '',
        );
      },
    );
  }

  Future updateUserName({
    required String userID,
    required String userName,
    String? teamID,
    UserStatusEnum? userStatus,
  }) async {
    EasyLoading.show();

    try {
      WriteBatch _writeBatch = _firebaseInstance.batch();

      if (userName.isEmpty) {
        EasyLoading.showError('User name must not be empty');
        return;
      }

      _writeBatch.update(wcUserDataCollection.doc(userID), {
        WCUserInfoDataEnum.userName.name: userName,
      });

      if (teamID != null && userStatus != UserStatusEnum.noTeam) {
        _writeBatch.update(TeamFirebaseAPI(teamID).teamsDataCollection.doc(teamID).collection('data').doc('members'), {
          '${userStatus!.name}.$userID': userName,
        });
      }

      await _writeBatch.commit();

      EasyLoading.dismiss();
    } catch (e, st) {
      WCUtils.wcShowError(e: e, st: st, wcError: 'Failed to update user name');
    }
  }

  Future<void> turnOnUserNotifications(String userID, String teamID) async {
    await _updateUserNotification(userID, teamID, true);
  }

  Future<void> turnOffUserNotifications(String userID, String teamID) async {
    await _updateUserNotification(userID, teamID, false);
  }

  Future<void> _updateUserNotification(String userID, String teamID, bool turnOn) async {
//    EasyLoading.show();

    String? _fcmToken = await FirebaseMessaging.instance.getToken();

    if (_fcmToken == null) {
      EasyLoading.dismiss();
      return Future.error('Fcm token not found');
    }

    try {
      WriteBatch _writeBatch = _firebaseInstance.batch();
      _writeBatch.update(wcUserDataCollection.doc(userID), <String, dynamic>{
        WCUserInfoDataEnum.fcmToken.name: turnOn ? _fcmToken : '',
      });

      if (turnOn) {
        _writeBatch.update(TeamFirebaseAPI(teamID).teamsDataCollection.doc(teamID).collection('data').doc('fcmTokens'), <String, dynamic>{
          'fcmTokensList': FieldValue.arrayUnion([_fcmToken]),
        });
      } else {
        _writeBatch.update(TeamFirebaseAPI(teamID).teamsDataCollection.doc(teamID).collection('data').doc('fcmTokens'), <String, dynamic>{
          'fcmTokensList': FieldValue.arrayRemove([_fcmToken.toString()]),
        });
      }

      await _writeBatch.commit();
      //  EasyLoading.dismiss();
    } catch (e, st) {
      WCUtils.wcShowError(e: e, st: st, wcError: 'Failed to update notifications');
    }
  }
}
