import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:quran_app/screen/login/login_view_model.dart';
import 'package:quran_app/screen/signup/signup_screen.dart';
import 'package:quran_app/screen/surah/surah_screen.dart';
import 'package:quran_app/utils/result_state.dart';

import '../../constants/color_app.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/login';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isPasswordVisible = false;

  void login() async {
    if (_formKey.currentState!.validate()) {
      final LoginViewModel loginViewModel = Provider.of<LoginViewModel>(context, listen: false);
      final login = await loginViewModel.login(_usernameController.text, _passwordController.text);
      final authPref = await loginViewModel.getAuthFromPreference();
      if (authPref != null) {
        Navigator.pushReplacementNamed(context, SurahScreen.routeName);
      }
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(login.message),
          )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: bgColorBlueLight,
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: SvgPicture.asset('assets/svg/login.svg'),
            ),
            Consumer<LoginViewModel>(
              builder: (context, value, child) {
                return SingleChildScrollView(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(25.0), topRight: Radius.circular(25.0))
                    ),
                    child: Form(
                      key: _formKey,
                      child: ListView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(20),
                        children: [
                          TextFormField(
                            controller: _usernameController,
                            autocorrect: false,
                            textInputAction: TextInputAction.next,
                            readOnly: value.state == ResultState.loading ? true : false,
                            validator: (value) {
                              if (value == null || value.length < 3) {
                                return "Username tidak boleh kurang dari 3 karakter";
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              labelText: 'Username',
                              contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                              icon: Icon(Icons.person),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(25)),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20,),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: !_isPasswordVisible,
                            autocorrect: false,
                            textInputAction: TextInputAction.go,
                            readOnly: value.state == ResultState.loading ? true : false,
                            onFieldSubmitted: (_) => login(),
                            validator: (value) {
                              if (value == null || value.length < 3) {
                                return "Password tidak boleh kurang dari 3 karakter";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: 'Password',
                              contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
                              prefixIconColor: Colors.white,
                              icon: const Icon(Icons.password),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                                icon: Icon(_isPasswordVisible ? Icons.visibility_off_outlined : Icons.visibility_outlined)
                              ),
                              border: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(25)),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20,),
                          ElevatedButton(
                            onPressed: value.state == ResultState.loading ? null : () => login(),
                            style: OutlinedButton.styleFrom(
                              backgroundColor: bgColorBlueLight,
                              shape: const StadiumBorder(),
                              side: const BorderSide(
                                width: 2.0,
                                color: bgColorBlueLight
                              ),
                            ),
                            child: value.state == ResultState.loading
                              ? const Padding(
                                padding: EdgeInsets.symmetric(vertical: 8.0),
                                child: CircularProgressIndicator(),
                                )
                              : const Text(
                                  "Login",
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                )
                          ),
                          const SizedBox(height: 30,),
                          Center(
                            child: RichText(
                              text: TextSpan(
                                text: 'Don\'t have an account?',
                                style: const TextStyle(
                                    color: Colors.black
                                ),
                                children: [
                                  TextSpan(
                                    text: ' Sign up',
                                    style: const TextStyle(
                                      color: bgColorBlueLight
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () => Navigator.pushNamed(context, SignupScreen.routeName)
                                  ),
                                ]
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();

    super.dispose();
  }
}
