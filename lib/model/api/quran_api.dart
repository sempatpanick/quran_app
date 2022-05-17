import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:quran_app/model/detail_ayat_model.dart';
import 'package:quran_app/model/detail_surah_model.dart';
import 'package:quran_app/model/juz_model.dart';
import 'package:quran_app/model/surah_model.dart';

class QuranApi {
  final _dio = Dio();
  final _mainUrl = 'https://api.quran.sutanlab.id';

  Future<SurahModel> getAllSurah() async {
    try {
      final response = await _dio.get(
        '$_mainUrl/surah',
      );

      try {
        final SurahModel surah =
            SurahModel.fromJson(json.decode(response.data));
        return surah;
      } catch (e) {
        return SurahModel.fromJson(response.data);
      }
    } on DioError catch (_) {
      return SurahModel(
          code: 500,
          status: "Failed",
          message: "Terjadi kesalahan saat mengambil data",
          data: []);
    }
  }

  Future<DetailSurahModel> getSurahById(int number) async {
    try {
      final response = await _dio.get(
        '$_mainUrl/surah/$number',
      );

      try {
        final DetailSurahModel detailSurah =
            DetailSurahModel.fromJson(json.decode(response.data));
        return detailSurah;
      } catch (e) {
        return DetailSurahModel.fromJson(response.data);
      }
    } on DioError catch (_) {
      return DetailSurahModel(
          code: 500,
          status: "Failed",
          message: "Terjadi kesalahan saat mengambil data",
          data: null);
    }
  }

  Future<DetailAyatModel> getDetailVerseBySurahNumber(
      int numberSurah, int number) async {
    try {
      final response = await _dio.get(
        '$_mainUrl/surah/$numberSurah/$number',
      );

      try {
        final DetailAyatModel detailAyat =
            DetailAyatModel.fromJson(json.decode(response.data));
        return detailAyat;
      } catch (e) {
        return DetailAyatModel.fromJson(response.data);
      }
    } on DioError catch (_) {
      return DetailAyatModel(
          code: 500,
          status: 'Failed',
          message: "Terjadi kesalahan saat mengambil data");
    }
  }

  Future<JuzModel> getJuzById(int id) async {
    try {
      final response = await _dio.get(
        '$_mainUrl/juz/$id',
      );

      try {
        final JuzModel detailJuz =
            JuzModel.fromJson(json.decode(response.data));
        return detailJuz;
      } catch (e) {
        return JuzModel.fromJson(response.data);
      }
    } on DioError catch (_) {
      return JuzModel(
          code: 500,
          status: "Failed",
          message: "Terjadi kesalahan saat mengambil data",
          data: null);
    }
  }
}
