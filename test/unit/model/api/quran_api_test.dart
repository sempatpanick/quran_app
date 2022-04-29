import 'package:flutter_test/flutter_test.dart';
import 'package:quran_app/model/api/quran_api.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:quran_app/model/surah_model.dart';

import 'quran_api_test.mocks.dart';

@GenerateMocks([QuranApi])
void main() {
  group('Quran API', () {
    final MockQuranApi _quranApi = MockQuranApi();
    test('get all surah returns data', () async {
      when(_quranApi.getAllSurah()).thenAnswer((_) async =>
        SurahModel(code: 200, status: "Success", message: "Success get surah", data: [])
      );
    });
  });
}