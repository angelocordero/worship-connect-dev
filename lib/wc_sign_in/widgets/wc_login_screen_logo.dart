import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:worship_connect/wc_core/worship_connect_constants.dart';

class WCLoginScreenLogo extends StatelessWidget {
  const WCLoginScreenLogo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 120.0),
        Row(
          children: const [
            // const SizedBox(
            //   width: 20.0,
            // ),
            // GradientText(
            //   'Welcome to',
            //   style: GoogleFonts.exo2(
            //     textStyle: wcSignInLogoTextStyle.copyWith(fontSize: 20),
            //   ),
            //   colors: wcColors,
            // ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GradientText(
              'WORSHIP',
              style: GoogleFonts.exo2(
                textStyle: wcSignInLogoTextStyle,
              ),
              colors: wcColors,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GradientText(
              'CONNECT',
              colors: wcColors,
              style: GoogleFonts.exo2(
                textStyle: wcSignInLogoTextStyle,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
