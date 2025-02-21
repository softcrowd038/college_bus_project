import 'package:college_bus_project/custom_widgets/custom_curved_app_bar.dart';
import 'package:college_bus_project/data/api_data.dart';
import 'package:college_bus_project/login_and_registration/Model/register_model.dart';
import 'package:college_bus_project/login_and_registration/Model/user_.dart';
import 'package:college_bus_project/login_and_registration/Services/api_service.dart';
import 'package:college_bus_project/login_and_registration/Widgets/common_textform_field.dart';
import 'package:college_bus_project/login_and_registration/pages/login_registration.dart';
import 'package:college_bus_project/scanner/Components/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  late TextEditingController _usernameController = TextEditingController();
  late TextEditingController _emailController = TextEditingController();
  late TextEditingController _passwordController = TextEditingController();
  late TextEditingController _reenterpasswordController =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _usernameController = TextEditingController();
    _reenterpasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    _reenterpasswordController.dispose();
    super.dispose();
  }

  ApiService apiService = ApiService();

  Future<void> registerStudent(String username, String email, String password,
      String reEntredPassword) async {
    try {
      await apiService.registreStudent(
          context, username, email, password, reEntredPassword);
    } catch (e) {
      throw Exception('Error $e');
    }
  }

  void _updateUsername(String value) {
    Provider.of<UserModel>(context, listen: false).setUsername(value);
  }

  void _updateEmail(String value) {
    Provider.of<UserModel>(context, listen: false).setEmail(value);
  }

  void _updatePassword(String value) {
    Provider.of<UserModel>(context, listen: false).setPassword(value);
  }

  void _updatereEntredPassword(String value) {
    Provider.of<UserModel>(context, listen: false).setConfirmedPassword(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        appBar: PreferredSize(
          preferredSize:
              Size.fromHeight(MediaQuery.of(context).size.height * 0.35),
          child: ClipPath(
            clipper: CustomCurvedAppBar(),
            child: Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                          'https://img.freepik.com/free-vector/abstract-background-banner-colorful_677411-3704.jpg?t=st=1735195232~exp=1735198832~hmac=bcd605eea60725512343bb44d5a403bec18ac2a9c6da863025632ed1bd1856e9&w=360'))),
            ),
          ),
        ),
        body: Consumer<UserCredentials>(
          builder: (context, userCredentials, child) => Form(
            key: _formKey,
            child: Center(
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                          padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.height * 0.015),
                          child: Text(
                            "SIGNUP",
                            style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.025,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue),
                          )),
                      Padding(
                          padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.height * 0.015,
                              bottom:
                                  MediaQuery.of(context).size.height * 0.015,
                              right:
                                  MediaQuery.of(context).size.height * 0.015),
                          child: Text(
                            "Login And Unlock Your  Safety!",
                            style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.015,
                                fontWeight: FontWeight.w500,
                                color: Colors.black),
                          )),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.030,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.height * 0.015,
                          right: MediaQuery.of(context).size.height * 0.015,
                          bottom: MediaQuery.of(context).size.height * 0.010,
                        ),
                        child: CommonTextFormfield(
                          onChanged: (value) {
                            _updateUsername(value);
                          },
                          label: "Username",
                          hint: "Sam@1102",
                          obscure: false,
                          fillColor: Colors.white,
                          controller: _usernameController,
                          suffixIcon: const Icon(
                            Icons.person,
                            color: Colors.black,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Enter the Username first!";
                            }

                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.height * 0.015,
                          right: MediaQuery.of(context).size.height * 0.015,
                          bottom: MediaQuery.of(context).size.height * 0.010,
                        ),
                        child: CommonTextFormfield(
                          onChanged: (value) {
                            _updateEmail(value);
                          },
                          label: "Email",
                          hint: "xyz@abc.pqr",
                          obscure: false,
                          controller: _emailController,
                          fillColor: Colors.white,
                          suffixIcon: const Icon(
                            Icons.email,
                            color: Colors.black,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Enter the Email first!";
                            }
                            if (!regexemail.hasMatch(value)) {
                              return "Enter Valid Email Format!";
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.height * 0.015,
                          right: MediaQuery.of(context).size.height * 0.015,
                          bottom: MediaQuery.of(context).size.height * 0.015,
                        ),
                        child: CommonTextFormfield(
                          onChanged: (value) {
                            _updatePassword(value);
                          },
                          label: "Password",
                          hint: "MNop1234@#",
                          obscure: true,
                          controller: _passwordController,
                          fillColor: Colors.white,
                          suffixIcon: const Icon(
                            Icons.key,
                            color: Colors.black,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Enter the Password first!";
                            }
                            if (value.length < 8) {
                              return "Password is too short, Enter up to 8 digits!";
                            }
                            if (!regexpassword.hasMatch(value)) {
                              return "Use Alphabets(capital and small), symbols and numbers in the password";
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.height * 0.015,
                          right: MediaQuery.of(context).size.height * 0.015,
                          bottom: MediaQuery.of(context).size.height * 0.015,
                        ),
                        child: CommonTextFormfield(
                          onChanged: (value) {
                            _updatereEntredPassword(value);
                          },
                          label: "Confirm Password",
                          hint: "MNop1234@#",
                          obscure: true,
                          controller: _reenterpasswordController,
                          fillColor: Colors.white,
                          suffixIcon: const Icon(
                            Icons.key,
                            color: Colors.black,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Enter the Password first!";
                            }
                            if (value.length < 8) {
                              return "Password is too short, Enter up to 8 digits!";
                            }
                            if (_reenterpasswordController.text !=
                                _passwordController.text) {
                              return "Password is not matching";
                            }
                            if (!regexpassword.hasMatch(value)) {
                              return "Use Alphabets(capital and small), symbols and numbers in the password";
                            }
                            return null;
                          },
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            registerStudent(
                                _usernameController.text,
                                _emailController.text,
                                _passwordController.text,
                                _reenterpasswordController.text);
                          }
                        },
                        child: const CustomButton(
                          color: Colors.blue,
                          buttonText: "SignUp",
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Already have an account? '),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) => const LoginPage()));
                            },
                            child: const Text(
                              'Sign in',
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w700),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
