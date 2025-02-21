// ignore_for_file: deprecated_member_use

import 'package:college_bus_project/Profile/Model/route_model.dart';
import 'package:college_bus_project/Profile/Model/student_profile_model.dart';
import 'package:college_bus_project/Profile/Pages/profile_preview_page.dart';
import 'package:college_bus_project/Profile/Services/api_service.dart';
import 'package:college_bus_project/scanner/Components/custom_button.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../login_and_registration/Widgets/common_textform_field.dart';

class BusRouteInfo extends StatefulWidget {
  const BusRouteInfo({super.key});

  @override
  State<BusRouteInfo> createState() => _BusRouteInfoState();
}

class _BusRouteInfoState extends State<BusRouteInfo> {
  late Future<List<RouteDetails>> routes;
  final StudentApiService apiService = StudentApiService();
  RouteDetails? selectedRoute;
  final TextEditingController _busStopController = TextEditingController();

  @override
  void initState() {
    super.initState();

    routes = apiService.fetchBusRoutes();
  }

  void _updateBusStop(String value) {
    Provider.of<Studentprofile>(context, listen: false).setbusStop(value);
  }

  void storeBusID() async {
    if (selectedRoute == null) return;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('bus_id', selectedRoute!.id.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Text(
              'Step 3',
              style: TextStyle(
                  fontSize: MediaQuery.of(context).size.height * 0.018,
                  fontWeight: FontWeight.w500),
            ),
            const Icon(Icons.arrow_forward_ios),
            Text(
              'Bus Routes',
              style: TextStyle(
                  fontSize: MediaQuery.of(context).size.height * 0.018,
                  fontWeight: FontWeight.w100),
            )
          ],
        ),
      ),
      body: FutureBuilder<List<RouteDetails>>(
        future: routes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No routes available.'));
          } else {
            final routeDetails = snapshot.data!;
            return Center(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(
                        MediaQuery.of(context).size.height * 0.008),
                    child: DropdownButton2<RouteDetails>(
                      hint: const Text('Select Route'),
                      isExpanded: true,
                      value: selectedRoute,
                      dropdownStyleData: DropdownStyleData(
                        width: MediaQuery.of(context).size.width * 0.96,
                        decoration: const BoxDecoration(color: Colors.white),
                        padding: const EdgeInsets.all(10),
                      ),
                      underline: const SizedBox(),
                      buttonStyleData: ButtonStyleData(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 6,
                              offset: const Offset(2, 4),
                            ),
                          ],
                        ),
                      ),
                      onChanged: (RouteDetails? newValue) {
                        if (newValue == null) return;
                        setState(() {
                          selectedRoute = newValue;
                        });

                        Provider.of<Studentprofile>(context, listen: false)
                            .setrouteId(newValue.id.toString());
                        Provider.of<Studentprofile>(context, listen: false)
                            .setbusRoute(newValue.routeName.toString());
                      },
                      menuItemStyleData:
                          const MenuItemStyleData(padding: EdgeInsets.all(8.0)),
                      items: routeDetails.map<DropdownMenuItem<RouteDetails>>(
                          (RouteDetails route) {
                        return DropdownMenuItem<RouteDetails>(
                          value: route,
                          child: Text(
                            route.routeName ?? 'Unknown Route',
                            style: const TextStyle(color: Colors.black),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  if (selectedRoute != null)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Selected Route: ${selectedRoute!.routeName}',
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.height * 0.015,
                      vertical: MediaQuery.of(context).size.height * 0.015,
                    ),
                    child: CommonTextFormfield(
                      onChanged: (value) {
                        _updateBusStop(value);
                      },
                      label: "Bus Stop",
                      hint: "Enter Bus Stop in detail",
                      obscure: false,
                      fillColor: Colors.transparent,
                      controller: _busStopController,
                      suffixIcon: const Icon(
                        FontAwesomeIcons.trafficLight,
                        color: Colors.black,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Enter the Bus Stop first!";
                        }
                        return null;
                      },
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const ProfilePreviewPage()));
                    },
                    child: const CustomButton(
                        color: Colors.blue, buttonText: 'Next'),
                  )
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
