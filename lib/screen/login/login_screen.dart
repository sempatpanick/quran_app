import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran_app/screen/constants/color_app.dart';
import 'package:quran_app/screen/login/login_view_model.dart';
import 'package:quran_app/screen/signup/signup_screen.dart';
import 'package:quran_app/screen/surah/surah_screen.dart';
import 'package:quran_app/utils/result_state.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Consumer<LoginViewModel>(
            builder: (context, value, child) {
              return Form(
                key: _formKey,
                child: ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(20),
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 3,
                    ),
                    TextFormField(
                      controller: _usernameController,
                      autocorrect: false,
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
                      obscureText: true,
                      autocorrect: false,
                      readOnly: value.state == ResultState.loading ? true : false,
                      validator: (value) {
                        if (value == null || value.length < 3) {
                          return "Password tidak boleh kurang dari 3 karakter";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                        prefixIconColor: Colors.white,
                        icon: Icon(Icons.password),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30,),
                    ElevatedButton(
                      onPressed: value.state == ResultState.loading ? null : () async {
                        if (_formKey.currentState!.validate()) {
                          final login = await value.login(_usernameController.text, _passwordController.text);
                          final authPref = await value.getAuthFromPreference();
                          if (authPref != null) {
                            Navigator.pushReplacementNamed(context, SurahScreen.routeName);
                          }
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(login.message),
                              )
                          );
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        shape: const StadiumBorder(),
                        side: const BorderSide(
                          width: 2.0,
                          color: Colors.blue
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
                              fontSize: 18
                            ),
                          )
                    ),
                    TextButton(
                      onPressed: () => Navigator.pushNamed(context, SignupScreen.routeName),
                      child: const Text(
                        "Create new account",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          ),
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
