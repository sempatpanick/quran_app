import 'package:flutter/material.dart';
import 'package:quran_app/model/api/auth_api.dart';
import 'package:quran_app/model/api/quran_api.dart';
import 'package:quran_app/model/auth_model.dart';
import 'package:quran_app/model/favorite_model.dart';
import 'package:quran_app/model/preference/auth_preference.dart';
import 'package:quran_app/model/surah_model.dart';
import 'package:quran_app/utils/result_state.dart';

class SurahViewModel extends ChangeNotifier {
  final QuranApi _quranApi = QuranApi();
  final AuthApi _authApi = AuthApi();
  final AuthPreference _authPref = AuthPreference();

  ResultState _state = ResultState.loading;
  ResultState get state => _state;

  ResultState _stateFavorite = ResultState.none;
  ResultState get stateFavorite => _stateFavorite;

  List<DataSurah> _tempSurah = [];

  List<DataSurah> _surah = [];
  List<DataSurah> get surah => _surah;

  final List<DataSurah> _surahFavorites = [];
  List<DataSurah> get surahFavorites => _surahFavorites;

  List<DataFavorite> _favorites = [];
  List<DataFavorite> get favorites => _favorites;

  SurahViewModel() {
    getAllSurah();
  }

  void getAllSurah() async {
    changeState(ResultState.loading);
    try {
      final SurahModel result = await _quranApi.getAllSurah();
      _tempSurah = result.data;
      _surah = _tempSurah;
      changeState(ResultState.hasData);
    } catch(e) {
      changeState(ResultState.error);
    }
  }

  void searchSurah(String query) async {
    changeState(ResultState.loading);

    List<DataSurah> search = _tempSurah.where(
      (surah) =>
        surah.name.transliteration.id.toLowerCase().contains(query.toLowerCase())
        || surah.name.transliteration.en.toLowerCase().contains(query.toLowerCase())
        || surah.name.transliteration.id.toLowerCase().contains(query.toLowerCase())
        || surah.name.translation.id.toLowerCase().contains(query.toLowerCase())
        || surah.name.translation.en.toLowerCase().contains(query.toLowerCase())
        || surah.name.long.toLowerCase().contains(query.toLowerCase())
        || surah.tafsir.id.toLowerCase().contains(query.toLowerCase())
    ).toList();
    _surah = search;
    changeState(ResultState.hasData);
  }

  void getAllFavorites() async {
    final _auth = await _authPref.getAuth;
    if (_auth != null) {
      final auth = _auth as DataAuth;
      final FavoriteModel result = await _authApi.getAllFavorites(auth.id);
      if (result.status) {
        _favorites = result.data!;
        notifyListeners();
      }
    }
  }

  Future<FavoriteModel> addToFavorite(int numberSurah) async {
    changeStateFavorite(ResultState.loading);
    try {
      final _auth = await _authPref.getAuth;
      if (_auth != null) {
        final auth = _auth as DataAuth;
        final FavoriteModel result = await _authApi.addFavorite(auth.id, numberSurah);

        getAllFavorites();
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

        getAllFavorites();
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

  void getSurahFavorites() {
    List<DataSurah> _allSurahFav = [];
    for (var favorite in _favorites) {
      for (var surah in _tempSurah) {
        if (favorite.numberSurah == surah.number.toString()) {
          _allSurahFav.add(surah);
        }
      }
    }
    _surahFavorites.clear();
    _surahFavorites.addAll(_allSurahFav);
  }

  void changeState(ResultState s) {
    _state = s;
    notifyListeners();
  }

  void changeStateFavorite(ResultState s) {
    _stateFavorite = s;
    notifyListeners();
  }
}