import 'package:shared_preferences/shared_preferences.dart';

class UiBloc {
  late SharedPreferences prefs;

  String lang = 'all';

  void init() {
    checkLanguage();
  }

  void changeLanguage(String ln) async {
    lang = ln;
    await prefs.setString('lang', lang);
  }

  void checkLanguage() async {
    prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('lang')) {
      if (prefs.getString('lang') != null) {
        lang = prefs.getString('lang')!;
      }
      prefs.setString('lang', lang);
    }
    prefs.setString('lang', lang);
  }
}
