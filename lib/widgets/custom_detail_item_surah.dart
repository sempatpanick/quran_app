import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran_app/model/detail_surah_model.dart';
import 'package:quran_app/screen/detail_surah/detail_surah_view_model.dart';

class CustomDetailItemSurah extends StatelessWidget {
  final Verse ayat;
  final Map<String, double> sizeView;
  final AudioPlayer audioPlayer;
  final AnimationController animationController;
  const CustomDetailItemSurah({Key? key, required this.ayat, required this.sizeView, required this.audioPlayer, required this.animationController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () async {
        final DetailSurahViewModel _detailSurahViewModel = Provider.of<DetailSurahViewModel>(context, listen: false);

        if (_detailSurahViewModel.tempUrlAudio != ayat.audio.primary) {
          await audioPlayer.stop();
          _detailSurahViewModel.reset();
        }

        _detailSurahViewModel.setAudioPlayerShow(true);
        final play = await audioPlayer.setUrl(ayat.audio.primary);
        if (play == 1) {
          _detailSurahViewModel.setTempUrlAudio(ayat.audio.primary);
        }
        await audioPlayer.resume();
        _detailSurahViewModel.setTurnsDecrement(1 / 4);
        animationController.forward();
      },
      title: Text(
        ayat.text.arab,
        textAlign: TextAlign.end,
        style: TextStyle(
          fontSize: sizeView['ayat'] ?? 16,
          fontWeight: FontWeight.bold
        ),
      ),
      contentPadding: const EdgeInsets.only(left: 20),
      subtitle: Text(
        ayat.translation.id,
        textAlign: TextAlign.end,
        style: TextStyle(
          fontSize: sizeView['translation'] ?? 16
        ),
      ),
      trailing: Text("${ayat.number.inSurah}"),
    );
  }
}
