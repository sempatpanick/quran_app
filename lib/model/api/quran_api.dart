import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:quran_app/model/detail_surah_model.dart';
import 'package:quran_app/model/surah_model.dart';

class QuranApi {
  final _dio = Dio();
  final _mainUrl = 'https://api.quran.sutanlab.id/surah';

  Future<SurahModel> getAllSurah() async {
    try {
      final response = await _dio.get(
        _mainUrl,
      );

      try {
        final SurahModel surah = SurahModel.fromJson(json.decode(response.data));
        return surah;
      } catch (e) {
        return SurahModel.fromJson(response.data);
      }
    } on DioError catch (e) {
      return SurahModel(code: 500, status: "Failed", message: "Terjadi kesalahan saat mengambil data", data: []);
    }
  }

  Future<DetailSurahModel> getSurah(int number) async {
    try {
      final response = await _dio.get(
        '$_mainUrl/$number',
      );

      try {
        final DetailSurahModel detailSurah = DetailSurahModel.fromJson(json.decode(response.data.toString()));
        return detailSurah;
      } catch (e) {
        return DetailSurahModel.fromJson(response.data);
      }
    } on DioError catch (e) {
      return DetailSurahModel(code: 500, status: "Failed", message: "Terjadi kesalahan saat mengambil data", data: null);
    }
  }
}