// ignore_for_file: use_build_context_synchronously

import 'package:college_bus_project/Emergency/Models/profile_model.dart';
import 'package:college_bus_project/Emergency/Provider/student_profile_provider.dart';
import 'package:college_bus_project/Profile/Model/bus_pass_model.dart';
import 'package:college_bus_project/Profile/Services/api_service.dart';
import 'package:college_bus_project/login_and_registration/Widgets/common_textform_field.dart';
import 'package:college_bus_project/scanner/Components/custom_button.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BusPassPage extends StatefulWidget {
  const BusPassPage({super.key});

  @override
  State<BusPassPage> createState() => _BusPassPageState();
}

class _BusPassPageState extends State<BusPassPage> {
  @override
  void initState() {
    super.initState();
    _fetchStudentProfile(context);
  }

  final Map<String, int> planPrices = {
    "1 month": 1000,
    "3 months": 2500,
    "6 months": 4500,
    "1 year": 8000,
  };

  String? selectedPlan;
  int selectedPrice = 0;
  DateTime? selectedDate;
  final TextEditingController issueDateController = TextEditingController();
  StudentApiService studentApiService = StudentApiService();

  StudentProfile? studentProfile;

  Future<void> _fetchStudentProfile(BuildContext context) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final uuid = sharedPreferences.getString('user_uuid');
    final provider =
        Provider.of<StudentProfileProvider>(context, listen: false);
    studentProfile = await provider.fetchStudentProfile(uuid!);
  }

  void selectIssueDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        issueDateController.text = DateFormat('yyyy-MM-dd').format(picked);
        Provider.of<BusPass>(context, listen: false).setissueDate(picked);
      });
    }
  }

  void updatePassPrice(String value) {
    Provider.of<BusPass>(context, listen: false).setprice(value);
  }

  void updatePassPlan(String value) {
    Provider.of<BusPass>(context, listen: false).setplan(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            DropdownButton2(
              hint: const Text('Select Plan'),
              isExpanded: true,
              value: selectedPlan,
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
              onChanged: (String? newValue) {
                if (newValue == null) return;
                setState(() {
                  selectedPlan = newValue;
                  selectedPrice = planPrices[newValue]!;
                  updatePassPlan(newValue);
                });
              },
              menuItemStyleData:
                  const MenuItemStyleData(padding: EdgeInsets.all(8.0)),
              items:
                  planPrices.keys.map<DropdownMenuItem<String>>((String plan) {
                return DropdownMenuItem<String>(
                  value: plan,
                  child: Text(
                    plan,
                    style: const TextStyle(color: Colors.black),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.height * 0.015,
                vertical: MediaQuery.of(context).size.height * 0.015,
              ),
              child: CommonTextFormfield(
                onChanged: (value) {
                  updatePassPrice(value);
                },
                label: "Plan Price",
                hint: "Enter plan price first",
                obscure: false,
                fillColor: Colors.transparent,
                controller:
                    TextEditingController(text: selectedPrice.toString()),
                suffixIcon: const Icon(
                  Icons.money,
                  color: Colors.black,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "select your plan first";
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.all(MediaQuery.of(context).size.height * 0.012),
              child: TextFormField(
                controller: issueDateController,
                readOnly: true,
                decoration: const InputDecoration(
                  hintText: 'Tap to select issue date',
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                onTap: () => selectIssueDate(context),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select an issue date';
                  }
                  return null;
                },
              ),
            ),
            GestureDetector(
              onTap: () {
                studentApiService.submitPassData(
                    studentProfile!.studentId.toString(),
                    studentProfile!.name,
                    studentProfile!.busName,
                    studentProfile!.busRoute,
                    selectedPlan,
                    selectedDate.toString(),
                    selectedPrice.toString(),
                    context);
              },
              child:
                  const CustomButton(color: Colors.blue, buttonText: 'Submit'),
            )
          ],
        ),
      ),
    );
  }
}
