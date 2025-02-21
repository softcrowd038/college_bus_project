// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:college_bus_project/Buslocationtracker/provider/location_provider.dart';
import 'package:college_bus_project/Emergency/Provider/student_profile_provider.dart';
import 'package:college_bus_project/GoogleMapIntegration/Provider/location_provider.dart';
import 'package:college_bus_project/Profile/Model/bus_details.dart';
import 'package:college_bus_project/Profile/Model/bus_pass_model.dart';
import 'package:college_bus_project/Profile/Model/route_model.dart';
import 'package:college_bus_project/Profile/Model/student_profile_model.dart';
import 'package:college_bus_project/Profile/Services/student_pass_provider.dart';
import 'package:college_bus_project/app/my_app.dart';
import 'package:college_bus_project/dashboard/Utils/navigation_provider.dart';
import 'package:college_bus_project/dashboard/Utils/room_details_provider.dart';
import 'package:college_bus_project/dashboard/Utils/room_mates_provider.dart';
import 'package:college_bus_project/login_and_registration/Model/register_model.dart';
import 'package:college_bus_project/login_and_registration/Model/user_.dart';
import 'package:college_bus_project/scanner/Provider/scanner_provider.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyAppProviders());
}

class MyAppProviders extends StatelessWidget {
  const MyAppProviders({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LocationProvider>(
            create: (_) => LocationProvider()),
        ChangeNotifierProvider<RouteDetails>(create: (_) => RouteDetails()),
        ChangeNotifierProvider<UserModel>(create: (_) => UserModel()),
        ChangeNotifierProvider<UserCredentials>(
            create: (_) => UserCredentials()),
        ChangeNotifierProvider<NavigationProvider>(
            create: (_) => NavigationProvider()),
        ChangeNotifierProvider<StudentProfileProvider>(
            create: (_) => StudentProfileProvider()),
        ChangeNotifierProvider<Studentprofile>(create: (_) => Studentprofile()),
        ChangeNotifierProvider<RoomMatesProvider>(
            create: (_) => RoomMatesProvider()),
        ChangeNotifierProvider<BusDetailsProvider>(
            create: (_) => BusDetailsProvider()),
        ChangeNotifierProvider<ScannerProvider>(
            create: (_) => ScannerProvider()),
        ChangeNotifierProvider<LocationAPIProvider>(
            create: (_) => LocationAPIProvider()),
        ChangeNotifierProvider<BusDetails>(create: (_) => BusDetails()),
        ChangeNotifierProvider<BusPass>(create: (_) => BusPass()),
        ChangeNotifierProvider<StudentPassProvider>(
            create: (_) => StudentPassProvider()),
      ],
      child: MaterialApp(
        title: 'Your App Title',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(),
        home: const PermissionHandlerWrapper(),
      ),
    );
  }
}

class PermissionHandlerWrapper extends StatefulWidget {
  const PermissionHandlerWrapper({super.key});

  @override
  _PermissionHandlerWrapperState createState() =>
      _PermissionHandlerWrapperState();
}

class _PermissionHandlerWrapperState extends State<PermissionHandlerWrapper> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 3), () async {
      await requestPermissions();
      await checkPermissions();

      final locationProvider =
          Provider.of<LocationProvider>(context, listen: false);
      locationProvider.requestLocationPermissionAndGetCurrentLocation();
    });
  }

  @override
  Widget build(BuildContext context) {
    return const MyApp();
  }
}

Future<void> requestPermissions() async {
  var status = await Permission.camera.status;
  if (status.isDenied || status.isPermanentlyDenied) {
    await Permission.camera.request();
  }
}

Future<void> checkPermissions() async {
  var status = await Permission.camera.status;
  if (status.isGranted) {
    debugPrint("Camera permission granted");
  } else {
    debugPrint("Camera permission not granted");
  }
}
