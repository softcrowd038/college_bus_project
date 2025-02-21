// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:college_bus_project/Emergency/Models/profile_model.dart';
import 'package:college_bus_project/Emergency/Provider/student_profile_provider.dart';
import 'package:college_bus_project/data/api_data.dart';
import 'package:college_bus_project/scanner/Provider/scanner_provider.dart';
import 'package:college_bus_project/scanner/models/check_in_check_out_model.dart';
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
  String uniqueID = "2ddb8d41-76ee-4368-aebc-041ff0d93b78";
  StudentProfile? studentProfile;
  bool isLoading = false;
  DateTime? _lastSmsTimestamp;
  String? todaysColor;

  @override
  void initState() {
    super.initState();
    _fetchStudentProfile();
  }

  void sendEmergencySMS() async {
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
            to: emergencyNumber, message: '$message is Entered in Bus');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Boarding SMS sent to ${studentProfile?.phoneNumber}')),
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

  bool _isFaintColor(String? colorHex) {
    if (colorHex == null || colorHex.trim().isEmpty) {
      return false;
    }
    try {
      final cleanedHex = colorHex.replaceFirst('#', '').trim();

      final colorValue = int.parse(cleanedHex, radix: 16);

      final r = (colorValue >> 16) & 0xFF;
      final g = (colorValue >> 8) & 0xFF;
      final b = colorValue & 0xFF;

      print('$r, $g, $b');

      final brightness = (0.299 * r + 0.587 * g + 0.114 * b);

      return brightness > 100;
    } catch (e) {
      print('Error parsing color: $e');
      return false;
    }
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Color(int.parse(
                  todaysColor?.replaceFirst('#', '0xff') ?? '0xffffffff')),
              borderRadius: BorderRadius.circular(15),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
                    child: Image.network(
                      '$baseUrl/students/${studentProfile!.profileImage}',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "${studentProfile?.name}",
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height * 0.020,
                    fontWeight: FontWeight.bold,
                    color: _isFaintColor(todaysColor)
                        ? Colors.black
                        : Colors.white,
                  ),
                ),
                Text(
                  "${studentProfile?.department}",
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height * 0.012,
                    color: _isFaintColor(todaysColor)
                        ? Colors.black
                        : Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Bus Name: ${studentProfile!.busName}',
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height * 0.016,
                      color: _isFaintColor(todaysColor)
                          ? Colors.black
                          : Colors.white,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                      color:
                          todaysColor == ' #FF0000' ? Colors.black : Colors.red,
                      borderRadius: BorderRadius.circular(
                          MediaQuery.of(context).size.height * 0.0120)),
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      "OK",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _processScan(int regnum) async {
    final provider = Provider.of<ScannerProvider>(context, listen: false);

    setState(() {
      isLoading = true;
    });
    print('Enter Process scan');

    try {
      final BusScanModel busScanModel = await provider.getBusColor(regnum);

      if (busScanModel.success) {
        final String dailyColor = busScanModel.dailyColor;
        setState(() {
          todaysColor = dailyColor;
        });
        print('Daily Color: $todaysColor');

        _showSuccessDialog("Process scan successful!");
      } else {
        _showDialog("Error", "Failed to retrieve data", isError: true);
      }
    } catch (e) {
      _showDialog("Error", "An error occurred: $e", isError: true);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void startScanner() {
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
                  print(qrCode.runtimeType);
                  print(studentProfile?.busId.toString().runtimeType);
                  if (qrCode.isNotEmpty &&
                      barcode.rawValue == studentProfile?.busId.toString()) {
                    _processScan(studentProfile?.busId ?? 0).then((_) {
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
                    'Click below Button to Scan QR CODE',
                    style: TextStyle(
                      color: const Color.fromARGB(255, 161, 161, 161),
                      fontSize: MediaQuery.of(context).size.height * 0.015,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    startScanner();
                  },
                  child: Padding(
                    padding: EdgeInsets.all(
                        MediaQuery.of(context).size.height * 0.015),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.050,
                      width: MediaQuery.of(context).size.width * 0.60,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: const LinearGradient(
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
                                'Scan Now',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize:
                                      MediaQuery.of(context).size.height * 0.02,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
