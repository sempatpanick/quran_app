import 'package:flutter/material.dart';

import '../../model/api/auth_api.dart';
import '../../model/auth_model.dart';
import '../../model/preference/auth_preference.dart';
import '../../utils/result_state.dart';

class ProfileViewModel extends ChangeNotifier {
  final AuthApi _authApi = AuthApi();
  final AuthPreference _authPreference = AuthPreference();

  ResultState _state = ResultState.none;
  ResultState get state => _state;

  DataAuth _dataAuth = DataAuth(id: "", username: "", name: "", createdAt: "", email: null);
  DataAuth get dataAuth => _dataAuth;

  void changeState(ResultState s) {
    _state = s;
    notifyListeners();
  }

  Future<AuthModel> updateProfile(String idUser, String username, String name, String email) async {
    changeState(ResultState.loading);
    try {
      final AuthModel result = await _authApi.updateProfile(idUser, username, name, email);

      if (result.status) {
        _authPreference.setAuth(result.data!);
        getAuthFromPreference();
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

  void getAuthFromPreference() async {
      final auth = await _authPreference.getAuth;

      _dataAuth = auth;
      notifyListeners();
  }
}