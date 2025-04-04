// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:college_bus_project/Profile/Model/get_pass_details.dart';
import 'package:college_bus_project/data/api_data.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class StudentPassProvider extends ChangeNotifier {
  Future<BusPassDetails?> fetchBusPassDetails(String studentId) async {
    print("student Id: $studentId");
    final url = Uri.parse('$baseUrl/pass/$studentId');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200 || response.statusCode == 201) {
        List<dynamic> jsonResponse = json.decode(response.body);

        if (jsonResponse.isNotEmpty) {
          return BusPassDetails.fromJson(jsonResponse[0]);
        } else {
          print("No student profile found for UUID: $studentId");
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
