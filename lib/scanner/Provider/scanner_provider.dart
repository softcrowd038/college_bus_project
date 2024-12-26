import 'dart:convert';
import 'package:college_bus_project/data/api_data.dart';
import 'package:college_bus_project/scanner/models/check_in_check_out_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ScannerProvider extends ChangeNotifier {
  StudentCheckInAndCheckOut? _studentCheckInAndCheckOut;
  String checkInStatus = "";

  StudentCheckInAndCheckOut? get studentCheckInAndCheckOut =>
      _studentCheckInAndCheckOut;

  Future<Map<String, dynamic>> postCheckIn(int regnum) async {
    final url = Uri.parse('$baseUrl/checkin');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'student_id': regnum}),
      );

      if (response.statusCode == 200) {
        _updateStatus('checked-in');
        notifyListeners();
        return jsonDecode(response.body);
      } else {
        throw Exception('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error $e');
    }
  }

  Future<Map<String, dynamic>> postCheckOut(int regnum) async {
    final url = Uri.parse('$baseUrl/checkout');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'student_id': regnum}),
      );

      if (response.statusCode == 200) {
        _updateStatus('checked-out');
        notifyListeners();
        return jsonDecode(response.body);
      } else {
        throw Exception('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error $e');
    }
  }

  void _updateStatus(String status) {
    checkInStatus = status;
  }

  Future<StudentCheckInAndCheckOut> getCheckoutStatus(int regnum) async {
    final url = Uri.parse('$baseUrl/attendance/$regnum');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData is List && responseData.isNotEmpty) {
          _studentCheckInAndCheckOut =
              StudentCheckInAndCheckOut.fromJson(responseData[0]);
          _updateStatus(_studentCheckInAndCheckOut!.status);
        } else if (responseData is Map) {
          _studentCheckInAndCheckOut =
              StudentCheckInAndCheckOut.fromJson(responseData);
          _updateStatus(_studentCheckInAndCheckOut!.status);
        } else {
          throw Exception("Unexpected response format");
        }

        notifyListeners();
        return _studentCheckInAndCheckOut!;
      } else {
        throw Exception(
            'Failed to load checkout status. Status code: ${response.statusCode}');
      }
    } catch (error) {
      rethrow;
    }
  }
}
