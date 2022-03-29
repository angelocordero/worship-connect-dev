import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:nanoid/nanoid.dart';
import 'package:intl/intl.dart';
import 'package:worship_connect/sign_in/utils/wc_user_info_data.dart';
import 'package:worship_connect/wc_core/worship_connect_constants.dart';

class WCUtils {
  static const String _wcAlphabet = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';

  static Widget authLoadingWidget() {
    EasyLoading.show();
    return Container();
  }

  static double screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static double screenHeightSafeArea(BuildContext context) {
    return MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
  }

  static double screenHeightSafeAreaAppBar(BuildContext context) {
    return MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - kToolbarHeight;
  }

  static double screenHeightSafeAreaAppBarBottomBar(BuildContext context) {
    return MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - kToolbarHeight - kBottomNavigationBarHeight;
  }

  static double screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static String generateTeamID() {
    String _randomID1 = customAlphabet(_wcAlphabet, 5);
    String _randomID2 = customAlphabet(_wcAlphabet, 5);
    String _randomID3 = customAlphabet(_wcAlphabet, 5);

    return '$_randomID1-$_randomID2-$_randomID3';
  }

  static String generateRandomID() {
    return customAlphabet(_wcAlphabet, 15);
  }

  static String timeToString(DateTime _dateTime) {
    return DateFormat.jm().format(_dateTime);
  }

  static String dateToString(DateTime _dateTime) {
    return '${DateFormat.EEEE().format(_dateTime)} ${DateFormat.yMMMd().format(_dateTime)}';
  }

  static String dateTimeToString(DateTime _dateTime) {
    return '${DateFormat.EEEE().format(_dateTime)} ${DateFormat.yMMMd().format(_dateTime)} ${DateFormat.jm().format(_dateTime)}';
  }

  static DateTime setDateTimeFromDayAndTime({
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

  static String setDateCode(DateTime _date) {
    return DateFormat('yyyyMMdd').format(_date);
  }

  static void wcShowError(String error) {
    EasyLoading.showError(
      error,
      dismissOnTap: true,
    );
  }

  static void wcShowInfo(String info) {
    EasyLoading.showInfo(
      info,
      dismissOnTap: true,
    );
  }

  static void wcShowSuccess(String success) {
    EasyLoading.showSuccess(
      success,
      dismissOnTap: true,
    );
  }

  static bool isAdminOrLeader(WCUserInfoData data) {
    return data.userStatus == UserStatusEnum.admin || data.userStatus == UserStatusEnum.leader;
  }

  static Hero wcExtendedFloatingActionButton({required Function() onPressed, required String heroTag, required String labelText, Icon? icon}) {
    return Hero(
      tag: heroTag,
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              offset: const Offset(0, 8),
              blurRadius: 6,
            ),
          ],
          borderRadius: BorderRadius.circular(90),
          gradient: wcLinearGradient,
        ),
        child: FloatingActionButton.extended(
          heroTag: null,
          backgroundColor: Colors.transparent,
          elevation: 0,
          onPressed: onPressed,
          label: Text(labelText),
          icon: icon,
        ),
      ),
    );
  }
}
