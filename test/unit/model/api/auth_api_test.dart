import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:quran_app/model/api/auth_api.dart';
import 'package:quran_app/model/auth_model.dart';
import 'package:quran_app/model/favorite_model.dart';

import 'auth_api_test.mocks.dart';

@GenerateMocks([AuthApi])
void main() {
  group('Auth API', () {
    final MockAuthApi _authApi = MockAuthApi();
    test('login will returns data', () async {
      when(_authApi.login("username", "password")).thenAnswer((_) async =>
          AuthModel(
              status: true,
              message: "Success",
              data: DataAuth(
                  id: "1",
                  username: "username",
                  name: "name",
                  createdAt: "2021-04-12")));
    });

    test('sign up will returns data', () async {
      when(_authApi.signup("username", "password", "dadang"))
          .thenAnswer((_) async => AuthModel(
                status: true,
                message: "Success",
              ));
    });

    test('update profile will returns data', () async {
      when(_authApi.updateProfile("id", "username", "password", "email"))
          .thenAnswer((_) async => AuthModel(
                status: true,
                message: "Success",
              ));
    });

    test('get all favorites will returns data', () async {
      when(_authApi.getAllFavorites("id")).thenAnswer(
          (_) async => FavoriteModel(status: true, message: "message"));
    });

    test('get favorite will returns data', () async {
      when(_authApi.getFavorite("id", 1)).thenAnswer(
          (_) async => FavoriteModel(status: true, message: "message"));
    });

    test('get favorite will returns data', () async {
      when(_authApi.addFavorite("id", 1)).thenAnswer(
          (_) async => FavoriteModel(status: true, message: "message"));
    });

    test('get favorite will returns data', () async {
      when(_authApi.removeFavorite("id", 1)).thenAnswer(
          (_) async => FavoriteModel(status: true, message: "message"));
    });
  });
}
