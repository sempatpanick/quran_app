import 'package:flutter_test/flutter_test.dart';
import 'package:quran_app/screen/surah/surah_view_model.dart';
import 'package:quran_app/utils/result_state.dart';

void main() {
  group('Surah View Model', () {
    final _surahViewModel = SurahViewModel();
    test('from result state loading to change state surah view model return result state', () {
      expect(ResultState.loading, _surahViewModel.state);

      _surahViewModel.changeState(ResultState.hasData);
      expect(ResultState.hasData, _surahViewModel.state);

      _surahViewModel.changeState(ResultState.error);
      expect(ResultState.error, _surahViewModel.state);
    });
  });
}