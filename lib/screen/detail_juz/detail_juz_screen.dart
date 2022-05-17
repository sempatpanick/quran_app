import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran_app/model/detail_surah_model.dart';
import 'package:quran_app/model/juz_list_model.dart';
import 'package:quran_app/model/juz_model.dart';
import 'package:quran_app/screen/detail_juz/detail_juz_view_model.dart';

import '../../constants/color_app.dart';
import '../../utils/formatter.dart';
import '../../utils/result_state.dart';
import '../../widgets/circular_progress_view.dart';
import '../../widgets/custom_detail_item_surah.dart';
import '../../widgets/error_view.dart';
import '../detail_surah/detail_surah_view_model.dart';

class DetailJuzScreen extends StatefulWidget {
  static const String routeName = '/detail_juz';

  final DataJuzList dataJuz;
  const DetailJuzScreen({Key? key, required this.dataJuz}) : super(key: key);

  @override
  State<DetailJuzScreen> createState() => _DetailJuzScreenState();
}

class _DetailJuzScreenState extends State<DetailJuzScreen>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late AnimationController _animationController;
  final AudioPlayer _audioPlayer = AudioPlayer();

  int _currentMax = 10;
  Color customBlackColor = const Color.fromARGB(255, 53, 53, 53);
  Color customWhiteColor = const Color.fromARGB(255, 237, 237, 237);

  void _getMoreData() {
    _currentMax += 10;
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          int max = Provider.of<DetailJuzViewModel>(context, listen: false)
              .juz
              .data!
              .verses
              .length;
          setState(() {
            if (_currentMax + 10 < max) {
              _getMoreData();
            } else {
              _currentMax = max;
            }
          });
        });
      }
    });
  }

  @override
  void didChangeDependencies() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<DetailJuzViewModel>(context, listen: false).resetCounter();
      Provider.of<DetailJuzViewModel>(context, listen: false).getJuzById(
          widget.dataJuz.verseMapping.last.numberSurah,
          widget.dataJuz.juzNumber);

      final DetailSurahViewModel detailSurahViewModel =
          Provider.of<DetailSurahViewModel>(context, listen: false);

      detailSurahViewModel.reset();

      _audioPlayer.onPlayerStateChanged.listen((state) {
        detailSurahViewModel.setPlaying(state == PlayerState.PLAYING);
        if (state == PlayerState.COMPLETED) {
          detailSurahViewModel.setTurnsDecrement(1 / 4);
          _animationController.reverse();
        }
      });

      _audioPlayer.onDurationChanged.listen((currentDuration) {
        detailSurahViewModel.setDurationAudio(currentDuration);
      });

      _audioPlayer.onAudioPositionChanged.listen((currentPosition) {
        detailSurahViewModel.setPositionAudio(currentPosition);
      });
    });
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar:
          Consumer<DetailSurahViewModel>(builder: (context, model, child) {
        if (model.isAudioPlayerShow) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(25.0)),
                color: Colors.grey[50],
                boxShadow: [
                  BoxShadow(
                      blurRadius: 20.0,
                      offset: const Offset(5, -5),
                      color: Colors.grey[400]!),
                  const BoxShadow(
                      blurRadius: 20.0,
                      offset: Offset(-5, 5),
                      color: Colors.white)
                ]),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: model.durationAudio != Duration.zero
                      ? () async {
                          if (model.isPlaying) {
                            model.setTurnsDecrement(1 / 4);
                            _animationController.reverse();
                            await _audioPlayer.pause();
                          } else {
                            model.setTurnsIncrement(1 / 4);
                            _animationController.forward();
                            await _audioPlayer.resume();
                          }
                          model.setPlaying(!model.isPlaying);
                        }
                      : null,
                  child: AnimatedContainer(
                    curve: Curves.easeOutExpo,
                    duration: const Duration(milliseconds: 500),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25.0),
                        color: customWhiteColor,
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 30.0,
                              offset: model.isPlaying
                                  ? const Offset(5, -5)
                                  : const Offset(5, 5),
                              color: Colors.grey),
                          BoxShadow(
                              blurRadius: 30.0,
                              offset: model.isPlaying
                                  ? const Offset(-5, 5)
                                  : const Offset(-5, -5),
                              color: Colors.white)
                        ]),
                    child: SizedBox(
                      height: 40,
                      width: 40,
                      child: Center(
                        child: model.durationAudio != Duration.zero
                            ? AnimatedIcon(
                                icon: AnimatedIcons.play_pause,
                                progress: _animationController,
                                size: 20,
                                color: customBlackColor,
                              )
                            : const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: CircularProgressIndicator(),
                              ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Slider(
                          value: model.positionAudio.inSeconds.toDouble(),
                          min: 0,
                          max: model.durationAudio.inSeconds.toDouble(),
                          onChanged: (value) async {
                            final newPosition =
                                Duration(seconds: value.toInt());
                            await _audioPlayer.seek(newPosition);

                            if (model.isPlaying) {
                              model.setTurnsIncrement(1 / 4);
                              _animationController.forward();
                            } else {
                              model.setTurnsDecrement(1 / 4);
                              _animationController.reverse();
                            }

                            await _audioPlayer.resume();
                          }),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(Formatter.time(model.positionAudio)),
                            Text(Formatter.time(model.durationAudio)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    await _audioPlayer.stop();
                    model.setAudioPlayerShow(false);
                  },
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          );
        } else {
          return const SizedBox();
        }
      }),
      body: Consumer2<DetailJuzViewModel, DetailSurahViewModel>(
          builder: (context, modelDetailJuz, modelDetailSurah, child) {
        if (modelDetailJuz.state == ResultState.loading) {
          return const CircularProgressView();
        }

        if (modelDetailJuz.state == ResultState.hasData) {
          if (modelDetailJuz.juz.code == 200) {
            final DataJuz dataJuz = modelDetailJuz.juz.data!;
            int maxVerses = dataJuz.verses.length;

            return SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                controller: _scrollController,
                child: ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(Icons.arrow_back)),
                          Text(
                            "Juz ${widget.dataJuz.juzNumber}",
                            style: const TextStyle(fontSize: 16),
                          ),
                          IconButton(
                              onPressed: () {
                                showModalBottomSheet(
                                    context: context,
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(20))),
                                    builder: (context) => StatefulBuilder(
                                            builder: (context, setState) {
                                          return Consumer<DetailSurahViewModel>(
                                              builder: (context, model, child) {
                                            return Padding(
                                              padding: const EdgeInsets.all(20),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    "Ukuran Ayat",
                                                    style:
                                                        TextStyle(fontSize: 14),
                                                  ),
                                                  Slider.adaptive(
                                                    value: model.sizeAyat,
                                                    onChanged: (value) {
                                                      model.setSizeAyat(value);
                                                    },
                                                    activeColor:
                                                        bgColorRedLight,
                                                    inactiveColor: bgColorGrey,
                                                    min: 10,
                                                    max: 50,
                                                    divisions: 10,
                                                  ),
                                                  const Text(
                                                    "Ukuran Terjemahan",
                                                    style:
                                                        TextStyle(fontSize: 14),
                                                  ),
                                                  Slider.adaptive(
                                                    value:
                                                        model.sizeTranslation,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        model
                                                            .setSizeTranslation(
                                                                value);
                                                      });
                                                    },
                                                    activeColor:
                                                        bgColorRedLight,
                                                    inactiveColor: bgColorGrey,
                                                    min: 10,
                                                    max: 50,
                                                    divisions: 10,
                                                  ),
                                                ],
                                              ),
                                            );
                                          });
                                        }));
                              },
                              icon: const Icon(Icons.settings)),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        separatorBuilder: (BuildContext context, int index) {
                          return const Divider();
                        },
                        itemCount: maxVerses < 10 ? maxVerses : _currentMax + 1,
                        itemBuilder: (context, index) {
                          if (index == maxVerses) {
                            return const SizedBox();
                          }
                          if (index == _currentMax) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          final VerseJuz verseJuz = dataJuz.verses[index];
                          final Map<String, dynamic> jsonJuz =
                              verseJuz.toJson();
                          final Verse ayat = Verse.fromJson(jsonJuz);
                          return CustomDetailItemSurah(
                            ayat: ayat,
                            audioPlayer: _audioPlayer,
                            animationController: _animationController,
                            addon: {
                              'sizeAyat': modelDetailSurah.sizeAyat,
                              'sizeTranslation':
                                  modelDetailSurah.sizeTranslation
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return ErrorView(
              text: modelDetailJuz.juz.message,
            );
          }
        }

        return const ErrorView(
          text: "Terjadi kesalahan saat memuat data!",
        );
      }),
    );
  }
}
