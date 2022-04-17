import 'package:flutter/material.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:worship_connect/wc_core/worship_connect_constants.dart';
import 'package:worship_connect/wc_core/worship_connect_utilities.dart';

class WCLoginScreenLogo extends StatelessWidget {
  const WCLoginScreenLogo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: WCUtils.screenHeightSafeArea(context) / 2,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(40.0, 60.0, 40.0, 40.0),
        child: FittedBox(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              GradientText(
                'WORSHIP',
                style: wcSignInLogoTextStyle,
                colors: wcGradientColors,
              ),
              GradientText(
                'CONNECT',
                colors: wcGradientColors,
                style: wcSignInLogoTextStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
