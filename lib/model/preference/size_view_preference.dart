import 'package:shared_preferences/shared_preferences.dart';

class SizeViewPreference {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  static const sizeAyatKey = 'SIZE_AYAT';
  static const sizeTranslationKey = 'SIZE_TRANSLATION';

  Future<double> get getSizeAyat async {
    final SharedPreferences prefs = await _prefs;

    final double? sizeAyatPref = prefs.getDouble(sizeAyatKey);

    if (sizeAyatPref != null) {
      return sizeAyatPref;
    } else {
      return 16;
    }
  }

  void setSizeAyat(double sizeAyat) async {
    final SharedPreferences prefs = await _prefs;

    prefs.setDouble(sizeAyatKey, sizeAyat);
  }

  Future<double> get getSizeTranslation async {
    final SharedPreferences prefs = await _prefs;

    final double? sizeTranslationPref = prefs.getDouble(sizeTranslationKey);

    if (sizeTranslationPref != null) {
      return sizeTranslationPref;
    } else {
      return 16;
    }
  }

  void setSizeTranslation(double sizeTranslation) async {
    final SharedPreferences prefs = await _prefs;

    prefs.setDouble(sizeTranslationKey, sizeTranslation);
  }
}