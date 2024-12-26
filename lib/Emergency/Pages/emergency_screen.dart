// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:college_bus_project/Emergency/Models/profile_model.dart';
import 'package:college_bus_project/Emergency/Provider/student_profile_provider.dart';
import 'package:college_bus_project/GoogleMapIntegration/Provider/location_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:telephony/telephony.dart';

class EmergencyScreen extends StatefulWidget {
  const EmergencyScreen({super.key});

  @override
  State<StatefulWidget> createState() => _EmergencyScreen();
}

class _EmergencyScreen extends State<EmergencyScreen> {
  StudentProfile? studentProfile;
  DateTime? _lastSmsTimestamp;

  @override
  void initState() {
    super.initState();
    _fetchStudentProfile();
  }

  Future<void> _fetchStudentProfile() async {
    if (!mounted) return;
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      final uuid = sharedPreferences.getString('user_uuid');
      if (uuid == null) throw Exception('User UUID not found');
      final provider =
          Provider.of<StudentProfileProvider>(context, listen: false);
      final profile = await provider.fetchStudentProfile(uuid);
      if (mounted) {
        setState(() {
          studentProfile = profile;
        });
      }
    } catch (e) {
      print('Error fetching student profile: $e');
    }
  }

  void sendEmergencySMS() async {
    final provider = Provider.of<LocationProvider>(context, listen: false);

    if (_lastSmsTimestamp == null ||
        DateTime.now().difference(_lastSmsTimestamp!) >
            const Duration(seconds: 15)) {
      try {
        if (studentProfile?.emergencyContact == null) {
          print('Emergency phone number is not available.');
          return;
        }

        String emergencyNumber = studentProfile!.emergencyContact;
        LatLng? currentPosition = provider.currentPosition;
        print(currentPosition?.latitude);
        if (currentPosition == null) {
          print('Current position is not available.');
          return;
        }

        String message = 'https://www.google.com/maps/search/?api=1'
            '&query=${currentPosition.latitude},${currentPosition.longitude}';
        await Telephony.instance.sendSms(
            to: emergencyNumber,
            message: 'Hey, I caught in emergency, at this location: $message');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Emergency SMS sent to $emergencyNumber')),
        );
        _lastSmsTimestamp = DateTime.now();
      } catch (e) {
        print('Error sending emergency SMS: $e');
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('SMS not sent due to cooldown period')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: screenHeight * 0.5,
              child: Image.network(
                  'https://img.freepik.com/free-vector/emergency-call-concept-illustration_114360-6864.jpg'),
            ),
            Text(
              'Emergency',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: screenHeight * 0.024,
                  fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: EdgeInsets.all(screenHeight * 0.018),
              child: Text(
                'Press the below button in case of emergency. It will share your live location with your parents.',
                style: TextStyle(
                    color: const Color.fromARGB(255, 161, 161, 161),
                    fontSize: screenHeight * 0.015),
              ),
            ),
            GestureDetector(
              onTap: sendEmergencySMS,
              child: Padding(
                padding: EdgeInsets.all(screenHeight * 0.015),
                child: Container(
                  height: screenHeight * 0.05,
                  width: screenWidth,
                  color: const Color.fromARGB(255, 221, 15, 0),
                  child: Center(
                    child: Text(
                      'Press',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: screenHeight * 0.018),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
