import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'bloc/blocs.dart';
import 'core/core.dart';
import 'helpers/theme_provider.dart';

FirebaseAnalytics kAnalytics = FirebaseAnalytics.instance;
FirebaseAnalyticsObserver screenObserver = FirebaseAnalyticsObserver(
  analytics: kAnalytics,
);

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PlayerProvider(
      child: UiProvider(
        child: CacheProvider(
            child: ApisProvider(
          child: ChangeNotifierProvider(
            create: (_) => ThemeNotifier(),
            child: Consumer<ThemeNotifier>(
              builder: (BuildContext context, ThemeNotifier notifier,
                  Widget? child) {
                return MaterialApp(
                  navigatorObservers: [screenObserver],
                  debugShowCheckedModeBanner: false,
                  theme: Provider.of<ThemeNotifier>(context).currentTheme,
                  onGenerateRoute: routes,
                  // home: const RadioStations()
                  // theme: kTHEME,
                  // theme: kDarkTHEME,
                  // darkTheme: kDarkTHEME,
                  // themeMode: Provider.of<ThemeNotifier>(context).theme,
                  // useInheritedMediaQuery: true,
                  // locale: DevicePreview.locale(context),
                  // builder: DevicePreview.appBuilder,
                );
              },
            ),
          ),
        )),
      ),
    );
  }
}
