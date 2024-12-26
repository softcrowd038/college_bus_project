import 'package:college_bus_project/custom_widgets/custom_curved_app_bar.dart';
import 'package:college_bus_project/data/api_data.dart';
import 'package:college_bus_project/login_and_registration/Model/user_.dart';
import 'package:college_bus_project/login_and_registration/Services/api_service.dart';
import 'package:college_bus_project/login_and_registration/Widgets/common_textform_field.dart';
import 'package:college_bus_project/scanner/Components/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController _emailController = TextEditingController();
  late TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  ApiService apiService = ApiService();

  Future<void> loginStudent(String email, String password) async {
    try {
      await apiService.loginStudent(context, email, password);
    } catch (e) {
      throw Exception('Error $e');
    }
  }

  void _updateEmail(String value) {
    Provider.of<UserCredentials>(context, listen: false).setEmail(value);
  }

  void _updatePassword(String value) {
    Provider.of<UserCredentials>(context, listen: false).setPassword(value);
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
                            "SIGNIN",
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
                            _updateEmail(value);
                          },
                          label: "Email",
                          hint: "xyz@abc.pqr",
                          obscure: false,
                          controller: _emailController,
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
                      GestureDetector(
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            loginStudent(_emailController.text,
                                _passwordController.text);
                          }
                        },
                        child: const CustomButton(
                          color: Colors.blue,
                          buttonText: "SignIn",
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
