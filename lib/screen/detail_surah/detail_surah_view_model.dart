import 'package:flutter/material.dart';
import 'package:quran_app/model/detail_surah_model.dart';
import 'package:quran_app/model/preference/size_view_preference.dart';

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
  final SizeViewPreference _sizeViewPref = SizeViewPreference();

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

  DetailSurahModel _surah = DetailSurahModel(code: 0, status: "", message: "", data: null);
  DetailSurahModel get surah => _surah;

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
      final DetailSurahModel result = await _quranApi.getSurah(number);
      _surah = result;
      changeState(ResultState.hasData);
    } catch(e) {
      changeState(ResultState.error);
    }
  }

  void getFavorite(int numberSurah) async {
    changeStateFavorite(ResultState.loading);
    final _auth = await _authPref.getAuth;
    _isFavorite = false;
    if (_auth != null) {
      final auth = _auth as DataAuth;
      final FavoriteModel result = await _authApi.getFavorite(auth.id, numberSurah);
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
      final _auth = await _authPref.getAuth;
      if (_auth != null) {
        final auth = _auth as DataAuth;
        final FavoriteModel result = await _authApi.addFavorite(auth.id, numberSurah);

        getFavorite(numberSurah);
        changeStateFavorite(ResultState.hasData);
        return result;
      } else {
        changeStateFavorite(ResultState.error);
        return FavoriteModel(status: false, message: "Failed to add favorite, please re-login");
      }
    } catch(e) {
      changeStateFavorite(ResultState.error);
      throw Exception(e);
    }
  }

  Future<FavoriteModel> removeFavorite(int numberSurah) async {
    changeStateFavorite(ResultState.loading);
    try {
      final _auth = await _authPref.getAuth;
      if (_auth != null) {
        final auth = _auth as DataAuth;
        final FavoriteModel result = await _authApi.removeFavorite(auth.id, numberSurah);

        getFavorite(numberSurah);
        changeStateFavorite(ResultState.hasData);
        return result;
      } else {
        changeStateFavorite(ResultState.error);
        return FavoriteModel(status: false, message: "Failed to remove favorite, please re-login");
      }
    } catch(e) {
      changeStateFavorite(ResultState.error);
      throw Exception(e);
    }
  }

  void _getSizeAyat() async {
    final double sizeAyat = await _sizeViewPref.getSizeAyat;
    _sizeAyat = sizeAyat;
    notifyListeners();
  }

  void setSizeAyat(double size) {
    _sizeViewPref.setSizeAyat(size);
    _getSizeAyat();
    notifyListeners();
  }

  void _getSizeTranslation() async {
    final double sizeTranslation = await _sizeViewPref.getSizeTranslation;
    _sizeTranslation = sizeTranslation;
    notifyListeners();
  }

  void setSizeTranslation(double size) {
    _sizeViewPref.setSizeTranslation(size);
    _getSizeTranslation();
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