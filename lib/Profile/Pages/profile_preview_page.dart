import 'dart:io';
import 'package:college_bus_project/Profile/Model/student_profile_model.dart';
import 'package:college_bus_project/Profile/Services/api_service.dart';
import 'package:college_bus_project/dashboard/components/seconadary_components/personal_info_row.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePreviewPage extends StatefulWidget {
  const ProfilePreviewPage({super.key});

  @override
  State<ProfilePreviewPage> createState() => _ProfilePreviewPageState();
}

class _ProfilePreviewPageState extends State<ProfilePreviewPage> {
  String? email;
  StudentApiService studentApiService = StudentApiService();

  @override
  void initState() {
    super.initState();
    final studentProfileProvider =
        Provider.of<Studentprofile>(context, listen: false);
    _fetchStudentProfile(studentProfileProvider);
  }

  Future<void> _fetchStudentProfile(Studentprofile studentProfile) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    email = sharedPreferences.getString('email');

    if (studentProfile.routeId != null) {
      await studentApiService.fetchBusDetails(context, studentProfile.routeId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final studentProfileProvider =
        Provider.of<Studentprofile>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.white,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    'Step 4',
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height * 0.018,
                        fontWeight: FontWeight.w500),
                  ),
                  const Icon(Icons.arrow_forward_ios),
                  Text(
                    'Bus Information',
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height * 0.018,
                        fontWeight: FontWeight.w100),
                  )
                ],
              ),
              TextButton(
                  onPressed: () {
                    studentApiService.studentDetails(context);
                  },
                  child: const Text(
                    'submit',
                    style: TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.w500),
                  ))
            ],
          )),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.120,
              width: MediaQuery.of(context).size.height * 0.120,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                      MediaQuery.of(context).size.height * 0.120)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                    MediaQuery.of(context).size.height * 0.120),
                child: Image.file(
                  File(
                    '${studentProfileProvider.profileImage!.path}',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.008,
            ),
            Text(studentProfileProvider.name ?? '',
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height * 0.028,
                    fontWeight: FontWeight.w600)),
            Text(studentProfileProvider.department ?? '',
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height * 0.012,
                    fontWeight: FontWeight.w300)),
            Padding(
              padding:
                  EdgeInsets.all(MediaQuery.of(context).size.height * 0.018),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Personal Information',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: MediaQuery.of(context).size.height * 0.022),
                    ),
                  ),
                  PersonalInfoRow(
                      icon: Icons.smartphone,
                      title: 'Contact Number',
                      value: studentProfileProvider.phoneNumber ?? 'N/A'),
                  PersonalInfoRow(
                      icon: Icons.email, title: 'Email', value: email ?? 'N/A'),
                  PersonalInfoRow(
                      icon: Icons.contact_emergency,
                      title: 'Emergency Contact',
                      value: studentProfileProvider.emergencyContact ?? 'N/A'),
                ],
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.all(MediaQuery.of(context).size.height * 0.018),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Professional Information',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: MediaQuery.of(context).size.height * 0.022),
                    ),
                  ),
                  PersonalInfoRow(
                      icon: Icons.school,
                      title: 'Work place',
                      value: studentProfileProvider.collegeName ?? 'N/A'),
                  PersonalInfoRow(
                      icon: Icons.cabin,
                      title: 'Department',
                      value: studentProfileProvider.department ?? 'N/A'),
                  PersonalInfoRow(
                      icon: Icons.class_,
                      title: 'Class / Years of Expirience',
                      value: studentProfileProvider.className ?? 'N/A'),
                ],
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.all(MediaQuery.of(context).size.height * 0.018),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Bus Information',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: MediaQuery.of(context).size.height * 0.022),
                    ),
                  ),
                  PersonalInfoRow(
                      icon: Icons.route,
                      title: 'Route',
                      value: studentProfileProvider.busRoute ?? 'N/A'),
                  PersonalInfoRow(
                      icon: FontAwesomeIcons.trafficLight,
                      title: 'Bus Stop',
                      value: studentProfileProvider.busStop ?? 'N/A'),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
