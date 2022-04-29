import 'package:dio/dio.dart';
import 'package:quran_app/model/auth_model.dart';

import '../favorite_model.dart';

class AuthApi {
  final Dio _dio = Dio();
  final String _mainUrl = 'https://api.ddg.my.id/quran';

  Future<AuthModel> login(String username, String password) async {
    try {
      final Response response = await _dio.post(
          "$_mainUrl/login.php",
          data: {
            "username": username,
            "password": password
          }
      );

      return AuthModel.fromJson(response.data);
    } catch(e) {
      return AuthModel(status: false, message: 'Failed to login!');
    }
  }

  Future<AuthModel> signup(String username, String password, String name) async {
    try {
      final Response response = await _dio.post(
          "$_mainUrl/signup.php",
          data: {
            'username': username,
            'password': password,
            'name': name
          }
      );

      return AuthModel.fromJson(response.data);
    } catch(e) {
      return AuthModel(status: false, message: 'Failed to signup!');
    }
  }

  Future<AuthModel> updateProfile(String idUser, String username, String name, String email) async {
    try {
      final Response response = await _dio.post(
          "$_mainUrl/update_profile.php",
          data: {
            "id_user": idUser,
            "username": username,
            "name": name,
            "email": email
          }
      );

      return AuthModel.fromJson(response.data);
    } catch(e) {
      return AuthModel(status: false, message: 'Failed to update profile!');
    }
  }

  Future<FavoriteModel> getAllFavorites(String idUser) async {
    try {
      final Response response = await _dio.get(
          "$_mainUrl/favorite.php?id_user=$idUser&order_type=DESC"
      );

      return FavoriteModel.fromJson(response.data);
    } catch(e) {
      return FavoriteModel(status: false, message: 'Failed to get favorites!');
    }
  }

  Future<FavoriteModel> getFavorite(String idUser, int numberSurah) async {
    try {
      final Response response = await _dio.get(
          "$_mainUrl/favorite.php?id_user=$idUser&number_surah=$numberSurah"
      );

      return FavoriteModel.fromJson(response.data);
    } catch(e) {
      return FavoriteModel(status: false, message: 'Failed to get favorites!');
    }
  }

  Future<FavoriteModel> addFavorite(String idUser, int numberSurah) async {
    try {
      final Response response = await _dio.post(
          "$_mainUrl/favorite.php",
          data: {
            "id_user": idUser,
            "number_surah": numberSurah
          }
      );

      return FavoriteModel.fromJson(response.data);
    } catch(e) {
      return FavoriteModel(status: false, message: 'Failed to add favorite!');
    }
  }

  Future<FavoriteModel> removeFavorite(String idUser, int numberSurah) async {
    try {
      final Response response = await _dio.post(
          "$_mainUrl/delete_favorite.php",
          data: {
            "id_user": idUser,
            "number_surah": numberSurah
          }
      );

      return FavoriteModel.fromJson(response.data);
    } catch(e) {
      return FavoriteModel(status: false, message: 'Failed to delete favorite!');
    }
  }
}