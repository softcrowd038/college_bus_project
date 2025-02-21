// ignore_for_file: use_build_context_synchronously

import 'package:college_bus_project/Emergency/Models/profile_model.dart';
import 'package:college_bus_project/Emergency/Provider/student_profile_provider.dart';
import 'package:college_bus_project/dashboard/components/seconadary_components/personal_info_row.dart';
import 'package:college_bus_project/data/api_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  @override
  State<StatefulWidget> createState() => _ProfilePage();
}

class _ProfilePage extends State<ProfilePage> {
  StudentProfile? studentProfile;

  @override
  void initState() {
    super.initState();
    _fetchStudentProfile();
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

  String formatDate(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: studentProfile == null
            ? const Center(
                child: CircularProgressIndicator(
                color: Colors.red,
              ))
            : SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.008,
                    ),
                    Center(
                      child: Column(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * 0.120,
                            width: MediaQuery.of(context).size.height * 0.120,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    MediaQuery.of(context).size.height *
                                        0.120)),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  MediaQuery.of(context).size.height * 0.120),
                              child: Image.network(
                                '$baseUrl/students/${studentProfile!.profileImage ?? ''}',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.008,
                          ),
                          Text(studentProfile?.name ?? '',
                              style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.height *
                                      0.028,
                                  fontWeight: FontWeight.w600)),
                          Text(studentProfile?.department ?? '',
                              style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.height *
                                      0.012,
                                  fontWeight: FontWeight.w300)),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(
                          MediaQuery.of(context).size.height * 0.018),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Personal Information',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: MediaQuery.of(context).size.height *
                                      0.022),
                            ),
                          ),
                          PersonalInfoRow(
                              icon: Icons.smartphone,
                              title: 'Contact Number',
                              value: studentProfile?.phoneNumber ?? 'N/A'),
                          PersonalInfoRow(
                              icon: Icons.email,
                              title: 'Email',
                              value: studentProfile?.email ?? 'N/A'),
                          PersonalInfoRow(
                              icon: Icons.class_,
                              title: 'Class',
                              value:
                                  studentProfile?.studentProfileClass ?? 'N/A'),
                          PersonalInfoRow(
                              icon: Icons.contact_emergency,
                              title: 'Emergency Contact',
                              value: studentProfile?.emergencyContact ?? 'N/A'),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(
                          MediaQuery.of(context).size.height * 0.018),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Bus Details',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: MediaQuery.of(context).size.height *
                                      0.022),
                            ),
                          ),
                          PersonalInfoRow(
                              icon: Icons.bus_alert,
                              title: 'Bus Name',
                              value: studentProfile?.busName ?? 'N/A'),
                          PersonalInfoRow(
                              icon: Icons.route,
                              title: 'Route',
                              value: studentProfile?.busRoute ?? 'N/A'),
                          PersonalInfoRow(
                              icon: Icons.stop,
                              title: 'Bus Stop',
                              value: studentProfile?.busStop ?? 'N/A'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
