import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran_app/model/detail_surah_model.dart';
import 'package:quran_app/screen/detail_surah/detail_surah_view_model.dart';
import 'package:quran_app/screen/surah/surah_view_model.dart';
import 'package:quran_app/utils/formatter.dart';
import 'package:quran_app/utils/result_state.dart';
import 'package:quran_app/widgets/circular_progress_view.dart';
import 'package:quran_app/widgets/custom_detail_item_surah.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../constants/color_app.dart';
import '../../widgets/error_view.dart';

class DetailSurahScreen extends StatefulWidget {
  static const String routeName = '/detail_surah';

  final Map<String, dynamic> dataSurah;
  const DetailSurahScreen({Key? key, required this.dataSurah})
      : super(key: key);

  @override
  State<DetailSurahScreen> createState() => _DetailSurahScreenState();
}

class _DetailSurahScreenState extends State<DetailSurahScreen>
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

  void scrolling() async {
    await Future.delayed(const Duration(seconds: 1), () async {
      await _scrollController.animateTo(widget.dataSurah['position'],
          duration: const Duration(seconds: 1), curve: Curves.easeOutExpo);
    });

    Provider.of<DetailSurahViewModel>(context, listen: false)
        .setIsScrolling(false);
  }

  @override
  void initState() {
    super.initState();
    Provider.of<DetailSurahViewModel>(context, listen: false)
        .setIsScrolling(false);

    if (widget.dataSurah['numberVerse'] != null) {
      _currentMax = widget.dataSurah['numberVerse'] + 1;
    }

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
          int max = Provider.of<DetailSurahViewModel>(context, listen: false)
              .surah
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
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      if (widget.dataSurah['position'] != null) {
        Provider.of<DetailSurahViewModel>(context, listen: false)
            .setIsScrolling(true);
      }

      Provider.of<DetailSurahViewModel>(context, listen: false)
          .getSurahById(widget.dataSurah['number']);
      Provider.of<DetailSurahViewModel>(context, listen: false)
          .getFavorite(widget.dataSurah['number']);

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
      body: Consumer<DetailSurahViewModel>(builder: (context, model, child) {
        if (model.state == ResultState.loading) {
          return const CircularProgressView();
        }

        if (model.state == ResultState.hasData) {
          if (model.surah.code == 200) {
            final PreBismillah? preBismillah = model.surah.data!.preBismillah;
            int maxVerses = model.surah.data!.verses.length;

            if (model.isScrolling) {
              scrolling();
            }

            return NestedScrollView(
              floatHeaderSlivers: true,
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                SliverAppBar(
                  floating: true,
                  snap: true,
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.black,
                  title: Text(
                    model.surah.data!.name.transliteration.id,
                    style: const TextStyle(fontSize: 16),
                  ),
                  centerTitle: true,
                  actions: [
                    IconButton(
                        onPressed: () {
                          showModalBottomSheet(
                              context: context,
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20))),
                              builder: (context) =>
                                  StatefulBuilder(builder: (context, setState) {
                                    return Consumer<DetailSurahViewModel>(
                                        builder: (context, model, child) {
                                      return Padding(
                                        padding: const EdgeInsets.all(20),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            CheckboxListTile(
                                              contentPadding: EdgeInsets.zero,
                                              value: model.isFavorite,
                                              activeColor: bgColorRedLight,
                                              onChanged: model.stateFavorite ==
                                                      ResultState.loading
                                                  ? null
                                                  : (value) {
                                                      if (model.isFavorite) {
                                                        model.removeFavorite(
                                                            widget.dataSurah[
                                                                'number']);
                                                      } else {
                                                        model.addToFavorite(
                                                            widget.dataSurah[
                                                                'number']);
                                                      }

                                                      Provider.of<SurahViewModel>(
                                                              context,
                                                              listen: false)
                                                          .getAllFavorites();
                                                    },
                                              title: const Text(
                                                "Favorite",
                                                style: TextStyle(fontSize: 14),
                                              ),
                                            ),
                                            const Text(
                                              "Ukuran Ayat",
                                              style: TextStyle(fontSize: 14),
                                            ),
                                            Slider.adaptive(
                                              value: model.sizeAyat,
                                              onChanged: (value) {
                                                model.setSizeAyat(value);
                                              },
                                              activeColor: bgColorRedLight,
                                              inactiveColor: bgColorGrey,
                                              min: 10,
                                              max: 50,
                                              divisions: 10,
                                            ),
                                            const Text(
                                              "Ukuran Terjemahan",
                                              style: TextStyle(fontSize: 14),
                                            ),
                                            Slider.adaptive(
                                              value: model.sizeTranslation,
                                              onChanged: (value) {
                                                setState(() {
                                                  model.setSizeTranslation(
                                                      value);
                                                });
                                              },
                                              activeColor: bgColorRedLight,
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
                )
              ],
              body: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                controller: _scrollController,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      if (preBismillah != null)
                        GestureDetector(
                          onTap: () async {
                            if (model.tempUrlAudio !=
                                preBismillah.audio.primary) {
                              await _audioPlayer.stop();
                              model.reset();
                            }

                            model.setAudioPlayerShow(true);
                            final play = await _audioPlayer
                                .setUrl(preBismillah.audio.primary);
                            if (play == 1) {
                              model.setTempUrlAudio(preBismillah.audio.primary);
                            }
                            await _audioPlayer.resume();
                            model.setTurnsIncrement(1 / 4);
                            _animationController.forward();
                          },
                          child: Center(
                            child: Column(
                              children: [
                                Text(
                                  preBismillah.text.arab,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: model.sizeAyat,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'IsepMisbah'),
                                ),
                                Text(
                                  preBismillah.translation.id,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: model.sizeTranslation),
                                ),
                                const Divider(),
                                const SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ListView.separated(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
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
                          final Verse ayat = model.surah.data!.verses[index];
                          return VisibilityDetector(
                            key: Key(index.toString()),
                            onVisibilityChanged: (VisibilityInfo info) {
                              if (info.visibleFraction == 1) {
                                model.setLastReadVerse([
                                  "${model.surah.data!.number}",
                                  model.surah.data!.name.transliteration.id,
                                  "${ayat.number.inSurah}",
                                  "${_scrollController.position.pixels}"
                                ]);
                              }
                            },
                            child: CustomDetailItemSurah(
                              ayat: ayat,
                              audioPlayer: _audioPlayer,
                              animationController: _animationController,
                              addon: {
                                'sizeAyat': model.sizeAyat,
                                'sizeTranslation': model.sizeTranslation
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return ErrorView(
              text: model.surah.message,
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
