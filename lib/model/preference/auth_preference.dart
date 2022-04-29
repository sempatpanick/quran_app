import 'dart:convert';

import 'package:quran_app/model/auth_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthPreference {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  static const dataAuthKey = "DATA_AUTH";

  Future<dynamic> get getAuth async {
    final SharedPreferences prefs = await _prefs;

    final String? dataAuthPref = prefs.getString(dataAuthKey);

    if (dataAuthPref != null) {
      return DataAuth.fromJson(json.decode(dataAuthPref));
    } else {
      return null;
    }
  }

  void setAuth(DataAuth auth) async {
    final SharedPreferences prefs = await _prefs;

    prefs.setString(dataAuthKey, json.encode(DataAuth(id: auth.id, username: auth.username, name: auth.name, email: auth.email, createdAt: auth.createdAt).toJson()));
  }

  void removeAuth() async {
    final SharedPreferences prefs = await _prefs;

    prefs.remove(dataAuthKey);
  }
}