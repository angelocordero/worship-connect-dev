import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:worship_connect/wc_core/wc_url_launcher.dart';

class WCAboutCard extends StatelessWidget {
  const WCAboutCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'about',
      child: Center(
        child: SingleChildScrollView(
          child: AboutDialog(
            applicationIcon: const FlutterLogo(),
            applicationName: 'Worship Connect',
            applicationVersion: '1.0.0-release',
            children: [
              RichText(
                text: TextSpan(
                  text: 'To send issues or to contact me, please visit the ',
                  children: [
                    TextSpan(
                      text: 'Worship Connect Github page.',
                      style: const TextStyle(
                        color: Colors.blue,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          await WCUrlLauncher.openWCGithubPage();
                        },
                    ),
                  ],
                ),
              ),

              // SizedBox(
              //   height: 20,
              // ),
              // Text('Special thanks to my baby, Krystelle Sylvia Alvarado, for inspiring me in making  this.')
            ],
          ),
        ),
      ),
    );
  }
}
