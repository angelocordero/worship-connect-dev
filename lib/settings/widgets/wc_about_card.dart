import 'package:flutter/material.dart';

class WCAboutCard extends StatelessWidget {
  const WCAboutCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return const Hero(
      tag: 'about',
      child: Center(
        child: SingleChildScrollView(
          child: AboutDialog(
            applicationIcon: FlutterLogo(),
            applicationName: 'Worship Connect',
            applicationVersion: '1.0.0-release',
            children: [
              Text('To send issues or to contact me, please go to github.'),
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
