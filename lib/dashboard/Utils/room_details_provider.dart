import 'dart:convert';
import 'package:college_bus_project/dashboard/Models/room_details.model.dart';
import 'package:college_bus_project/data/api_data.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BusDetailsProvider extends ChangeNotifier {
  Future<BusDetails?> fetchBusDetails(int busId) async {
    final url = Uri.parse('$baseUrl/buses/bus/$busId');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200 || response.statusCode == 201) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);

        if (jsonResponse.isNotEmpty) {
          return BusDetails.fromJson(jsonResponse);
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
