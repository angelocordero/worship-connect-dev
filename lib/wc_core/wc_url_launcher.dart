import 'package:url_launcher/url_launcher.dart';
import 'package:worship_connect/wc_core/worship_connect_utilities.dart';

class WCUrlLauncher {
  static Future openWCGithubPage() async {
    String wcGithubPageLink = 'https://github.com/angelocordero/worship-connect';
    String error = 'Cannot open Github page';

    if (!await canLaunch(wcGithubPageLink)) {
      WCUtils().wcShowError(error);
      return;
    }

    try {
      return await launch(wcGithubPageLink);
    } catch (e) {
      WCUtils().wcShowError(error);
    }
  }
}
