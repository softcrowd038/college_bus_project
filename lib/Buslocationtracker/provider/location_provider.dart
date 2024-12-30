import 'dart:convert';
import 'package:college_bus_project/Buslocationtracker/Model/location_model.dart';
import 'package:college_bus_project/data/api_data.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LocationAPIProvider with ChangeNotifier {
  final bool _isLoading = false;
  String? _message;
  List<LocationModel> locations = [];

  bool get isLoading => _isLoading;
  String? get message => _message;

  Future<void> fetchLatLongIds() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/lat-long'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);

        locations =
            responseData.map((item) => LocationModel.fromJson(item)).toList();

        notifyListeners();
      } else {
        print('Failed to fetch lat-long data: ${response.body}');
      }
    } catch (error) {
      print('Error occurred while fetching lat-long data: $error');
    }
  }
}
