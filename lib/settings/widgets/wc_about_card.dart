import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:worship_connect/wc_core/wc_about_details.dart';
import 'package:worship_connect/wc_core/wc_url_utilities.dart';

class WCAboutCard extends StatelessWidget {
  const WCAboutCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'about',
      child: Center(
        child: SingleChildScrollView(
          child: AboutDialog(
            applicationIcon: wcApplicationIcon,
            applicationName: wcApplicationName,
            applicationVersion: wcApplicationVersion,
            children: [
              RichText(
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  text: 'To send issues or to contact me, please visit the ',
                  children: [
                    TextSpan(
                      text: 'Worship Connect Github page.',
                      style: const TextStyle(
                        color: Colors.blue,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          await WCUrlUtils.openWCGithubPage();
                        },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
