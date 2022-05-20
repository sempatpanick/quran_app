import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:quran_app/screen/signup/signup_view_model.dart';

import '../../constants/color_app.dart';
import '../../utils/result_state.dart';
import '../login/login_view_model.dart';
import '../surah/surah_screen.dart';

class SignupScreen extends StatefulWidget {
  static const String routeName = '/signup';

  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  bool _isPasswordVisible = false;

  void signup() async {
    if (_formKey.currentState!.validate()) {
      final signupViewModel =
          Provider.of<SignupViewModel>(context, listen: false);
      final LoginViewModel loginViewModel =
          Provider.of<LoginViewModel>(context, listen: false);
      final scaffoldMessenger = ScaffoldMessenger.of(context);
      final navigator = Navigator.of(context);

      final signup = await signupViewModel.signup(_usernameController.text,
          _passwordController.text, _nameController.text);

      if (signup.status) {
        await loginViewModel.login(
            _usernameController.text, _passwordController.text);
        final authPref = await loginViewModel.getAuthFromPreference();
        if (authPref != null) {
          navigator.pushReplacementNamed(SurahScreen.routeName);
        }
      }

      scaffoldMessenger.showSnackBar(SnackBar(
        content: Text(signup.message),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              backgroundColor: Colors.transparent,
              floating: true,
              leading: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  )),
            )
          ];
        },
        body: SingleChildScrollView(
          child: Consumer<SignupViewModel>(builder: (context, value, child) {
            return Center(
              child: Form(
                key: _formKey,
                child: ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(20),
                  children: [
                    SvgPicture.asset(
                      'assets/svg/register.svg',
                      height: 200,
                    ),
                    const Text(
                      "Sign Up",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    TextFormField(
                      controller: _usernameController,
                      autocorrect: false,
                      textInputAction: TextInputAction.next,
                      readOnly:
                          value.state == ResultState.loading ? true : false,
                      validator: (value) {
                        if (value == null || value.length < 3) {
                          return "Username tidak boleh kurang dari 3 karakter";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Username',
                        prefixIcon: Icon(Icons.person_outline),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _nameController,
                      autocorrect: false,
                      textInputAction: TextInputAction.next,
                      readOnly:
                          value.state == ResultState.loading ? true : false,
                      validator: (value) {
                        if (value == null || value.length < 3) {
                          return "Nama tidak boleh kurang dari 3 karakter";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        prefixIcon: Icon(Icons.face),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: !_isPasswordVisible,
                      autocorrect: false,
                      textInputAction: TextInputAction.send,
                      readOnly:
                          value.state == ResultState.loading ? true : false,
                      onFieldSubmitted: (_) => signup(),
                      validator: (value) {
                        if (value == null || value.length < 3) {
                          return "Password tidak boleh kurang dari 3 karakter";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.password),
                        suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                            icon: Icon(_isPasswordVisible
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined)),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                        onPressed: value.state == ResultState.loading
                            ? null
                            : () => signup(),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: bgColorBlueLight,
                          shape: const StadiumBorder(),
                          side: const BorderSide(
                              width: 2.0, color: bgColorBlueLight),
                        ),
                        child: value.state == ResultState.loading
                            ? const Padding(
                                padding: EdgeInsets.symmetric(vertical: 8.0),
                                child: CircularProgressIndicator(),
                              )
                            : const Text(
                                "Sign Up",
                                style: TextStyle(fontSize: 18),
                              )),
                    const SizedBox(
                      height: 30,
                    ),
                    Center(
                      child: RichText(
                        text: TextSpan(
                            text: 'Already have an account?',
                            style: const TextStyle(color: Colors.black),
                            children: [
                              TextSpan(
                                  text: ' Login',
                                  style:
                                      const TextStyle(color: bgColorBlueLight),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () => Navigator.pop(context)),
                            ]),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }
}
