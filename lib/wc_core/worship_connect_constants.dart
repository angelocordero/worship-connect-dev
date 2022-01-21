import 'package:flutter/material.dart';

enum UserAuthProvider {
  facebook,
  google,
}

enum UserStatus {
  noTeam,
  member,
  admin,
  leader,
}

Size wcSignInButtonSize = const Size(
  300,
  45,
);

RoundedRectangleBorder wcButtonShape = RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(30),
);

TextStyle wcSignInButtonTextStyle = const TextStyle(
  color: Colors.blueGrey,
  fontSize: 14.0,
);

TextStyle wcSignInLogoTextStyle = const TextStyle(
  fontSize: 60,
  fontWeight: FontWeight.w600,
);

List<Color> wcGradientColors = const [
  Color(0xff31a6dc),
  Color(0xff00d8d8),
  Color(0xff1eff8e),
];

Color wcPrimaryColor = const Color(0xff00d8d8);

LinearGradient wcLinearGradient = LinearGradient(
  colors: wcGradientColors,
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
);

TextStyle wcHintStyle = const TextStyle(color: Colors.grey);
