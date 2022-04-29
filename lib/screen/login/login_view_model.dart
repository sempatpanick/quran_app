import 'package:flutter/material.dart';
import 'package:quran_app/model/api/auth_api.dart';
import 'package:quran_app/model/auth_model.dart';
import 'package:quran_app/model/preference/auth_preference.dart';

import '../../utils/result_state.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthApi _authApi = AuthApi();
  final AuthPreference _authPreference = AuthPreference();

  ResultState _state = ResultState.none;
  ResultState get state => _state;

  void changeState(ResultState s) {
    _state = s;
    notifyListeners();
  }

  Future<AuthModel> login(String username, String password) async {
    changeState(ResultState.loading);
    try {
      final AuthModel result = await _authApi.login(username, password);

      if (result.status) {
        _authPreference.setAuth(result.data!);
        changeState(ResultState.hasData);
        return result;
      } else {
        changeState(ResultState.error);
        return AuthModel(status: false, message: result.message);
      }
    } catch(e) {
      changeState(ResultState.error);
      return AuthModel(status: false, message: "Failed to login");
    }
  }

  Future<dynamic> getAuthFromPreference() async {
    try {
      final auth = await _authPreference.getAuth;

      return auth;
    } catch(e) {
      throw Exception(e);
    }
  }

  void logout() {
    _authPreference.removeAuth();
  }
}