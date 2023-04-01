import 'package:flutter/material.dart';

import '../bloc/blocs.dart';
import '../screens/screens.dart';

const String kRoot = '/';
const String rHomePage = '/home';
const String rRadiosPage = '/radios';
const String rSettingPage = '/setting';
const String rSearchPage = '/search';
const String rSourcesPage = '/sources';
const String rBookmarkPage = '/bookmark';

Route routes(RouteSettings settings) {
  switch (settings.name) {
    case kRoot:
      return MaterialPageRoute(builder: (context) {
        init(context);
        return const SplashScreen();
      });
    case rSettingPage:
      return materialPageRoute(const SettingsScreen());
    // case rSearchPage:
    //   return materialPageRoute(SearchPage());
    case rSourcesPage:
      return materialPageRoute(const SourcesPage());

    case rRadiosPage:
      return materialPageRoute(const RadioStations());
    case rBookmarkPage:
      return materialPageRoute(const BookmarksScreen());
    case rHomePage:
      return materialPageRoute(const Home());
    default:
      return materialPageRoute(const SplashScreen());
  }
}

MaterialPageRoute materialPageRoute(Widget child) {
  return MaterialPageRoute(builder: (context) {
    init(context);
    return child;
  });
}

void init(BuildContext context) async {
  final uBloc = UiProvider.of(context);
  // final aBloc = ApisProvider.of(context);
  final cacheBloc = CacheProvider.of(context);
  // aBloc.init();
  cacheBloc.init();
  uBloc.init();
}
