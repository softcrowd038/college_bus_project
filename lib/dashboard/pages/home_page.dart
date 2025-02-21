// ignore_for_file: use_build_context_synchronously, unrelated_type_equality_checks, deprecated_member_use

import 'package:college_bus_project/Emergency/Models/profile_model.dart';
import 'package:college_bus_project/Emergency/Provider/student_profile_provider.dart';
import 'package:college_bus_project/dashboard/Models/room_details.model.dart';
import 'package:college_bus_project/dashboard/Models/room_mates_model.dart';
import 'package:college_bus_project/dashboard/Utils/navigation_provider.dart';
import 'package:college_bus_project/dashboard/Utils/room_details_provider.dart';
import 'package:college_bus_project/dashboard/components/room_mates.dart';
import 'package:college_bus_project/data/api_data.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  StudentProfile? studentProfile;
  BusMateProfile? roommateProfile;
  BusDetails? busDetails;

  @override
  void initState() {
    super.initState();
    _checkNetworkConnectivity();
    _fetchStudentProfile().then((_) {
      _fetchBusDetails(studentProfile?.busId ?? 0);
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

  Future<void> _fetchBusDetails(int busId) async {
    final provider = Provider.of<BusDetailsProvider>(context, listen: false);
    final bsuInfo = await provider.fetchBusDetails(busId);
    setState(() {
      busDetails = bsuInfo;
    });
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final uri = Uri(scheme: 'tel', path: phoneNumber);
    await launchUrlString(uri.toString());
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<NavigationProvider>(
          create: (_) => NavigationProvider(),
        ),
      ],
      child: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.height * 0.0160),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildStudentProfileSection(),
                SizedBox(height: MediaQuery.of(context).size.height * 0.0160),
                _buildbusDetailsSection(),
                _buildBusMatesSection(),
                SizedBox(height: MediaQuery.of(context).size.height * 0.0160),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStudentProfileSection() {
    return studentProfile == null
        ? Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.white,
            child: Column(
              children: [
                CircleAvatar(
                  radius: MediaQuery.of(context).size.height * 0.055,
                  backgroundColor: Colors.grey.shade300,
                ),
                const SizedBox(height: 8.0),
                Container(
                  height: MediaQuery.of(context).size.height * 0.022,
                  width: MediaQuery.of(context).size.width * 0.5,
                  color: Colors.grey.shade300,
                ),
                const SizedBox(height: 6.0),
                Container(
                  height: MediaQuery.of(context).size.height * 0.012,
                  width: MediaQuery.of(context).size.width * 0.3,
                  color: Colors.grey.shade300,
                ),
              ],
            ),
          )
        : Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(
                    MediaQuery.of(context).size.height * 0.110),
                child: Image.network(
                  studentProfile?.profileImage != null
                      ? '$baseUrl/students/${studentProfile?.profileImage}'
                      : 'https://img.freepik.com/free-vector/man-profile-account-picture_24908-81754.jpg',
                  height: MediaQuery.of(context).size.height * 0.110,
                  width: MediaQuery.of(context).size.height * 0.110,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                studentProfile?.name ?? '',
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.height * 0.022,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                studentProfile?.department ?? 'N/A',
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.height * 0.012,
                  fontWeight: FontWeight.w300,
                  color: Colors.black.withOpacity(0.7),
                ),
              ),
            ],
          );
  }

  Widget _buildbusDetailsSection() {
    return busDetails == null
        ? Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.white,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.350,
              width: double.infinity,
              color: Colors.grey.shade300,
            ),
          )
        : Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(
                  MediaQuery.of(context).size.height * 0.0160),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(
                      MediaQuery.of(context).size.height * 0.0160),
                  child: Image.network(
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSU6gQTRyiUS7rdX8mYI08MazOUyKmY_bPnOw&s',
                    height: MediaQuery.of(context).size.height * 0.260,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(
                      MediaQuery.of(context).size.height * 0.0160),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${busDetails?.busName}',
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.020,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.circle,
                                  color: Colors.blue,
                                  size: MediaQuery.of(context).size.height *
                                      0.014,
                                ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.height *
                                      0.012,
                                ),
                                Expanded(
                                  child: Text(
                                    'Drive by ${busDetails?.busDriver}',
                                    style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.height *
                                              0.014,
                                      fontWeight: FontWeight.w100,
                                      color: Colors.black.withOpacity(0.6),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                          width: MediaQuery.of(context).size.height * 0.012),
                      Expanded(
                        flex: 1,
                        child: GestureDetector(
                          onTap: () async {
                            _makePhoneCall(busDetails!.driverContact);
                          },
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.04,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(
                                MediaQuery.of(context).size.height * 0.005,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'Call Driver',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: MediaQuery.of(context).size.height *
                                      0.014,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(
                      MediaQuery.of(context).size.height * 0.0160),
                  child: Text(
                    '${busDetails?.busName} is driven by ${busDetails?.busDriver} with seating capacity of ${busDetails?.totalSeats}, from ${busDetails?.startingPoint} to ${busDetails?.endingPoint} covering the stops ${busDetails?.stopNames}. The distance is almost ${busDetails?.distance}',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height * 0.014,
                      fontWeight: FontWeight.w100,
                      color: Colors.black.withOpacity(0.6),
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          );
  }

  Widget _buildBusMatesSection() {
    return busDetails == null
        ? Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.022,
                  width: MediaQuery.of(context).size.width * 0.4,
                  color: Colors.grey.shade300,
                ),
                const SizedBox(height: 6.0),
                Container(
                  height: MediaQuery.of(context).size.height * 0.012,
                  width: MediaQuery.of(context).size.width * 0.3,
                  color: Colors.grey.shade300,
                ),
              ],
            ),
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('Bus-Mates',
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height * 0.022,
                      fontWeight: FontWeight.w600)),
              const RoomMates(),
            ],
          );
  }
}
