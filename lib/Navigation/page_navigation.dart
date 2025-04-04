// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:college_bus_project/Buslocationtracker/Pages/live_location.dart';
import 'package:college_bus_project/Emergency/Models/profile_model.dart';
import 'package:college_bus_project/Emergency/Pages/emergency_screen.dart';
import 'package:college_bus_project/Emergency/Profile/profile_page.dart';
import 'package:college_bus_project/Emergency/Provider/student_profile_provider.dart';
import 'package:college_bus_project/dashboard/pages/home_page.dart';
import 'package:college_bus_project/data/api_data.dart';
import 'package:college_bus_project/login_and_registration/Services/api_service.dart';
import 'package:college_bus_project/scanner/pages/scanner_page.dart';
import 'package:flutter/material.dart';
import 'package:circle_nav_bar/circle_nav_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:telephony/telephony.dart';
import 'package:college_bus_project/GoogleMapIntegration/Provider/location_provider.dart';

import '../Profile/Pages/bus_pass_details.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _selectedIndex = 1;
  ApiService apiService = ApiService();
  StudentProfile? studentProfile;
  DateTime? _lastSmsTimestamp;

  final List<Widget> _widgetOptions = <Widget>[
    const MainPage(),
    const ScannerPage(),
    const LiveLocationTracker(),
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

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
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: () {
                sendEmergencySMS();
              },
              child: Container(
                height: MediaQuery.of(context).size.height * 0.04,
                decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(
                      MediaQuery.of(context).size.height * 0.005,
                    )),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(
                      MediaQuery.of(context).size.height * 0.005,
                    ),
                    child: Text(
                      'Emergency',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: MediaQuery.of(context).size.height * 0.014,
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
      body: _widgetOptions.elementAt(_selectedIndex),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(
                        '$baseUrl/students/${studentProfile?.profileImage}'),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${studentProfile?.name}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      '${studentProfile?.collegeName}',
                      style: TextStyle(
                          fontWeight: FontWeight.w100,
                          fontSize: MediaQuery.of(context).size.height * 0.014),
                    ),
                  ),
                  Text(
                    '${studentProfile?.department}',
                    style: TextStyle(
                        fontWeight: FontWeight.w100,
                        color: Colors.white,
                        fontSize: MediaQuery.of(context).size.height * 0.014),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const HomePage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.emergency),
              title: const Text('Emergency'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const EmergencyScreen()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('My Profile'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProfilePage()));
              },
            ),
            ListTile(
              leading: const Icon(FontAwesomeIcons.ticket),
              title: const Text('My Pass'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const BusPassDetailspage()));
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Log Out'),
              onTap: () {
                apiService.logout(context);
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: CircleNavBar(
        activeIndex: _selectedIndex,
        onTap: _onItemTapped,
        circleColor: Colors.blue,
        activeIcons: const [
          Icon(Icons.home, color: Colors.white),
          Icon(Icons.qr_code_scanner, color: Colors.white),
          Icon(Icons.place, color: Colors.white),
          Icon(Icons.person_pin, color: Colors.white),
        ],
        inactiveIcons: const [
          Icon(Icons.home, color: Color.fromARGB(255, 255, 255, 255)),
          Icon(Icons.qr_code_scanner,
              color: Color.fromARGB(255, 255, 255, 255)),
          Icon(Icons.place, color: Color.fromARGB(255, 255, 255, 255)),
          Icon(Icons.person_pin, color: Color.fromARGB(255, 255, 255, 255)),
        ],
        color: const Color.fromARGB(255, 0, 0, 0),
        height: 60,
        circleWidth: 60,
        padding: const EdgeInsets.only(left: 0, right: 0, bottom: 0),
      ),
    );
  }
}
