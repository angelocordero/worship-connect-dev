import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:nanoid/nanoid.dart';
import 'package:intl/intl.dart';
import 'package:worship_connect/sign_in/utils/wc_user_info_data.dart';
import 'package:worship_connect/wc_core/worship_connect_constants.dart';

class WCUtils {
  final String _wcAlphabet = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';

  Widget authLoadingWidget() {
    EasyLoading.show();
    return Container();
  }

  double screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  double screenHeightSafeArea(BuildContext context) {
    return MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
  }

  double screenHeightSafeAreaAppBar(BuildContext context) {
    return MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - kToolbarHeight;
  }

  double screenHeightSafeAreaAppBarBottomBar(BuildContext context) {
    return MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - kToolbarHeight - kBottomNavigationBarHeight;
  }

  double screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  String generateTeamID() {
    String _randomID1 = customAlphabet(_wcAlphabet, 5);
    String _randomID2 = customAlphabet(_wcAlphabet, 5);
    String _randomID3 = customAlphabet(_wcAlphabet, 5);

    return '$_randomID1-$_randomID2-$_randomID3';
  }

  String generateRandomID() {
    return customAlphabet(_wcAlphabet, 15);
  }

  String timeToString(DateTime _dateTime) {
    return DateFormat.jm().format(_dateTime);
  }

  String dateToString(DateTime _dateTime) {
    return '${DateFormat.EEEE().format(_dateTime)} ${DateFormat.yMMMd().format(_dateTime)}';
  }

  String dateTimeToString(DateTime _dateTime) {
    return '${DateFormat.EEEE().format(_dateTime)} ${DateFormat.yMMMd().format(_dateTime)} ${DateFormat.jm().format(_dateTime)}';
  }

  DateTime setDateTimeFromDayAndTime({
    required DateTime dateTime,
    required TimeOfDay timeOfDay,
  }) {
    return DateTime(
      dateTime.year,
      dateTime.month,
      dateTime.day,
      timeOfDay.hour,
      timeOfDay.minute,
    );
  }

  String setDateCode(DateTime _date) {
    return DateFormat('yyyyMMdd').format(_date);
  }

  void wcShowError(String error) {
    EasyLoading.showError(
      error,
      dismissOnTap: true,
    );
  }

  void wcShowInfo(String info) {
    EasyLoading.showInfo(
      info,
      dismissOnTap: true,
    );
  }

  void wcShowSuccess(String success) {
    EasyLoading.showSuccess(
      success,
      dismissOnTap: true,
    );
  }

  bool isAdminOrLeader(WCUserInfoData data) {
    return data.userStatus == UserStatusEnum.admin || data.userStatus == UserStatusEnum.leader;
  }
}
