import 'dart:convert';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:nanoid/nanoid.dart';
import 'package:intl/intl.dart';
import 'package:worship_connect/sign_in/utils/wc_user_info_data.dart';
import 'package:worship_connect/wc_core/worship_connect_constants.dart';
import 'package:http/http.dart' as http;

class WCUtils {
  static const String _wcAlphabet = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';

  static double screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static double screenHeightSafeArea(BuildContext context) {
    return MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
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
    return DateFormat.yMMMMEEEEd().format(_dateTime);
  }

  static String dateTimeToString(DateTime _dateTime) {
    return '${DateFormat.yMMMMEEEEd().format(_dateTime)} ${DateFormat.jm().format(_dateTime)}';
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

  static Future<void> wcShowError({Object? e, StackTrace? st, required String wcError}) async {
    if (e != null && st != null) {
      debugPrint('WCError: ${e.toString()}');
      await FirebaseCrashlytics.instance.recordError(
        e,
        st,
        reason: wcError,
      );
    }

    EasyLoading.showError(
      wcError,
      dismissOnTap: true,
    );
  }

  static void wcShowSuccess(String success) {
    EasyLoading.showSuccess(
      success,
      dismissOnTap: true,
    );
  }

  static bool isAdminOrLeader(WCUserInfoData? data) {
    if (data == null) {
      return false;
    }

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
          onPressed: onPressed,
          label: Text(
            labelText,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          icon: icon,
        ),
      ),
    );
  }

// notify team for schedule and announcement updates
  static void sendTeamNotification({
    required String title,
    required String body,
    required String teamID,
    required String notificationType,
  }) async {
//    String _embedURL = 'https://wc-notifications-server.herokuapp.com/notify-team';

    try {
      String _embedURL = 'http://192.168.1.12:5000/notify-team';

      //! IMPORTANT
      //TODO change embed url

      String _fcmToken = await FirebaseMessaging.instance.getToken() ?? '';

      Map _notification = {
        'title': title,
        'body': body,
        'teamID': teamID,
        'posterFcmToken': _fcmToken,
        'notificationType': notificationType,
      };

      http.post(Uri.parse(_embedURL),
          headers: {
            'Content-type': 'application/json',
            'Accept': 'application/json',
          },
          body: jsonEncode(_notification));
    } catch (e) {
//
    }
  }

//notify members for demotions and promotions
  static void sendMemberNotification({
    required String title,
    required String body,
    required String targetUserID,
  }) {
    //  String _embedURL = 'https://wc-notifications-server.herokuapp.com/notify-member';

    try {
      String _embedURL = 'http://192.168.1.12:5000/notify-member';

      //! IMPORTANT
      //TODO change embed url

      Map _notification = {
        'title': title,
        'body': body,
        'userID': targetUserID,
        'notificationType': 'member',
      };

      http.post(Uri.parse(_embedURL),
          headers: {
            'Content-type': 'application/json',
            'Accept': 'application/json',
          },
          body: jsonEncode(_notification));
    } catch (e) {
      //
    }
  }

  static void kickMemberNotification({
    required String title,
    required String body,
    required String targetUserID,
    required String teamID,
  }) {
//    String _embedURL = 'https://wc-notifications-server.herokuapp.com/kick-member';

    //! IMPORTANT
    //TODO change embed url

    try {
      String _embedURL = 'http://192.168.1.12:5000/kick-member';

      Map _notification = {
        'title': title,
        'body': body,
        'userID': targetUserID,
        'notificationType': 'kick',
        'teamID': teamID,
      };

      http.post(Uri.parse(_embedURL),
          headers: {
            'Content-type': 'application/json',
            'Accept': 'application/json',
          },
          body: jsonEncode(_notification));
    } catch (e) {
      //
    }
  }
}
