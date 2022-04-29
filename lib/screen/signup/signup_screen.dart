import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran_app/screen/signup/signup_view_model.dart';

import '../../utils/result_state.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Consumer<SignupViewModel>(
              builder: (context, value, child) {
                return Form(
                  key: _formKey,
                  child: ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(20),
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 4,
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
                            border: OutlineInputBorder()
                        ),
                      ),
                      const SizedBox(height: 20,),
                      TextFormField(
                        controller: _nameController,
                        autocorrect: false,
                        readOnly: value.state == ResultState.loading ? true : false,
                        validator: (value) {
                          if (value == null || value.length < 3) {
                            return "Nama tidak boleh kurang dari 3 karakter";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                            labelText: 'Name',
                            border: OutlineInputBorder()
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
                            border: OutlineInputBorder()
                        ),
                      ),
                      const SizedBox(height: 30,),
                      ElevatedButton(
                          onPressed: value.state == ResultState.loading ? null : () async {
                            if (_formKey.currentState!.validate()) {
                              final signupViewModel = Provider.of<SignupViewModel>(context, listen: false);

                              final signup = await signupViewModel.signup(_usernameController.text, _passwordController.text, _nameController.text);
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(signup.message),
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
                                  "Sign Up",
                                  style: TextStyle(
                                      fontSize: 18
                                  ),
                                )
                      ),
                      TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Already have an account?")
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
    _nameController.dispose();
    super.dispose();
  }
}
