// ignore_for_file: use_build_context_synchronously, unnecessary_null_comparison, unrelated_type_equality_checks

import 'package:college_bus_project/Emergency/Models/profile_model.dart';
import 'package:college_bus_project/Emergency/Provider/student_profile_provider.dart';
import 'package:college_bus_project/dashboard/Models/room_mates_model.dart';
import 'package:college_bus_project/dashboard/Utils/room_mates_provider.dart';
import 'package:college_bus_project/dashboard/components/seconadary_components/room_mate_column.dart';
import 'package:college_bus_project/data/api_data.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher_string.dart';

class RoomMates extends StatefulWidget {
  const RoomMates({super.key});

  @override
  State<RoomMates> createState() => _RoomMates();
}

class _RoomMates extends State<RoomMates> {
  StudentProfile? studentProfile;
  List<RoommateProfile> roommatesList = [];

  @override
  void initState() {
    super.initState();
    _checkNetworkConnectivity();
    _fetchStudentProfile().then((_) {
      _fetchRoomMatesProfile();
    });
  }

  Future<void> _checkNetworkConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Device is not connected to the network.'),
        ),
      );
    }
  }

  Future<void> _fetchStudentProfile() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final uuid = sharedPreferences.getString('user_uuid');
    final provider =
        Provider.of<StudentProfileProvider>(context, listen: false);
    final profile = await provider.fetchStudentProfile(uuid!);
    setState(() {
      studentProfile = profile;
    });
  }

  Future<void> _fetchRoomMatesProfile() async {
    final provider = Provider.of<RoomMatesProvider>(context, listen: false);
    final roomMatesProfile =
        await provider.fetchRoomMateProfile(studentProfile?.busId ?? 0);
    setState(() {
      roommatesList = roomMatesProfile;
    });
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final uri = Uri(scheme: 'tel', path: phoneNumber);
    if (uri != null) {
      await launchUrlString(uri.toString());
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not launch phone dialer.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: roommatesList.map((roommate) {
          return Padding(
            padding:
                EdgeInsets.all(MediaQuery.of(context).size.height * 0.0120),
            child: GestureDetector(
              onTap: () {
                _makePhoneCall(roommate.contactNumber);
              },
              child: RoomMateColumn(
                department: roommate.prefferedCourse,
                imageUrl: roommate.profilePic != null
                    ? '$baseUrl/student_regi/${roommate.profilePic}'
                    : 'https://via.placeholder.com/150',
                name: '${roommate.firstName} ${roommate.lastName}',
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
