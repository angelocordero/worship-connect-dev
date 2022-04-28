import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum UserStatusEnum {
  noTeam,
  member,
  admin,
  leader,
}

Size wcSignInButtonSize = const Size(
  300,
  45,
);

TextStyle wcSignInButtonTextStyle = const TextStyle(
  color: Colors.black,
  fontSize: 14.0,
);

TextStyle wcSignInLogoTextStyle = GoogleFonts.rajdhani(
  textStyle: const TextStyle(
    fontSize: 60,
    fontWeight: FontWeight.w600,
  ),
);

List<Color> wcGradientColors = const [
  Color(0xff31a6dc),
  Color(0xff00d8d8),
  Color(0xff1eff8e),
];

Color wcAccentColor = const Color(0xff00d8d8);

Color wcWarningColor = const Color(0xffff5555);

LinearGradient wcLinearGradient = LinearGradient(
  colors: wcGradientColors,
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
);

ThemeData wcDarkTheme = ThemeData(
  brightness: Brightness.dark,
  colorSchemeSeed: wcAccentColor,
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    selectedItemColor: wcAccentColor,
  ),
  appBarTheme: AppBarTheme(
    titleTextStyle: GoogleFonts.raleway(
      fontSize: 20,
    ),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    foregroundColor: Colors.black,
    backgroundColor: Colors.transparent,
    elevation: 0,
    extendedTextStyle: GoogleFonts.raleway(color: Colors.black),
  ),
  textTheme: TextTheme(
    subtitle1: GoogleFonts.raleway(), // used in list tile title and important texts by the app
    bodyText2: GoogleFonts.openSans(), // used for regular text and texts that should be readable
    bodyText1: GoogleFonts.raleway(
      //used in wc announcement header
      textStyle: TextStyle(
        fontSize: 13,
        color: Colors.grey.shade400,
      ),
    ),
    headline6: GoogleFonts.raleway(),
  ),
  iconTheme: IconThemeData(
    color: Colors.grey.shade400,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      textStyle: MaterialStateProperty.all<TextStyle>(
        GoogleFonts.raleway(
          fontSize: 14,
        ),
      ),
      shape: MaterialStateProperty.all<OutlinedBorder>(
        const StadiumBorder(),
      ),
    ),
  ),
);

ThemeData wcLightTheme = ThemeData(
  brightness: Brightness.light,
  colorSchemeSeed: wcAccentColor,
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    selectedItemColor: wcAccentColor,
    selectedLabelStyle: GoogleFonts.raleway(),
    unselectedLabelStyle: GoogleFonts.raleway(),
  ),
  appBarTheme: AppBarTheme(
    iconTheme: const IconThemeData(
      color: Colors.black,
    ),
    color: wcAccentColor,
    titleTextStyle: GoogleFonts.raleway(
      color: Colors.black,
      fontSize: 20,
    ),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    foregroundColor: Colors.black,
    backgroundColor: Colors.transparent,
    elevation: 0,
    extendedTextStyle: GoogleFonts.raleway(color: Colors.black),
  ),
  textTheme: TextTheme(
    subtitle1: GoogleFonts.raleway(), // used in list tile title and important texts by the app
    bodyText2: GoogleFonts.openSans(), // used for regular text and texts that should be readable
    bodyText1: GoogleFonts.raleway(
      //used in wc announcement header
      textStyle: TextStyle(
        fontSize: 13,
        color: Colors.grey.shade700,
      ),
    ),

    headline6: GoogleFonts.raleway(),
  ),
  iconTheme: IconThemeData(
    color: Colors.grey.shade700,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      foregroundColor: MaterialStateProperty.all<Color>(
        Colors.black,
      ),
      textStyle: MaterialStateProperty.all<TextStyle>(
        GoogleFonts.raleway(
          fontSize: 14,
        ),
      ),
      shape: MaterialStateProperty.all<OutlinedBorder>(
        const StadiumBorder(),
      ),
      backgroundColor: MaterialStateProperty.all<Color>(wcAccentColor),
    ),
  ),
);

TextStyle wcHintStyle = const TextStyle(color: Colors.grey);

Icon wcTrailingIcon = const Icon(Icons.arrow_forward_ios_outlined);

List<String> wcCoreInstruments = [
  'Worship Leader',
  'Backup Singers',
  'Acoustic Guitarist',
  'Electric Guitarist',
  'Bassist',
  'Drummer',
];
