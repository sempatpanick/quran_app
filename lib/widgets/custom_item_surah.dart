import 'package:edge_alerts/edge_alerts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:quran_app/model/surah_model.dart';
import 'package:quran_app/screen/detail_surah/detail_surah_screen.dart';
import 'package:quran_app/screen/surah/surah_view_model.dart';

import '../constants/color_app.dart';

class CustomItemSurah extends StatelessWidget {
  final DataSurah dataSurah;
  final bool isFavorite;
  const CustomItemSurah(
      {Key? key, required this.dataSurah, required this.isFavorite})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: ValueKey(dataSurah.number),
      endActionPane: ActionPane(
        motion: const StretchMotion(),
        children: [
          isFavorite
              ? SlidableAction(
                  onPressed: (contexts) async {
                    final surahViewModel =
                        Provider.of<SurahViewModel>(context, listen: false);
                    final favorite =
                        await surahViewModel.removeFavorite(dataSurah.number);

                    edgeAlert(context,
                        title: favorite.status ? 'Success' : 'Gagal',
                        description: favorite.message,
                        gravity: Gravity.top,
                        backgroundColor:
                            favorite.status ? Colors.green : bgColorRedLight);
                  },
                  icon: Icons.delete_forever,
                  label: "Delete from Favorite",
                  backgroundColor: Colors.redAccent,
                  spacing: 1,
                )
              : SlidableAction(
                  onPressed: (contexts) async {
                    final surahViewModel =
                        Provider.of<SurahViewModel>(context, listen: false);
                    final favorite =
                        await surahViewModel.addToFavorite(dataSurah.number);

                    edgeAlert(context,
                        title: favorite.status ? 'Success' : 'Gagal',
                        description: favorite.message,
                        gravity: Gravity.top,
                        backgroundColor:
                            favorite.status ? Colors.green : bgColorRedLight);
                  },
                  icon: Icons.favorite,
                  label: "Add to Favorite",
                  backgroundColor: Colors.green,
                  spacing: 1,
                ),
        ],
      ),
      child: ListTile(
        onTap: () {
          Navigator.pushNamed(context, DetailSurahScreen.routeName, arguments: {
            'number': dataSurah.number,
            'title': dataSurah.name.transliteration.id
          });
        },
        title: Text(
          dataSurah.name.transliteration.id,
          textAlign: TextAlign.start,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          "${dataSurah.name.translation.id} (${dataSurah.numberOfVerses})",
          textAlign: TextAlign.start,
        ),
        trailing: Text(
          dataSurah.name.short,
          textAlign: TextAlign.end,
          style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'IsepMisbah'),
        ),
      ),
    );
  }
}
