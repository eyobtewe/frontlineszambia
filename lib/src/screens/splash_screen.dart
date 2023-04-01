import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../bloc/blocs.dart';
import '../core/core.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
  }

  late ApisBloc aBloc;
  late UiBloc uiBloc;
  // bool isLoading = true;
  @override
  Widget build(BuildContext context) {
    aBloc = ApisProvider.of(context);
    uiBloc = UiProvider.of(context);
    // final themeProvider = Provider.of<ThemeNotifier>(context);
    // goToHomeScreen(context);

    // Size size = MediaQuery.of(context).size;
    // ScreenUtil.init(context, designSize: size, allowFontScaling: true);
    return Scaffold(
      // backgroundColor: Provider.of<ThemeNotifier>(context)
      //     .currentTheme
      //     .scaffoldBackgroundColor,
      backgroundColor: cBlack,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // SizedBox(
          //   child: Image.asset(themeProvider.darkTheme ? logoWhtie : logoBlack),
          //   width: size.width / 4,
          // ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            alignment: Alignment.center,
            child: Text(
              Language.locale(uiBloc.lang, 'app_name'),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30,
                color: cWhite,
                fontFamily: GoogleFonts.montserrat().fontFamily,
                // color: Theme.of(context).colorScheme.secondary,
                // fontWeight: FontWeight.w100,
                // fontFamily: kOldFonts[0],
              ),
            ),
          ),
          AnimatedTextKit(
            displayFullTextOnTap: true,
            isRepeatingAnimation: false,
            totalRepeatCount: 0,
            repeatForever: false,
            onFinished: () {
              goToHomeScreen(context);
            },
            animatedTexts: [
              TyperAnimatedText(
                '\nGet all Zambian Newspapers &\n Radio Stations in one App',
                speed: const Duration(milliseconds: 30),
                textAlign: TextAlign.center,
                textStyle: TextStyle(
                  fontSize: 12,
                  color: const Color(0x99E1E5EA),
                  fontFamily: GoogleFonts.montserrat().fontFamily,
                  // fontWeight: FontWeight.w100,
                ),
              ),
            ],
            onTap: () {
              goToHomeScreen(context);
            },
          ),
        ],
      ),
    );
  }

  void goToHomeScreen(BuildContext ctx) async {
    // Future.delayed(const Duration(milliseconds: 1500), () {
    Navigator.pushNamedAndRemoveUntil(context, rHomePage, (route) => false);
    // });
  }

  @override
  void dispose() {
    super.dispose();
  }
}

// const String logoWhtie = 'assets/images/ee-white.png';
// const String logoBlack = 'assets/images/ee-black.png';

// const List<String> kOldFonts = [
//   // 'Washington-Text-Regular',
//   // 'Knights-Quest',
//   // 'Canterbury',
//   'Chomsky',
//   'FenwickWoodtype',
// ];
