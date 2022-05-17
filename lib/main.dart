import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran_app/model/juz_list_model.dart';
import 'package:quran_app/model/preference/auth_preference.dart';
import 'package:quran_app/screen/detail_juz/detail_juz_screen.dart';
import 'package:quran_app/screen/detail_juz/detail_juz_view_model.dart';
import 'package:quran_app/screen/detail_surah/detail_surah_screen.dart';
import 'package:quran_app/screen/detail_surah/detail_surah_view_model.dart';
import 'package:quran_app/screen/favorite/favorite_screen.dart';
import 'package:quran_app/screen/login/login_screen.dart';
import 'package:quran_app/screen/login/login_view_model.dart';
import 'package:quran_app/screen/profile/profile_screen.dart';
import 'package:quran_app/screen/profile/profile_view_model.dart';
import 'package:quran_app/screen/signup/signup_screen.dart';
import 'package:quran_app/screen/signup/signup_view_model.dart';
import 'package:quran_app/screen/surah/surah_screen.dart';
import 'package:quran_app/screen/surah/surah_view_model.dart';
import 'package:quran_app/widgets/custom_page_route_fade_transition.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AuthPreference auth = AuthPreference();
  var dataAuth = await auth.getAuth;
  String route;
  if (dataAuth != null) {
    route = SurahScreen.routeName;
  } else {
    route = LoginScreen.routeName;
  }
  runApp(MyApp(
    route: route,
  ));
}

class MyApp extends StatelessWidget {
  static GlobalKey materialAppKey = GlobalKey();
  final String route;
  const MyApp({Key? key, required this.route}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => SurahViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => DetailSurahViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => DetailJuzViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => LoginViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => SignupViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => ProfileViewModel(),
        ),
      ],
      child: MaterialApp(
        key: MyApp.materialAppKey,
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: route,
        onGenerateRoute: (setting) {
          if (setting.name == SurahScreen.routeName) {
            return CustomPageRouteFadeTransition(
              const SurahScreen(),
            );
          }
          if (setting.name == DetailSurahScreen.routeName) {
            return CustomPageRouteFadeTransition(
              DetailSurahScreen(
                dataSurah: setting.arguments as Map<String, dynamic>,
              ),
            );
          }
          if (setting.name == DetailJuzScreen.routeName) {
            return CustomPageRouteFadeTransition(
              DetailJuzScreen(
                dataJuz: setting.arguments as DataJuzList,
              ),
            );
          }
          if (setting.name == FavoriteScreen.routeName) {
            return CustomPageRouteFadeTransition(
              const FavoriteScreen(),
            );
          }
          if (setting.name == LoginScreen.routeName) {
            return CustomPageRouteFadeTransition(
              const LoginScreen(),
            );
          }
          if (setting.name == SignupScreen.routeName) {
            return CustomPageRouteFadeTransition(
              const SignupScreen(),
            );
          }
          if (setting.name == ProfileScreen.routeName) {
            return CustomPageRouteFadeTransition(
              const ProfileScreen(),
            );
          }
          return null;
        },
      ),
    );
  }
}
