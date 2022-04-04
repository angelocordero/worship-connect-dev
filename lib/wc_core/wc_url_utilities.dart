import 'dart:convert';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:worship_connect/wc_core/worship_connect_utilities.dart';
import 'package:http/http.dart' as http;

class WCUrlUtils {
  static Future openWCGithubPage() async {
    String wcGithubPageLink = 'https://github.com/angelocordero/worship-connect';
    String error = 'Cannot open Github page';

    if (!await canLaunch(wcGithubPageLink)) {
      WCUtils.wcShowError(wcError: error);
      return;
    }

    try {
      return await launch(wcGithubPageLink);
    } catch (e, st) {
      WCUtils.wcShowError(e: e, st: st, wcError: error);
    }
  }

  static Future<String?> getYoutubeLinkTitle(String? songURL) async {
    String _embedURL = "https://www.youtube.com/oembed?url=$songURL&format=json";

    EasyLoading.show();

    http.Response response = await http.get(Uri.parse(_embedURL));

    try {
      if (response.statusCode == 200) {
        return jsonDecode(response.body)['title'];
      } else {
        return null;
      }
    } catch (e) {
      return null;
    } finally {
      EasyLoading.dismiss();
    }
  }
}
