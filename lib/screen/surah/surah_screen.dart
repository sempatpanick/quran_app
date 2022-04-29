import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:quran_app/screen/constants/color_app.dart';
import 'package:quran_app/widgets/circular_progress_view.dart';
import 'package:quran_app/widgets/custom_item_surah.dart';
import 'package:quran_app/widgets/error_view.dart';
import 'package:quran_app/model/auth_model.dart';
import 'package:quran_app/model/favorite_model.dart';
import 'package:quran_app/model/surah_model.dart';
import 'package:quran_app/screen/favorite/favorite_screen.dart';
import 'package:quran_app/screen/login/login_screen.dart';
import 'package:quran_app/screen/profile/profile_screen.dart';
import 'package:quran_app/screen/surah/surah_view_model.dart';
import 'package:quran_app/utils/result_state.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

import '../login/login_view_model.dart';

class SurahScreen extends StatefulWidget {
  static const String routeName = '/surah';

  const SurahScreen({Key? key}) : super(key: key);

  @override
  State<SurahScreen> createState() => _SurahScreenState();
}

class _SurahScreenState extends State<SurahScreen> {
  TextEditingController _searchController = TextEditingController();
  DataAuth? auth;

  void _getAuthFromPreference() async {
    final _loginViewModel = Provider.of<LoginViewModel>(context, listen: false);
    final DataAuth _auth = await _loginViewModel.getAuthFromPreference();
    setState(() {
      auth = _auth;
    });
  }

  @override
  void initState() {
    _getAuthFromPreference();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      Provider.of<SurahViewModel>(context, listen: false).getAllFavorites();
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
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
                      fit: BoxFit.cover
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 30,
                          child: Center(
                            child: Text(
                              auth?.name[0] ?? "O",
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8,),
                        Text(
                          auth?.name ?? "No Name",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8,),
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
                      await Navigator.pushNamed(context, FavoriteScreen.routeName);
                      Provider.of<SurahViewModel>(context, listen: false).getAllFavorites();
                    },
                    leading: const Icon(Icons.favorite),
                    title: const Text("Favorites"),
                  ),
                  ListTile(
                    onTap: () async {
                      await Navigator.pushNamed(context, ProfileScreen.routeName);
                      _getAuthFromPreference();
                    },
                    leading: const Icon(Icons.person),
                    title: const Text("Account"),
                  ),
                  const Divider(),
                  ListTile(
                    onTap: () {
                      final loginViewModel = Provider.of<LoginViewModel>(context, listen: false);
                      loginViewModel.logout();
                      setState(() {
                        Navigator.pushReplacementNamed(context, LoginScreen.routeName);
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
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          Container(
            padding: const EdgeInsets.all(25.0),
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
                    Builder(
                      builder: (context) {
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
                            child: SvgPicture.asset('assets/svg/navigation_menu.svg'),
                          ),
                        );
                      }
                    ),
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(9.6),
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
                  ],
                ),
                const SizedBox(height: 25,),
                TextField(
                  controller: _searchController,
                  autocorrect: false,
                  maxLines: 1,
                  onChanged: (value) {
                    Provider.of<SurahViewModel>(context, listen: false).searchSurah(value);
                  },
                  decoration: const InputDecoration(
                    labelText: 'Search surah..',
                    contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                    icon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 25,),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 30),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(100))
            ),
            child: DefaultTabController(
              length: 2,
              initialIndex: 0,
              child: TabBar(
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
                tabs: const [
                  Tab(
                    child: Text(
                      "Surat",
                    ),
                  ),
                  Tab(
                    child: Text(
                      "Juz",
                    ),
                  ),
                ],
              ),
            )
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Consumer<SurahViewModel>(
              builder: (context, model, child) {
                if (model.state == ResultState.loading) {
                  return const CircularProgressView();
                }

                if (model.state == ResultState.hasData) {
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    separatorBuilder: (context, index) {
                      return const Divider();
                    },
                    itemCount: model.surah.length,
                    itemBuilder: (BuildContext context, int index) {
                      final List<DataFavorite> favorites = model.favorites;
                      final DataSurah surah = model.surah[index];
                      bool isFavorite = false;
                      if (favorites.isNotEmpty) {
                        final List<DataFavorite> favorite = favorites.where((item) => item.numberSurah.toLowerCase().contains(surah.number.toString().toLowerCase())).toList();
                        if (favorite.isNotEmpty) {
                          isFavorite = true;
                        } else {
                          isFavorite = false;
                        }
                      }
                      return CustomItemSurah(dataSurah: surah, isFavorite: isFavorite,);
                    },
                  );
                }

                return const ErrorView(text: "Terjadi kesalahan saat memuat data!",);
              }
            ),
          ),
        ],
      ),
    );
  }
}
