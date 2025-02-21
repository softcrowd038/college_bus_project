// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:convert';
import 'package:college_bus_project/Emergency/Models/profile_model.dart';
import 'package:college_bus_project/Emergency/Provider/student_profile_provider.dart';
import 'package:college_bus_project/Navigation/page_navigation.dart';
import 'package:college_bus_project/Profile/Pages/personal_info_page.dart';
import 'package:college_bus_project/data/api_data.dart';
import 'package:college_bus_project/login_and_registration/pages/login_registration.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  Future<void> registreStudent(BuildContext context, String username,
      String email, String password, String reEnteredPassword) async {
    if (username.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        reEnteredPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All fields are required')),
      );
      return;
    }

    final url = Uri.parse('$baseUrl/users/register');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "username": username,
          "email": email,
          "password": password,
          "confirmPassword": reEnteredPassword,
        }),
      );

      print('$username, $email, $password, $reEnteredPassword');
      print(response.statusCode);

      if (response.statusCode == 201) {
        final responseBody = jsonDecode(response.body);
        print(responseBody);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You Registered successfully')),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      } else {
        final responseBody = jsonDecode(response.body);
        print(responseBody);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text(responseBody['error'] ?? 'An unknown error occurred')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  StudentProfile? studentProfile;

  Future<void> _fetchStudentProfile(BuildContext context) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final uuid = sharedPreferences.getString('user_uuid');
    final provider =
        Provider.of<StudentProfileProvider>(context, listen: false);
    studentProfile = await provider.fetchStudentProfile(uuid!);
  }

  Future<void> loginStudent(
      BuildContext context, String email, String password) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final url = Uri.parse('$baseUrl/users/login');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseBody = jsonDecode(response.body);
        print(responseBody);
        await sharedPreferences.setString('auth_token', responseBody['token']);
        await sharedPreferences.setString('user_uuid', responseBody['uuid']);
        await sharedPreferences.setString('email', email);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You logged in successfully')),
        );

        // Fetch student profile and wait for it to complete
        await _fetchStudentProfile(context);

        print(studentProfile);
        print(studentProfile?.name);

        // Ensure we check if the student profile has a name (not null)
        if (studentProfile != null && studentProfile?.name != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const PersonalInfoPage()),
          );
        }
      } else {
        final responseBody = jsonDecode(response.body);
        print(responseBody);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text(responseBody['error'] ?? 'An unknown error occurred')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void logout(BuildContext context) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool isRemoved = await sharedPreferences.remove('auth_token');

    if (isRemoved == true) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const LoginPage()));
    }
  }
}
