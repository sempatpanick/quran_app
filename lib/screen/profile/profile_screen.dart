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
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<ProfileViewModel>(context, listen: false)
          .getAuthFromPreference();
    });
    super.didChangeDependencies();
  }

  void update() async {
    if (_formKey.currentState!.validate()) {
      if (_usernameController.text.isNotEmpty &&
          _nameController.text.isNotEmpty) {
        final ProfileViewModel profileViewModel =
            Provider.of<ProfileViewModel>(context, listen: false);
        final scaffoldMessenger = ScaffoldMessenger.of(context);

        final profile = await profileViewModel.updateProfile(
            profileViewModel.dataAuth.id,
            _usernameController.text,
            _nameController.text,
            _emailController.text);

        scaffoldMessenger.showSnackBar(SnackBar(
          content: Text(profile.message),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Username dan nama tidak boleh kosong"),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              backgroundColor: Colors.white,
              floating: true,
              title: const Text(
                "Update Profile",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.normal),
              ),
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
          child: Column(
            children: [
              Consumer<ProfileViewModel>(builder: (context, model, child) {
                _usernameController.text = model.dataAuth.username;
                _nameController.text = model.dataAuth.name;
                _emailController.text = model.dataAuth.email ?? "";

                return Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Image.asset(
                            "assets/images/form.jpg",
                            height: 300,
                          ),
                        ),
                        const Text(
                          "Update Profile",
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        TextFormField(
                          controller: _usernameController,
                          autocorrect: false,
                          textInputAction: TextInputAction.next,
                          readOnly:
                              model.state == ResultState.loading ? true : false,
                          validator: (value) {
                            if (value == null || value.length < 3) {
                              return "Username tidak boleh kurang dari 3 karakter";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              labelText: "Username",
                              prefixIcon: const Icon(Icons.person_outline),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              )),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: _nameController,
                          autocorrect: false,
                          textInputAction: TextInputAction.next,
                          readOnly:
                              model.state == ResultState.loading ? true : false,
                          validator: (value) {
                            if (value == null || value.length < 3) {
                              return "Nama tidak boleh kurang dari 3 karakter";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              labelText: "Name",
                              prefixIcon: const Icon(Icons.face),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              )),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          autocorrect: false,
                          textInputAction: TextInputAction.send,
                          readOnly:
                              model.state == ResultState.loading ? true : false,
                          onFieldSubmitted: (_) => update(),
                          validator: (value) {
                            if (value == null || value.length < 3) {
                              return "Email tidak boleh kurang dari 3 karakter";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              labelText: "Email",
                              prefixIcon: const Icon(Icons.email_outlined),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              )),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Center(
                          child: ElevatedButton(
                              onPressed: model.state == ResultState.loading
                                  ? null
                                  : () => update(),
                              child: model.state == ResultState.loading
                                  ? const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 8.0),
                                      child: CircularProgressIndicator(),
                                    )
                                  : const Text("Update Profile")),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
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
