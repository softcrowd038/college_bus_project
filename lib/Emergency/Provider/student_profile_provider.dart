// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:college_bus_project/Emergency/Models/profile_model.dart';
import 'package:college_bus_project/data/api_data.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class StudentProfileProvider extends ChangeNotifier {
  Future<StudentProfile?> fetchStudentProfile(String uuid) async {
    final url = Uri.parse('$baseUrl/students/get/$uuid');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200 || response.statusCode == 201) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);

        if (jsonResponse.isNotEmpty) {
          return StudentProfile.fromJson(jsonResponse);
        } else {
          print("No student profile found for UUID: $uuid");
          return null;
        }
      } else {
        print(
            "Failed to fetch student profile. Status code: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error fetching student profile: $e");
      return null;
    }
  }
}
