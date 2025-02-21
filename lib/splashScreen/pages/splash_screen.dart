// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:college_bus_project/Navigation/page_navigation.dart';
import 'package:college_bus_project/login_and_registration/pages/login_registration.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        navigationWidget();
      }
    });
  }

  void navigationWidget() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? authToken = sharedPreferences.getString('auth_token');

    if (authToken != null) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const HomePage()));
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const LoginPage()));
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: Center(
        child: Image(
          image: NetworkImage(
              "https://t3.ftcdn.net/jpg/02/14/29/22/360_F_214292295_dsMiBAa83bToIrvyKXeXDJyZtaK0S2bv.jpg"),
          height: 250,
          width: 250,
        ),
      ),
    );
  }
}
