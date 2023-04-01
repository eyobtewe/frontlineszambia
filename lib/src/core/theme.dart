import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../helpers/custom_route.dart';
import 'app_colors.dart';

final ThemeData kTHEME = ThemeData(
  scaffoldBackgroundColor: cWhite,
  primaryColor: cPurecBlack,
  // textTheme: GoogleFonts.ptSansTextTheme(),
  pageTransitionsTheme: newMethod(),

  bottomNavigationBarTheme: bottomNavBar(cWhite, cBlack),
  appBarTheme: AppBarTheme(
    iconTheme: const IconThemeData(color: cBlack),
    toolbarTextStyle: lightTextStyle,
    titleTextStyle: lightTextStyle,
    actionsIconTheme: const IconThemeData(color: cBlack),
    backgroundColor: cWhite,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all(cPureWhite),
    ),
  ),
  buttonTheme: const ButtonThemeData(buttonColor: cGrey),
  colorScheme: ColorScheme.fromSwatch().copyWith(
    secondary: cBlack,
    brightness: Brightness.light,
  ),
);

BottomNavigationBarThemeData bottomNavBar(Color back, Color prim) {
  TextStyle _textStyle = const TextStyle(
    fontSize: 12,
    // fontWeight: FontWeight.bold,
  );

  return BottomNavigationBarThemeData(
    backgroundColor: back,
    showSelectedLabels: true,
    showUnselectedLabels: true,
    selectedItemColor: prim,
    selectedLabelStyle: _textStyle,
    unselectedLabelStyle: _textStyle,
    unselectedItemColor: prim.withOpacity(0.75),
    selectedIconTheme: IconThemeData(color: prim),
    unselectedIconTheme: IconThemeData(color: prim.withOpacity(0.75)),
  );
}

final ThemeData kDarkTHEME = ThemeData(
  // // textTheme: GoogleFonts.ptSansTextTheme(),
  pageTransitionsTheme: newMethod(),
  scaffoldBackgroundColor: cBlack,
  bottomNavigationBarTheme: bottomNavBar(cBlack, cLessWhite),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all(cPurecBlack),
    ),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: cBlack,
    toolbarTextStyle: darkTextStyle,
    titleTextStyle: darkTextStyle,
    systemOverlayStyle: SystemUiOverlayStyle.dark,
    iconTheme: const IconThemeData(color: cLessWhite),
    actionsIconTheme: const IconThemeData(color: cLessWhite),
  ),
  buttonTheme: const ButtonThemeData(buttonColor: cGrey),
  colorScheme: ColorScheme.fromSwatch().copyWith(
    secondary: cLessWhite,
    brightness: Brightness.dark,
  ),
);

// final TextStyle lightTextStyle = GoogleFonts.ptSans().copyWith(
TextStyle lightTextStyle = TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 20,
  color: cBlack,
  fontFamily: GoogleFonts.montserrat().fontFamily,
  // fontFamily: 'Oswald',
);
// final TextStyle darkTextStyle = GoogleFonts.ptSans().copyWith(
TextStyle darkTextStyle = TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 20,
  color: cLessWhite,
  fontFamily: GoogleFonts.montserrat().fontFamily,
  // fontFamily: 'Oswald',
);

PageTransitionsTheme newMethod() {
  return PageTransitionsTheme(
    builders: {
      TargetPlatform.android: CustomPageTransitionBuilder(),
      TargetPlatform.iOS: CustomPageTransitionBuilder(),
    },
  );
}
