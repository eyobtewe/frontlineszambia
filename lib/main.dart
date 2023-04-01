import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:native_admob_flutter/native_admob_flutter.dart';

import 'src/app.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  HttpOverrides.global = MyHttpOverrides();
  await Firebase.initializeApp();

  await MobileAds.initialize();
  // MobileAds.setTestDeviceIds(['0285E4EA075685841E958F067765106D']);

  orientation();

  runApp(const App());
  // runApp(
  //   DevicePreview(
  //     enabled: false,
  //     builder: (context) => const App(),
  //   ),
  // );
}

orientation() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}
//   keytool -genkey -v -keystore keystore.jks -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias upload

// keytool -genkey -v -keystore key.jks -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias key
// keytool -importkeystore -srckeystore key.jks -destkeystore key.jks -deststoretype pkcs12
// keytool -list -v -alias key -keystore key.jks

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
