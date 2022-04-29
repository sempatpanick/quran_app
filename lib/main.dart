import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran_app/model/preference/auth_preference.dart';
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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AuthPreference _auth = AuthPreference();
  var _dataAuth = await _auth.getAuth;
  String route;
  if (_dataAuth != null) {
    route = SurahScreen.routeName;
  } else {
    route = LoginScreen.routeName;
  }
  runApp(MyApp(route: route,));
}

class MyApp extends StatelessWidget {
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
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: route,
        routes: {
          SurahScreen.routeName: (_) => const SurahScreen(),
          DetailSurahScreen.routeName: (context) => DetailSurahScreen(
            dataSurah: ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>,
          ),
          FavoriteScreen.routeName: (_) => const FavoriteScreen(),
          LoginScreen.routeName: (_) => const LoginScreen(),
          SignupScreen.routeName: (_) => const SignupScreen(),
          ProfileScreen.routeName: (_) => const ProfileScreen(),
        },
      ),
    );
  }
}