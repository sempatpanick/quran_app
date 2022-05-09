import 'package:flutter/material.dart';
import 'package:quran_app/model/detail_ayat_model.dart';
import 'package:quran_app/model/juz_model.dart';

import '../../model/api/quran_api.dart';
import '../../utils/result_state.dart';

class DetailJuzViewModel extends ChangeNotifier {
  final QuranApi _quranApi = QuranApi();

  ResultState _state = ResultState.loading;
  ResultState get state => _state;

  int _tempCounterNumberInQuran = 0;

  int _counterSurahInJuz = 0;
  int get counterSurahInJuz => _counterSurahInJuz;

  JuzModel _juz = JuzModel(code: 0, status: "", message: "", data: null);
  JuzModel get juz => _juz;

  void getJuzById(int numberSurahLast, int id) async {
    changeState(ResultState.loading);
    try {
      final JuzModel result = await _quranApi.getJuzById(id);
      _juz = result;
      final DetailAyatModel ayatLast = await _getDetailAyat(numberSurahLast, result.data!.verses.last.number.inSurah + 1);
      if (ayatLast.code == 200) {
        final VerseJuz ayat = VerseJuz.fromJson(ayatLast.data!.toJson());
        _juz.data!.verses.add(ayat);
      }
      setNumberInQuran(result.data!.verses.first.number.inQuran);
      changeState(ResultState.hasData);
    } catch(e) {
      changeState(ResultState.error);
    }
  }

  Future<DetailAyatModel> _getDetailAyat(int numberSurah, int number) async {
    try {
      final DetailAyatModel result = await _quranApi.getDetailAyatBySurahNumber(numberSurah, number);
      return result;
    } catch(e) {
      return DetailAyatModel(code: 500, status: "Failed", message: "Terjadi kesalahan saat mengambil data");
    }
  }

  void setNumberInQuran(int numberInQuran) {
    _tempCounterNumberInQuran = numberInQuran;
    notifyListeners();
  }

  void incrementCounter(int numberInQuran) {
    if (_tempCounterNumberInQuran != numberInQuran) {
      _tempCounterNumberInQuran = numberInQuran;
      _counterSurahInJuz = _counterSurahInJuz + 1;
      notifyListeners();
    }
  }

  void resetCounter() {
    _counterSurahInJuz = 0;
    notifyListeners();
  }

  void changeState(ResultState s) {
    _state = s;
    notifyListeners();
  }
}