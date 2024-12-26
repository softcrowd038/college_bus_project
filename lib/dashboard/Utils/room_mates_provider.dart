import 'dart:convert';
import 'package:college_bus_project/dashboard/Models/room_mates_model.dart';
import 'package:college_bus_project/data/api_data.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RoomMatesProvider extends ChangeNotifier {
  Future<List<RoommateProfile>> fetchRoomMateProfile(int roomNumber) async {
    final url = Uri.parse('$baseUrl/hostel-students/room-partner/$roomNumber');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200 || response.statusCode == 201) {
        List<dynamic> jsonResponse = json.decode(response.body);

        if (jsonResponse.isNotEmpty) {
          final List<dynamic> data = jsonDecode(response.body);
          return data.map((item) => RoommateProfile.fromJson(item)).toList();
        } else {
          return [];
        }
      } else {
        return [];
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
