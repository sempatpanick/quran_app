import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran_app/screen/profile/profile_view_model.dart';

import '../../utils/result_state.dart';

class ProfileScreen extends StatefulWidget {
  static const String routeName = '/profile';

  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void didChangeDependencies() {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      Provider.of<ProfileViewModel>(context, listen: false).getAuthFromPreference();
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Update Profile"
        ),
      ),
      body: Consumer<ProfileViewModel>(
        builder: (context, model, child) {
          _usernameController.text = model.dataAuth.username;
          _nameController.text = model.dataAuth.name;
          _emailController.text = model.dataAuth.email ?? "";

          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                TextFormField(
                  controller: _usernameController,
                  autocorrect: false,
                  readOnly: model.state == ResultState.loading ? true : false,
                  validator: (value) {
                    if (value == null || value.length < 3) {
                      return "Username tidak boleh kurang dari 3 karakter";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                      labelText: "Username",
                      border: OutlineInputBorder()
                  ),
                ),
                const SizedBox(height: 20,),
                TextFormField(
                  controller: _nameController,
                  autocorrect: false,
                  readOnly: model.state == ResultState.loading ? true : false,
                  validator: (value) {
                    if (value == null || value.length < 3) {
                      return "Nama tidak boleh kurang dari 3 karakter";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                      labelText: "Name",
                      border: OutlineInputBorder()
                  ),
                ),
                const SizedBox(height: 20,),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  readOnly: model.state == ResultState.loading ? true : false,
                  validator: (value) {
                    if (value == null || value.length < 3) {
                      return "Email tidak boleh kurang dari 3 karakter";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                      labelText: "Email",
                      border: OutlineInputBorder()
                  ),
                ),
                const SizedBox(height: 20,),
                ElevatedButton(
                    onPressed: model.state == ResultState.loading ? null : () async {
                      if (_formKey.currentState!.validate()) {
                        if (_usernameController.text.isNotEmpty &&
                            _nameController.text.isNotEmpty) {
                          final profile = await model.updateProfile(
                              model.dataAuth.id, _usernameController.text,
                              _nameController.text, _emailController.text);
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(profile.message),
                              )
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    "Username dan nama tidak boleh kosong"),
                              )
                          );
                        }
                      }
                    },
                    child: model.state == ResultState.loading
                        ? const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: CircularProgressIndicator(),
                          )
                        : const Text("Update Profile")
                ),
              ],
            ),
          );
        }
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _nameController.dispose();
    _emailController.dispose();

    super.dispose();
  }
}
