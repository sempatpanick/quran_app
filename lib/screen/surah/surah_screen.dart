import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:quran_app/model/auth_model.dart';
import 'package:quran_app/model/surah_model.dart';
import 'package:quran_app/screen/detail_juz/detail_juz_screen.dart';
import 'package:quran_app/screen/detail_surah/detail_surah_screen.dart';
import 'package:quran_app/screen/detail_surah/detail_surah_view_model.dart';
import 'package:quran_app/screen/favorite/favorite_screen.dart';
import 'package:quran_app/screen/login/login_screen.dart';
import 'package:quran_app/screen/profile/profile_screen.dart';
import 'package:quran_app/screen/surah/surah_view_model.dart';
import 'package:quran_app/utils/category_state.dart';
import 'package:quran_app/utils/result_state.dart';
import 'package:quran_app/widgets/circular_progress_view.dart';
import 'package:quran_app/widgets/custom_item_surah.dart';
import 'package:quran_app/widgets/error_view.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

import '../../constants/color_app.dart';
import '../../model/juz_list_model.dart';
import '../login/login_view_model.dart';

class SurahScreen extends StatefulWidget {
  static const String routeName = '/surah';

  const SurahScreen({Key? key}) : super(key: key);

  @override
  State<SurahScreen> createState() => _SurahScreenState();
}

