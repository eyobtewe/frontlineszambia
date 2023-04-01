import 'package:flutter/material.dart';

import '../../bloc/blocs.dart';
import '../../core/core.dart';

class BottomBar extends StatelessWidget {
  final int index;

  const BottomBar({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bloc = UiProvider.of(context);
    // ScreenUtil.init(context, allowFontScaling: true, designSize: size);
    return buildBottomNavigationBar(context, bloc, size);
  }

  Widget buildBottomNavigationBar(
      BuildContext context, UiBloc bloc, Size size) {
    return BottomNavigationBar(
      items: items(bloc),
      showSelectedLabels: true,
      iconSize: 20,
      showUnselectedLabels: true,
      currentIndex: index,
      type: BottomNavigationBarType.fixed,
      onTap: (int i) {
        switch (i) {
          case 0:
            // lastPost = null;
            // Navigator.pushReplacementNamed(context, rHomePage);
            Navigator.pushNamedAndRemoveUntil(
                context, rHomePage, (route) => false);
            break;
          case 1:
            // showSearch(context: context, delegate: ArticleSearch());
            // Navigator.pushReplacementNamed(context, rSearchPage);
            Navigator.pushNamedAndRemoveUntil(
                context, rRadiosPage, (route) => false);
            // Navigator.pushReplacementNamed(context, rVideosPage);
            break;
          case 2:
            Navigator.pushNamedAndRemoveUntil(
                context, rSourcesPage, (route) => false);
            // Navigator.pushReplacementNamed(context, rBookmarkPage);
            break;
          case 3:
            Navigator.pushNamedAndRemoveUntil(
                context, rSettingPage, (route) => false);
            // Navigator.pushReplacementNamed(context, rSettingPage);
            break;
          default:
            // queryDocumentSnapshot = null;
            Navigator.pushNamedAndRemoveUntil(
                context, rHomePage, (route) => false);
            // Navigator.pushReplacementNamed(context, rHomePage);
            break;
        }
      },
    );
  }

  List<BottomNavigationBarItem> items(UiBloc bloc) {
    final news = bottomNavigationBarItem(bloc, 0, 'news');
    final radios = bottomNavigationBarItem(bloc, 1, 'radio');
    // final search = bottomNavigationBarItem(bloc, 1, 'search');
    final favorite = bottomNavigationBarItem(bloc, 2, 'browse');
    final setting = bottomNavigationBarItem(bloc, 3, 'setting');

    return [news, radios, favorite, setting];
  }

  BottomNavigationBarItem bottomNavigationBarItem(
      UiBloc bloc, int i, String label) {
    // List icons = [
    //   Ionicons.home_outline,
    //   // Ionicons.search_outline,
    //   Ionicons.mic_outline,
    //   Ionicons.bookmark_outline,
    //   Ionicons.menu_outline, //ellipsis_horizontal_outline,
    //   //
    //   Ionicons.home,
    //   // Ionicons.search,
    //   Ionicons.mic,
    //   Ionicons.bookmark,
    //   Ionicons.menu //ellipsis_horizontal,
    // ];
    List icons = [
      Icons.newspaper_outlined,
      // Icons.search_outlined,
      Icons.radio_outlined,
      Icons.explore_outlined,
      Icons.more_horiz_outlined, //ellipsis_horizontal_outline,
      //
      Icons.newspaper_rounded,
      // Ionicons.search,
      Icons.radio_rounded,
      Icons.explore_rounded,
      Icons.more_horiz_rounded, //ellipsis_horizontal,
    ];
    return BottomNavigationBarItem(
      icon: Icon(icons[i]),
      activeIcon: Icon(icons[i + 4]),
      label: Language.locale(bloc.lang, label),
    );
  }
}

// TextStyle _textStyle = const TextStyle(
//   
//   // fontSize: ScreenUtil().setSp(12),
//   fontSize: 0,
//   fontFamily: 'OpenSans',
//   // height: 1.5,
// );
