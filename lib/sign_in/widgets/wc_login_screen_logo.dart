import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:worship_connect/wc_core/worship_connect_constants.dart';
import 'package:worship_connect/wc_core/worship_connect_utilities.dart';

class WCLoginScreenLogo extends StatelessWidget {
  const WCLoginScreenLogo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: WCUtils.screenHeightSafeArea(context) / 4),
        GradientText(
          'WORSHIP',
          style: GoogleFonts.exo2(
            textStyle: wcSignInLogoTextStyle,
          ),
          colors: wcGradientColors,
        ),
        GradientText(
          'CONNECT',
          colors: wcGradientColors,
          style: GoogleFonts.exo2(
            textStyle: wcSignInLogoTextStyle,
          ),
        ),
      ],
    );
  }
}