class _SurahScreenState extends State<SurahScreen>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late TabController _tabController;
  DataAuth? auth;

  void _getAuthFromPreference() async {
    final loginViewModel = Provider.of<LoginViewModel>(context, listen: false);
    final DataAuth authPref = await loginViewModel.getAuthFromPreference();
    setState(() {
      auth = authPref;
    });
  }

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: 2);
    _getAuthFromPreference();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      Provider.of<SurahViewModel>(context, listen: false)
          .changeCategoryState(CategoryState.surah);
      Provider.of<SurahViewModel>(context, listen: false).getListJuzFromJson();
      Provider.of<SurahViewModel>(context, listen: false).getAllFavorites();
      Provider.of<DetailSurahViewModel>(context, listen: false)
          .getLastReadVerse();
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      drawerEdgeDragWidth: MediaQuery.of(context).size.width / 5,
      drawer: Drawer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              child: DrawerHeader(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/bgdemo.jpg"),
                      fit: BoxFit.cover),
                ),
                child: SafeArea(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 30,
                          child: Center(
                            child: Text(
                              auth?.name[0] ?? "G",
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          auth?.name ?? "Guest",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          auth?.email ?? "",
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  ListTile(
                    onTap: () async {
                      Navigator.pop(context);
                      final SurahViewModel surahViewModel =
                          Provider.of<SurahViewModel>(context, listen: false);

                      await Navigator.pushNamed(
                          context, FavoriteScreen.routeName);
                      surahViewModel.getAllFavorites();
                    },
                    leading: const Icon(Icons.favorite),
                    title: const Text("Favorites"),
                  ),
                  ListTile(
                    onTap: () async {
                      Navigator.pop(context);
                      await Navigator.pushNamed(
                          context, ProfileScreen.routeName);
                      _getAuthFromPreference();
                    },
                    leading: const Icon(Icons.person),
                    title: const Text("Account"),
                  ),
                  const Divider(),
                  ListTile(
                    onTap: () {
                      final LoginViewModel loginViewModel =
                          Provider.of<LoginViewModel>(context, listen: false);
                      final DetailSurahViewModel detailSurahViewModel =
                          Provider.of<DetailSurahViewModel>(context,
                              listen: false);
                      detailSurahViewModel.removeLastReadVerse();
                      loginViewModel.logout();
                      setState(() {
                        Navigator.pushReplacementNamed(
                            context, LoginScreen.routeName);
                      });
                    },
                    leading: const Icon(Icons.logout),
                    title: const Text("Logout"),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            automaticallyImplyLeading: false,
            floating: true,
            snap: true,
            toolbarHeight: 101,
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.black,
            titleSpacing: 0,
            title: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 25.0, horizontal: 10.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Builder(builder: (context) {
                        return InkWell(
                          onTap: () {
                            setState(() {
                              Scaffold.of(context).openDrawer();
                            });
                          },
                          child: Container(
                            height: 50,
                            width: 50,
                            padding: const EdgeInsets.all(15),
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(25.0),
                                bottomLeft: Radius.circular(25.0),
                              ),
                              color: bgColorGrey,
                            ),
                            child: SvgPicture.asset(
                                'assets/svg/navigation_menu.svg'),
                          ),
                        );
                      }),
                      Consumer<SurahViewModel>(
                          builder: (context, model, child) {
                        return Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: TextField(
                              controller: _searchController,
                              autocorrect: false,
                              maxLines: 1,
                              autofocus: false,
                              onChanged: (value) {
                                model.searchSurah(value);
                                _tabController.animateTo(0);
                              },
                              decoration: InputDecoration(
                                labelText: 'Search surah..',
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                suffixIcon: model.isSearching
                                    ? IconButton(
                                        onPressed: () {
                                          _searchController.clear();
                                          model.searchSurah('');
                                          FocusScopeNode currentFocus =
                                              FocusScope.of(context);
                                          if (!currentFocus.hasPrimaryFocus) {
                                            currentFocus.unfocus();
                                          }
                                        },
                                        icon: const Icon(Icons.clear))
                                    : null,
                                prefixIcon: const Icon(Icons.search),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: bgColorBlueLight),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(25)),
                                ),
                                border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(25)),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                      InkWell(
                        onTap: () async {
                          await Navigator.pushNamed(
                              context, ProfileScreen.routeName);
                          _getAuthFromPreference();
                        },
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: bgColorGrey,
                          ),
                          child: Center(
                            child: ClipOval(
                              child: Text(
                                auth?.name[0] ?? "O",
                                style: const TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
        body: ListView(
          padding: const EdgeInsets.only(top: 25.0),
          physics: const BouncingScrollPhysics(),
          children: [
            Consumer<DetailSurahViewModel>(
              builder: (context, model, child) {
                if (model.lastReadVerse.isEmpty) {
                  return const SizedBox();
                }

                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, DetailSurahScreen.routeName,
                        arguments: {
                          'number': int.parse(model.lastReadVerse[0]),
                          'title': model.lastReadVerse[1],
                          'numberVerse': int.parse(model.lastReadVerse[2]),
                          'position': double.parse(model.lastReadVerse[3])
                        });
                  },
                  child: Container(
                    margin:
                        const EdgeInsets.only(left: 30, right: 30, bottom: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: bgColorBlue,
                      border: Border.all(color: bgColorRedLight),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Terakhir dibaca :',
                          style: TextStyle(
                            color: Colors.grey[200],
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              model.lastReadVerse[1],
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Ayat: ${model.lastReadVerse[2]}",
                              style: TextStyle(
                                  color: Colors.grey[200],
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
            Container(
                margin: const EdgeInsets.symmetric(horizontal: 30),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(100))),
                child:
                    Consumer<SurahViewModel>(builder: (context, model, child) {
                  return DefaultTabController(
                    length: 2,
                    initialIndex:
                        model.categoryState == CategoryState.surah ? 0 : 1,
                    child: TabBar(
                      controller: _tabController,
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.black,
                      padding: const EdgeInsets.all(8.0),
                      indicator: RectangularIndicator(
                        color: bgColorBlueLight,
                        bottomLeftRadius: 100,
                        bottomRightRadius: 100,
                        topLeftRadius: 100,
                        topRightRadius: 100,
                      ),
                      indicatorColor: bgColorBlueLight,
                      onTap: (int index) {
                        if (index == 0) {
                          Provider.of<SurahViewModel>(context, listen: false)
                              .changeCategoryState(CategoryState.surah);
                        } else {
                          Provider.of<SurahViewModel>(context, listen: false)
                              .changeCategoryState(CategoryState.juz);
                        }
                      },
                      tabs: const [
                        Tab(
                          child: Text(
                            "Surah",
                          ),
                        ),
                        Tab(
                          child: Text(
                            "Juz",
                          ),
                        ),
                      ],
                    ),
                  );
                })),
            Consumer<SurahViewModel>(builder: (context, model, child) {
              if (model.state == ResultState.loading) {
                return const CircularProgressView();
              }

              if (model.state == ResultState.hasData) {
                if (model.categoryState == CategoryState.surah) {
                  return ListView.separated(
                    padding: const EdgeInsets.all(20),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    separatorBuilder: (context, index) {
                      return const Divider();
                    },
                    itemCount: model.surah.length,
                    itemBuilder: (BuildContext context, int index) {
                      final DataSurah surah = model.surah[index];
                      return CustomItemSurah(
                        dataSurah: surah,
                      );
                    },
                  );
                }

                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  separatorBuilder: (context, index) {
                    return const Divider();
                  },
                  itemCount: model.juz.length,
                  itemBuilder: (context, index) {
                    final DataJuzList juz = model.juz[index];

                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, DetailJuzScreen.routeName,
                            arguments: juz);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          "Juz ${juz.juzNumber}",
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    );
                  },
                );
              }

              return const ErrorView(
                text: "Terjadi kesalahan saat memuat data!",
              );
            }),
          ],
        ),
      ),
    );
  }
}
