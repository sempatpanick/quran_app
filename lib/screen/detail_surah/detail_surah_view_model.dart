import 'package:flutter/material.dart';
import 'package:quran_app/model/detail_surah_model.dart';
import 'package:quran_app/model/preference/setting_preference.dart';

import '../../model/api/auth_api.dart';
import '../../model/api/quran_api.dart';
import '../../model/auth_model.dart';
import '../../model/favorite_model.dart';
import '../../model/preference/auth_preference.dart';
import '../../utils/result_state.dart';

class DetailSurahViewModel extends ChangeNotifier {
  final QuranApi _quranApi = QuranApi();
  final AuthApi _authApi = AuthApi();
  final AuthPreference _authPref = AuthPreference();
  final SettingPreference _settingPref = SettingPreference();

  ResultState _state = ResultState.loading;
  ResultState get state => _state;

  ResultState _stateFavorite = ResultState.none;
  ResultState get stateFavorite => _stateFavorite;

  bool _isFavorite = false;
  bool get isFavorite => _isFavorite;

  double _sizeAyat = 0;
  double get sizeAyat => _sizeAyat;

  double _sizeTranslation = 0;
  double get sizeTranslation => _sizeTranslation;

  List<String> _lastReadVerse = [];
  List<String> get lastReadVerse => _lastReadVerse;

  DetailSurahModel _surah =
      DetailSurahModel(code: 0, status: "", message: "", data: null);
  DetailSurahModel get surah => _surah;

  bool _isScrolling = false;
  bool get isScrolling => _isScrolling;

  double _turns = 0.0;
  double get turns => _turns;

  bool _isPlaying = false;
  bool get isPlaying => _isPlaying;

  bool _isAudioPlayerShow = false;
  bool get isAudioPlayerShow => _isAudioPlayerShow;

  Duration _durationAudio = Duration.zero;
  Duration get durationAudio => _durationAudio;

  Duration _positionAudio = Duration.zero;
  Duration get positionAudio => _positionAudio;

  String _tempUrlAudio = "";
  String get tempUrlAudio => _tempUrlAudio;

  DetailSurahViewModel() {
    _getSizeAyat();
    _getSizeTranslation();
  }

  void getSurahById(int number) async {
    changeState(ResultState.loading);
    try {
      final DetailSurahModel result = await _quranApi.getSurahById(number);
      _surah = result;
      changeState(ResultState.hasData);
    } catch (e) {
      changeState(ResultState.error);
    }
  }

  void getFavorite(int numberSurah) async {
    changeStateFavorite(ResultState.loading);
    final authPref = await _authPref.getAuth;
    _isFavorite = false;
    if (authPref != null) {
      final auth = authPref as DataAuth;
      final FavoriteModel result =
          await _authApi.getFavorite(auth.id, numberSurah);
      if (result.status) {
        if (result.data!.isNotEmpty) {
          _isFavorite = true;
          changeStateFavorite(ResultState.hasData);
        }
      }
    }
    changeStateFavorite(ResultState.none);
  }

  Future<FavoriteModel> addToFavorite(int numberSurah) async {
    changeStateFavorite(ResultState.loading);
    try {
      final authPref = await _authPref.getAuth;

      if (authPref == null) {
        changeStateFavorite(ResultState.error);
        return FavoriteModel(
            status: false, message: "Failed to add favorite, please re-login");
      }

      final auth = authPref as DataAuth;
      final FavoriteModel result =
          await _authApi.addFavorite(auth.id, numberSurah);

      getFavorite(numberSurah);
      changeStateFavorite(ResultState.hasData);
      return result;
    } catch (e) {
      changeStateFavorite(ResultState.error);
      throw Exception(e);
    }
  }

  Future<FavoriteModel> removeFavorite(int numberSurah) async {
    changeStateFavorite(ResultState.loading);
    try {
      final authPref = await _authPref.getAuth;

      if (authPref == null) {
        changeStateFavorite(ResultState.error);
        return FavoriteModel(
            status: false,
            message: "Failed to remove favorite, please re-login");
      }

      final auth = authPref as DataAuth;
      final FavoriteModel result =
          await _authApi.removeFavorite(auth.id, numberSurah);

      getFavorite(numberSurah);
      changeStateFavorite(ResultState.hasData);
      return result;
    } catch (e) {
      changeStateFavorite(ResultState.error);
      throw Exception(e);
    }
  }

  void _getSizeAyat() async {
    final double sizeAyat = await _settingPref.getSizeAyat;
    _sizeAyat = sizeAyat;
    notifyListeners();
  }

  void setSizeAyat(double size) {
    _settingPref.setSizeAyat(size);
    _getSizeAyat();
  }

  void _getSizeTranslation() async {
    final double sizeTranslation = await _settingPref.getSizeTranslation;
    _sizeTranslation = sizeTranslation;
    notifyListeners();
  }

  void setSizeTranslation(double size) {
    _settingPref.setSizeTranslation(size);
    _getSizeTranslation();
  }

  void getLastReadVerse() async {
    final List<String> lastReadVersePref = await _settingPref.getLastReadVerse;
    _lastReadVerse = lastReadVersePref;
    notifyListeners();
  }

  void setLastReadVerse(List<String> verse) {
    _settingPref.setLastReadVerse(verse);
    getLastReadVerse();
  }

  void removeLastReadVerse() {
    _settingPref.removeLastReadVerse();
    getLastReadVerse();
  }

  void setIsScrolling(bool isScrolling) {
    _isScrolling = isScrolling;
    notifyListeners();
  }

  void changeState(ResultState s) {
    _state = s;
    notifyListeners();
  }

  void changeStateFavorite(ResultState s) {
    _stateFavorite = s;
    notifyListeners();
  }

  void reset() {
    _isPlaying = false;
    _isAudioPlayerShow = false;
    _positionAudio = Duration.zero;
    _durationAudio = Duration.zero;
    notifyListeners();
  }

  void setTurnsIncrement(double turns) {
    _turns += turns;
    notifyListeners();
  }

  void setTurnsDecrement(double turns) {
    _turns -= turns;
    notifyListeners();
  }

  void setPlaying(bool state) {
    _isPlaying = state;
    notifyListeners();
  }

  void setAudioPlayerShow(bool state) {
    _isAudioPlayerShow = state;
    notifyListeners();
  }

  void setDurationAudio(Duration duration) {
    _durationAudio = duration;
    notifyListeners();
  }

  void setPositionAudio(Duration duration) {
    _positionAudio = duration;
    notifyListeners();
  }

  void setTempUrlAudio(String url) {
    _tempUrlAudio = url;
    notifyListeners();
  }
}
