import 'package:shared_preferences/shared_preferences.dart';

class SettingPreference {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  static const sizeAyatKey = 'SIZE_AYAT';
  static const sizeTranslationKey = 'SIZE_TRANSLATION';
  static const lastReadVerseKey = 'LAST_READ_VERSE';

  Future<double> get getSizeAyat async {
    final SharedPreferences prefs = await _prefs;

    final double? sizeAyatPref = prefs.getDouble(sizeAyatKey);

    if (sizeAyatPref == null) {
      return 18;
    }

    return sizeAyatPref;
  }

  void setSizeAyat(double sizeAyat) async {
    final SharedPreferences prefs = await _prefs;

    prefs.setDouble(sizeAyatKey, sizeAyat);
  }

  Future<double> get getSizeTranslation async {
    final SharedPreferences prefs = await _prefs;

    final double? sizeTranslationPref = prefs.getDouble(sizeTranslationKey);

    if (sizeTranslationPref == null) {
      return 20;
    }

    return sizeTranslationPref;
  }

  void setSizeTranslation(double sizeTranslation) async {
    final SharedPreferences prefs = await _prefs;

    prefs.setDouble(sizeTranslationKey, sizeTranslation);
  }

  Future<List<String>> get getLastReadVerse async {
    final SharedPreferences prefs = await _prefs;

    final List<String>? lastReadVerse = prefs.getStringList(lastReadVerseKey);

    if (lastReadVerse == null) {
      return [];
    }

    return lastReadVerse;
  }

  void setLastReadVerse(List<String> verse) async {
    final SharedPreferences prefs = await _prefs;

    prefs.setStringList(lastReadVerseKey, verse);
  }

  void removeLastReadVerse() async {
    final SharedPreferences prefs = await _prefs;

    prefs.remove(lastReadVerseKey);
  }
}
