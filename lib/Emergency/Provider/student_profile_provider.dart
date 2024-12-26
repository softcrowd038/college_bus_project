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
        List<dynamic> jsonResponse = json.decode(response.body);

        if (jsonResponse.isNotEmpty) {
          return StudentProfile.fromJson(jsonResponse[0]);
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}