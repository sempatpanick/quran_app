import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:quran_app/screen/login/login_screen.dart';
import 'package:quran_app/screen/login/login_view_model.dart';
import 'package:quran_app/screen/signup/signup_screen.dart';
import 'package:quran_app/screen/signup/signup_view_model.dart';

Widget _createLoginScreen() => MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => LoginViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => SignupViewModel(),
        ),
      ],
      child: MaterialApp(
        initialRoute: LoginScreen.routeName,
        routes: {
          LoginScreen.routeName: (_) => const LoginScreen(),
          SignupScreen.routeName: (_) => const SignupScreen(),
        },
      ),
    );

void main() {
  group('Status', () {
    testWidgets('Pada halaman login harus terdapat text usernamme dan password',
        (WidgetTester tester) async {
      await tester.pumpWidget(_createLoginScreen());
      await tester.pumpAndSettle();

      expect(find.text('Username'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
    });
  });
}
