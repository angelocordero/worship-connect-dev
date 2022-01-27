import 'package:enum_to_string/enum_to_string.dart';
import 'package:worship_connect/wc_core/worship_connect_constants.dart';

class WCUserInfoData {
  final String userID;
  final String userName;
  final String userStatusString;
  final String teamID;

  late UserStatusEnum userStatus;

  WCUserInfoData({
    required this.userID,
    required this.userName,
    required this.userStatusString,
    required this.teamID,
  }) {
    userStatus = EnumToString.fromString(UserStatusEnum.values, userStatusString) ?? UserStatusEnum.noTeam;
  }
}
