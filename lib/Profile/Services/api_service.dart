// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:convert';
import 'dart:io';
import 'package:college_bus_project/Navigation/page_navigation.dart';
import 'package:college_bus_project/Profile/Model/bus_details.dart';
import 'package:college_bus_project/Profile/Model/route_model.dart';
import 'package:college_bus_project/Profile/Model/student_profile_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http_parser/http_parser.dart';

class StudentApiService {
  Future<void> studentDetails(BuildContext context) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    final String? uuid = sharedPreferences.getString('user_uuid');
    final String? email = sharedPreferences.getString('email');
    final studentProfile = Provider.of<Studentprofile>(context, listen: false);

    if (studentProfile.profileImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a profile image.')),
      );
      return;
    }

    if (studentProfile.routeId != null) {
      await fetchBusDetails(context, studentProfile.routeId);
    }

    final Uri url = Uri.parse('http://192.168.1.21:8090/api/students');

    try {
      var request = http.MultipartRequest('POST', url);

      File? imageFile = studentProfile.profileImage;
      if (imageFile != null) {
        final mimeType = lookupMimeType(imageFile.path);

        request.files.add(await http.MultipartFile.fromPath(
          'profile_image',
          imageFile.path,
          contentType: MediaType.parse(mimeType!),
        ));
      }

      request.fields.addAll({
        'uuid': uuid ?? "",
        'name': studentProfile.name ?? "",
        'college_name': studentProfile.collegeName ?? "",
        'department': studentProfile.department ?? "",
        'class': studentProfile.className ?? "",
        'email': email ?? "",
        'phone_number': studentProfile.phoneNumber ?? "",
        'bus_route': studentProfile.busRoute ?? "",
        'bus_stop': studentProfile.busStop ?? "",
        'bus_id': studentProfile.busId ?? "",
        'route_id': studentProfile.routeId ?? "",
        'emergency_contact': studentProfile.emergencyContact ?? "",
        'bus_name': studentProfile.busName ?? "",
      });

      var response = await request.send();
      final responseData = await http.Response.fromStream(response);

      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${responseData.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonResponse = json.decode(responseData.body);
        sharedPreferences.setString('status', 'submit');
        print('Student profile saved successfully: $jsonResponse');
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const HomePage()));
      } else {
        print('Failed to save student profile: ${responseData.body}');
      }
    } catch (e) {
      print('Error occurred: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  Future<List<RouteDetails>> fetchBusRoutes() async {
    final apiUrl = Uri.parse('http://192.168.1.21:8090/api/routes');
    try {
      final response = await http.get(apiUrl);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        return List<RouteDetails>.from(
            data.map((x) => RouteDetails.fromJson(x)));
      } else {
        throw Exception('Failed to load routes');
      }
    } catch (e) {
      throw Exception('Error fetching routes: $e');
    }
  }

  Future<List<BusDetails>> fetchBusDetails(
      BuildContext context, String? routeId) async {
    if (routeId == null || routeId.isEmpty) {
      print('Invalid routeId');
      return [];
    }

    final apiUrl =
        Uri.parse('http://192.168.1.21:8090/api/buses/buses-by-route/$routeId');
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final studentProfile = Provider.of<Studentprofile>(context, listen: false);

    try {
      final response = await http.get(apiUrl);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isNotEmpty) {
          String busId = data[0]['bus_id'].toString();
          String busName = data[0]['bus_name'].toString();

          sharedPreferences.setString('busid', busId);
          sharedPreferences.setString('busname', busName);

          studentProfile.setbusId(busId);
          studentProfile.setbusName(busName);

          return data.map((x) => BusDetails.fromJson(x)).toList();
        } else {
          print('No bus details found for this route');
        }
      } else {
        print(
            'Failed to load bus details. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching bus details: $e');
    }
    return [];
  }

  Future<void> submitPassData(
      String? studentId,
      String? studentName,
      String? busname,
      String? routeName,
      String? selectedPlan,
      String? selectedDate,
      String? selectedPrice,
      BuildContext context) async {
    if (selectedPlan == null || selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a plan and issue date')),
      );
      return;
    }

    final Map<String, dynamic> passData = {
      "student_id": studentId,
      "student_name": studentName,
      "bus_name": busname,
      "route_name": routeName,
      "plan": selectedPlan,
      "price": selectedPrice.toString(),
      "issue_date": selectedDate,
    };

    try {
      final response = await http.post(
        Uri.parse("http://192.168.1.21:8090/api/pass"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(passData),
      );

      if (response.statusCode == 200) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const HomePage()));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pass submitted successfully!')),
        );
      } else {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Failed to submit pass: ${responseData['message']}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
}
