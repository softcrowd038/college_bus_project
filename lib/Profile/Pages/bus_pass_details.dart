import 'package:college_bus_project/Emergency/Models/profile_model.dart';
import 'package:college_bus_project/Emergency/Provider/student_profile_provider.dart';
import 'package:college_bus_project/Profile/Model/get_pass_details.dart';
import 'package:college_bus_project/Profile/Pages/bus_pass_page.dart';
import 'package:college_bus_project/Profile/Services/student_pass_provider.dart';
import 'package:college_bus_project/dashboard/components/seconadary_components/personal_info_row.dart';
import 'package:college_bus_project/data/api_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BusPassDetailspage extends StatefulWidget {
  const BusPassDetailspage({super.key});

  @override
  State<BusPassDetailspage> createState() => _BusPassDetailspageState();
}

class _BusPassDetailspageState extends State<BusPassDetailspage> {
  BusPassDetails? busPassDetails;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchStudentProfile(context);
    _fetchBusPassDetails();
  }

  StudentProfile? studentProfile;

  Future<void> _fetchStudentProfile(BuildContext context) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final uuid = sharedPreferences.getString('user_uuid');
    final provider =
        Provider.of<StudentProfileProvider>(context, listen: false);
    print(uuid);
    studentProfile = await provider.fetchStudentProfile(uuid);
  }

  Future<void> _fetchBusPassDetails() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final uuid = sharedPreferences.getString('user_uuid');
    final provider = Provider.of<StudentPassProvider>(context, listen: false);
    final passProvider =
        Provider.of<StudentProfileProvider>(context, listen: false);
    print(uuid);
    studentProfile = await passProvider.fetchStudentProfile(uuid);

    if (uuid != null && studentProfile != null) {
      print(studentProfile!.studentId);
      final profile = await provider
          .fetchBusPassDetails(studentProfile!.studentId.toString());

      setState(() {
        busPassDetails = profile;
        isLoading = false;
      });
    } else {
      print("Either UUID or studentProfile is null");
      setState(() {
        isLoading = false;
      });
    }
  }

  String formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.white,
        title: isLoading
            ? const Center(child: Text(''))
            : Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: () {
                        if (busPassDetails == null ||
                            busPassDetails?.status != 'Active') {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const BusPassPage()));
                        } else {
                          return;
                        }
                      },
                      child: Text(
                        'create pass',
                        style: TextStyle(
                            color: busPassDetails == null ||
                                    busPassDetails!.status != 'Active'
                                ? Colors.blue
                                : Colors.grey,
                            fontWeight: FontWeight.w500),
                      ))
                ],
              ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : busPassDetails == null
              ? const Center(child: Text("No bus pass details available"))
              : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(
                          MediaQuery.of(context).size.height * 0.00850),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * 0.100,
                            width: MediaQuery.of(context).size.height * 0.100,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.black.withOpacity(0.5),
                                    width: 2),
                                borderRadius: BorderRadius.circular(
                                    MediaQuery.of(context).size.height *
                                        0.100)),
                            child: Container(
                              height:
                                  MediaQuery.of(context).size.height * 0.070,
                              width: MediaQuery.of(context).size.height * 0.070,
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.white, width: 2),
                                  borderRadius: BorderRadius.circular(
                                      MediaQuery.of(context).size.height *
                                          0.080)),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  MediaQuery.of(context).size.height * 0.070,
                                ),
                                child: Image.network(
                                  '$baseUrl/students/${studentProfile?.profileImage}',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.012,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                studentProfile!.name,
                                style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize:
                                        MediaQuery.of(context).size.height *
                                            0.028),
                              ),
                              Text(
                                studentProfile!.collegeName,
                                style: TextStyle(
                                    fontWeight: FontWeight.w100,
                                    fontSize:
                                        MediaQuery.of(context).size.height *
                                            0.014),
                              ),
                              Text(
                                studentProfile!.department,
                                style: TextStyle(
                                    fontWeight: FontWeight.w100,
                                    color: Colors.red,
                                    fontSize:
                                        MediaQuery.of(context).size.height *
                                            0.014),
                              ),
                            ],
                          )
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
                              'Bus Pass Information',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: MediaQuery.of(context).size.height *
                                      0.022),
                            ),
                          ),
                          PersonalInfoRow(
                              icon: Icons.email,
                              title: 'Bus Name',
                              value: busPassDetails?.busName ?? 'N/A'),
                          PersonalInfoRow(
                              icon: Icons.class_,
                              title: 'Route',
                              value: busPassDetails?.routeName ?? 'N/A'),
                          PersonalInfoRow(
                              icon: Icons.class_,
                              title: 'Bus Stop',
                              value: studentProfile?.busStop ?? 'N/A'),
                          PersonalInfoRow(
                              icon: Icons.contact_emergency,
                              title: 'Plan',
                              value: busPassDetails?.plan ?? 'N/A'),
                          PersonalInfoRow(
                              icon: Icons.smartphone,
                              title: 'Pass Price',
                              value: busPassDetails?.price ?? 'N/A'),
                          PersonalInfoRow(
                              icon: Icons.email,
                              title: 'Issue Date',
                              value: formatDate(busPassDetails?.issueDate)),
                          PersonalInfoRow(
                              icon: Icons.class_,
                              title: 'Expiry Date',
                              value: formatDate(busPassDetails?.expiryDate)),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }
}
