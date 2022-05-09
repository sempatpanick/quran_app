import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran_app/model/detail_surah_model.dart';
import 'package:quran_app/screen/detail_surah/detail_surah_view_model.dart';

import '../constants/color_app.dart';

class CustomDetailItemSurah extends StatelessWidget {
  final Verse ayat;
  final AudioPlayer audioPlayer;
  final AnimationController animationController;
  final Map<String, dynamic> addon;
  const CustomDetailItemSurah(
      {Key? key,
      required this.ayat,
      required this.audioPlayer,
      required this.animationController,
      required this.addon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () async {
        final DetailSurahViewModel _detailSurahViewModel =
            Provider.of<DetailSurahViewModel>(context, listen: false);

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
      title: Row(
        children: [
          Text("${ayat.number.inSurah}"),
          const SizedBox(
            width: 20,
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                  color: bgColorBlueSea,
                  borderRadius: BorderRadius.circular(25.0),
                  border: Border.all(color: bgColorBlueLight)),
              child: Text(
                ayat.text.arab,
                textAlign: TextAlign.end,
                style: TextStyle(
                    fontSize: addon['sizeAyat'] ?? 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'IsepMisbah'),
              ),
            ),
          ),
        ],
      ),
      subtitle: Text(
        ayat.translation.id,
        textAlign: TextAlign.start,
        style: TextStyle(fontSize: addon['sizeTranslation'] ?? 16),
      ),
    );
  }
}
