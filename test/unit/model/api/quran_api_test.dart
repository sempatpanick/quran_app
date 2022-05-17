import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:quran_app/model/api/quran_api.dart';
import 'package:quran_app/model/detail_ayat_model.dart';
import 'package:quran_app/model/detail_surah_model.dart';
import 'package:quran_app/model/juz_model.dart';
import 'package:quran_app/model/surah_model.dart';

import 'quran_api_test.mocks.dart';

@GenerateMocks([QuranApi])
void main() {
  group('Quran API', () {
    final MockQuranApi _quranApi = MockQuranApi();

    test('get all surah returns data', () async {
      when(_quranApi.getAllSurah()).thenAnswer((_) async => SurahModel(
          code: 200,
          status: "Success",
          message: "Success get surah",
          data: []));
    });

    test('get surah by id returns data detail surah', () async {
      when(_quranApi.getSurahById(1)).thenAnswer((_) async => DetailSurahModel(
          code: 200,
          status: "Success",
          message: "Success get surah",
          data: DataDetailSurah(
              number: 1,
              sequence: 2,
              numberOfVerses: 7,
              name: NameDetailSurah(
                  short: "Surah",
                  long: "Surah Long",
                  transliteration: TranslationDetailSurah(en: "en", id: "id"),
                  translation: TranslationDetailSurah(en: "en", id: "id")),
              revelation:
                  RevelationDetailSurah(arab: "arab", en: "en", id: "id"),
              tafsir: DataTafsirDetailSurah(id: "id"),
              verses: [])));
    });

    test('get detail verse by surah number returns data', () async {
      when(_quranApi.getDetailVerseBySurahNumber(1, 2)).thenAnswer((_) async =>
          DetailAyatModel(
              code: 200, status: "Success", message: "Success get data"));
    });

    test('get juz by id returns data detail surah returns data', () async {
      when(_quranApi.getJuzById(1)).thenAnswer((_) async =>
          JuzModel(code: 200, status: "Success", message: "Success get surah"));
    });
  });
}
