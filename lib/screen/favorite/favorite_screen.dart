import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran_app/screen/surah/surah_view_model.dart';

import '../../model/surah_model.dart';
import '../../utils/result_state.dart';
import '../../widgets/circular_progress_view.dart';
import '../../widgets/custom_item_surah.dart';
import '../../widgets/error_view.dart';

class FavoriteScreen extends StatefulWidget {
  static const String routeName = '/favorite';

  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      Provider.of<SurahViewModel>(context, listen: false).getSurahFavorites();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Consumer<SurahViewModel>(builder: (context, model, child) {
        if (model.state == ResultState.loading) {
          return const CircularProgressView();
        }

        if (model.state == ResultState.hasData) {
          List<DataSurah> allSurahFav = [];
          for (var favorite in model.favorites) {
            for (var surah in model.surah) {
              if (favorite.numberSurah == surah.number.toString()) {
                allSurahFav.add(surah);
              }
            }
          }

          return NestedScrollView(
            floatHeaderSlivers: true,
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              const SliverAppBar(
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.black,
                floating: true,
                snap: true,
                title: Text("Favorites"),
              ),
            ],
            body: ListView.separated(
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              separatorBuilder: (context, index) {
                return const Divider();
              },
              itemCount: allSurahFav.length,
              itemBuilder: (BuildContext context, int index) {
                final DataSurah surah = allSurahFav[index];
                return CustomItemSurah(dataSurah: surah);
              },
            ),
          );
        }

        return const ErrorView(
          text: "Terjadi kesalahan saat memuat data!",
        );
      }),
    );
  }
}
