import 'package:flutter/material.dart';
import 'package:quran_app/model/auth_model.dart';

import '../../model/api/auth_api.dart';
import '../../utils/result_state.dart';

class SignupViewModel extends ChangeNotifier {
  final AuthApi _authApi = AuthApi();

  ResultState _state = ResultState.hasData;
  ResultState get state => _state;

  void changeState(ResultState s) {
    _state = s;
    notifyListeners();
  }

  Future<AuthModel> signup(String username, String password, String name) async {
    changeState(ResultState.loading);
    try {
      final AuthModel result = await _authApi.signup(username, password, name);

      if (!result.status) {
        changeState(ResultState.error);
        return AuthModel(status: false, message: result.message);
      }

      changeState(ResultState.hasData);
      return result;
    } catch(e) {
      changeState(ResultState.error);
      return AuthModel(status: false, message: "Failed to sign up");
    }
  }
}