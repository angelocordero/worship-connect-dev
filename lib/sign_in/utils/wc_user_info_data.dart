import 'package:enum_to_string/enum_to_string.dart';

import 'package:worship_connect/wc_core/worship_connect_constants.dart';

enum WCUserInfoDataEnum {
  userID,
  userName,
  userStatusString,
  teamID,
  fcmToken,
}

class WCUserInfoData {
  final String userID;
  final String userName;
  final String userStatusString;
  final String teamID;
  final String fcmToken;

  late UserStatusEnum userStatus;

  WCUserInfoData({
    required this.userID,
    required this.userName,
    required this.userStatusString,
    required this.teamID,
    required this.fcmToken,
  }) {
    userStatus = EnumToString.fromString(UserStatusEnum.values, userStatusString) ?? UserStatusEnum.noTeam;
  }
  WCUserInfoData.empty()
      : userID = '',
        userName = '',
        userStatusString = UserStatusEnum.noTeam.name,
        teamID = '',
        fcmToken = '' {
    userStatus = EnumToString.fromString(UserStatusEnum.values, userStatusString) ?? UserStatusEnum.noTeam;
  }

  @override
  String toString() {
    return 'WCUserInfoData(userID: $userID, userName: $userName, userStatusString: $userStatusString, teamID: $teamID, userStatus: $userStatus)';
  }
}
