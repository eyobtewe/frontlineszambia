import 'core.dart';

class Language {
  static const Map<String, String> lEnglish = {
    'app_name': 'Frontlines Zambia',
    rBookmarkPage: 'Saved',
    rSourcesPage: 'Sources',
    'lightTheme': 'Light Theme',
    'sepiaTheme': 'Sepia Theme',
    'darkTheme': 'Dark Theme',
    'language': 'Language',
    'latest': 'Latest',
    'more': 'More',
    'browse': 'Browse',
    'try_again': 'Retry',
    'videos': 'Videos',
    'news': 'News',
    'search': 'Search',
    'radio': 'Radio',
    'favorite': 'Saved',
    'setting': 'More',
    'contact-us': 'Contact us',
    'about': 'About us',
    'review': 'Rate our App',
    'share': 'Share our App',
  };

  static String locale(String lang, String key) {
    switch (lang) {
      case 'all':
      case 'en':
        return lEnglish[key]!;
      // case 'am':
      //   return lAmharic[key]!;
      // case 'tg':
      //   return lTigrigna[key]!;
      default:
        return lEnglish[key]!;
    }
  }
}
