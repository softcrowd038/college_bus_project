// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:college_bus_project/Emergency/Models/profile_model.dart';
import 'package:college_bus_project/Emergency/Provider/student_profile_provider.dart';
import 'package:college_bus_project/scanner/Provider/scanner_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:telephony/telephony.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  State<StatefulWidget> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  bool isCheckedIn = false;
  String uniqueID = "2ddb8d41-76ee-4368-aebc-041ff0d93b78";
  StudentProfile? studentProfile;
  bool isLoading = false;
  DateTime? _lastSmsTimestamp;

  @override
  void initState() {
    super.initState();

    _fetchStudentProfile().then((_) {
      getCheckInCheckOutStatus();
    });
  }

  void sendEmergencySMS() async {
    final provider = Provider.of<ScannerProvider>(context, listen: false);

    if (_lastSmsTimestamp == null ||
        DateTime.now().difference(_lastSmsTimestamp!) >
            const Duration(seconds: 5)) {
      try {
        if (studentProfile?.emergencyContact == null) {
          print('Emergency phone number is not available.');
          return;
        }

        String emergencyNumber = studentProfile!.phoneNumber;

        String message = '${studentProfile?.name}';
        await Telephony.instance.sendSms(
            to: emergencyNumber,
            message:
                '$message is just ${provider.checkInStatus}  ${provider.checkInStatus == 'checked-in' ? 'in' : 'from'} hostel');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Emergency SMS sent to your ${studentProfile?.phoneNumber}')),
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

  Future<void> getCheckInCheckOutStatus() async {
    try {
      final provider = Provider.of<ScannerProvider>(context, listen: false);
      final status =
          await provider.getCheckoutStatus(studentProfile?.busId ?? 0);
      setState(() {
        isCheckedIn = status.status == 'checked-in';
      });
    } catch (e) {
      print('Error fetching check-in status: $e');
    }
  }

  Future<void> _fetchStudentProfile() async {
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
      _showDialog("Error", "Unable to fetch student profile. Please try again.",
          isError: true);
    }
  }

  void _showDialog(String title, String message, {bool isError = false}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            title,
            style: TextStyle(color: isError ? Colors.green : Colors.red),
          ),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _processScan(int regnum, String checkedstatus) async {
    final provider = Provider.of<ScannerProvider>(context, listen: false);

    setState(() {
      isLoading = true;
    });
    print('enter Process scan');
    print(checkedstatus);

    try {
      final response = checkedstatus == 'checked-in'
          ? await provider.postCheckOut(regnum)
          : await provider.postCheckIn(regnum);

      if (response['status'] == 'success') {
        await getCheckInCheckOutStatus();
      } else {
        _showDialog("Success", response['message'] ?? "Operation failed",
            isError: true);
      }
    } catch (e) {
      _showDialog("Error", "An error occurred: $e", isError: true);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void startScanner(String checkedStatus) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.35,
            width: MediaQuery.of(context).size.width * 0.8,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.black),
            ),
            child: MobileScanner(
              controller: MobileScannerController(
                detectionSpeed: DetectionSpeed.noDuplicates,
                returnImage: true,
              ),
              onDetect: (capture) {
                final List<Barcode> barcodes = capture.barcodes;

                for (final barcode in barcodes) {
                  String qrCode = barcode.rawValue ?? "";
                  if (qrCode.isNotEmpty && qrCode == uniqueID) {
                    _processScan(studentProfile?.studentId ?? 0, checkedStatus)
                        .then((_) {
                      sendEmergencySMS();
                    });
                    Navigator.pop(context);
                    break;
                  } else {
                    print("Invalid QR Code!");
                  }
                }
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.60,
                  width: MediaQuery.of(context).size.width,
                  child: Image.network(
                    'https://img.freepik.com/free-vector/qr-code-scanning-concept-with-characters-illustrated_23-2148633631.jpg',
                  ),
                ),
                Text(
                  'SCAN QR',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: MediaQuery.of(context).size.height * 0.024,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.height * 0.015),
                  child: Text(
                    'Click below Button to Scan QR CODE to  Check Out and Check In',
                    style: TextStyle(
                      color: const Color.fromARGB(255, 161, 161, 161),
                      fontSize: MediaQuery.of(context).size.height * 0.015,
                    ),
                  ),
                ),
                Consumer<ScannerProvider>(
                  builder: (context, provider, child) {
                    return GestureDetector(
                      onTap: () {
                        startScanner(provider.checkInStatus);
                      },
                      child: Padding(
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.height * 0.015),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.050,
                          width: MediaQuery.of(context).size.width * 0.60,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: provider.checkInStatus == 'checked-in'
                                  ? const LinearGradient(
                                      colors: [
                                        Color.fromARGB(255, 201, 79, 79),
                                        Color.fromARGB(255, 141, 61, 61),
                                      ],
                                    )
                                  : const LinearGradient(
                                      colors: [
                                        Color(0xff7ac94f),
                                        Color(0xff3d8d4f),
                                      ],
                                    )),
                          child: Center(
                            child: isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white)
                                : Text(
                                    provider.checkInStatus == 'checked-in'
                                        ? 'Check Out'
                                        : 'Check In',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize:
                                          MediaQuery.of(context).size.height *
                                              0.02,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
