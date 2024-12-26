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

class RoomMates extends StatefulWidget {
  const RoomMates({super.key});

  @override
  State<RoomMates> createState() => _RoomMates();
}

class _RoomMates extends State<RoomMates> {
  StudentProfile? studentProfile;
  List<BusMateProfile> busmatesList = [];

  @override
  void initState() {
    super.initState();
    _checkNetworkConnectivity();
    _fetchStudentProfile().then((_) {
      _fetchBusMatesProfile();
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

  Future<void> _fetchBusMatesProfile() async {
    final provider = Provider.of<RoomMatesProvider>(context, listen: false);
    final roomMatesProfile =
        await provider.fetchBusMateProfile(studentProfile?.busId ?? 0);
    setState(() {
      busmatesList = roomMatesProfile;
    });
  }

  @override
  Widget build(BuildContext context) {
    return busmatesList.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : Padding(
            padding:
                EdgeInsets.all(MediaQuery.of(context).size.height * 0.0120),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: MediaQuery.of(context).size.height * 0.00120,
                mainAxisSpacing: MediaQuery.of(context).size.height * 0.00120,
                childAspectRatio: 3 / 4,
              ),
              itemCount: busmatesList.length,
              itemBuilder: (context, index) {
                final roommate = busmatesList[index];
                return RoomMateColumn(
                  department: roommate.department,
                  imageUrl: roommate.profileImage != null
                      ? '$baseUrl/students/${roommate.profileImage}'
                      : 'https://via.placeholder.com/150',
                  name: roommate.name,
                );
              },
            ),
          );
  }
}
