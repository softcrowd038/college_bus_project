import 'package:college_bus_project/Profile/Model/student_profile_model.dart';
import 'package:college_bus_project/Profile/Pages/bus_info_page.dart';
import 'package:college_bus_project/scanner/Components/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../login_and_registration/Widgets/common_textform_field.dart';

class ProfessionalDetailsPage extends StatefulWidget {
  const ProfessionalDetailsPage({super.key});

  @override
  State<ProfessionalDetailsPage> createState() =>
      _ProfessionalDetailsPageState();
}

class _ProfessionalDetailsPageState extends State<ProfessionalDetailsPage> {
  TextEditingController _collegeNameController = TextEditingController();
  TextEditingController _departmentController = TextEditingController();
  TextEditingController _classController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _collegeNameController = TextEditingController();
    _departmentController = TextEditingController();
    _classController = TextEditingController();
  }

  @override
  void dispose() {
    _collegeNameController.dispose();
    _departmentController.dispose();
    _classController.dispose();
    super.dispose();
  }

  void _updateCollegeName(String value) {
    Provider.of<Studentprofile>(context, listen: false).setcollegeName(value);
  }

  void _updateDepartment(String value) {
    Provider.of<Studentprofile>(context, listen: false).setdepartment(value);
  }

  void _updateClass(String value) {
    Provider.of<Studentprofile>(context, listen: false).setClass(value);
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
                'Step 2',
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height * 0.018,
                    fontWeight: FontWeight.w500),
              ),
              const Icon(Icons.arrow_forward_ios),
              Text(
                'Professional Information',
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height * 0.018,
                    fontWeight: FontWeight.w100),
              )
            ],
          )),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.height * 0.015,
                right: MediaQuery.of(context).size.height * 0.015,
                bottom: MediaQuery.of(context).size.height * 0.010,
              ),
              child: CommonTextFormfield(
                onChanged: (value) {
                  _updateCollegeName(value);
                },
                label: "College / Company Name",
                hint: "Xyz pvt. ltd.",
                obscure: false,
                controller: _collegeNameController,
                fillColor: Colors.transparent,
                suffixIcon: const Icon(
                  Icons.school,
                  color: Colors.black,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter the work place first!";
                  }

                  return null;
                },
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.height * 0.015,
              right: MediaQuery.of(context).size.height * 0.015,
              bottom: MediaQuery.of(context).size.height * 0.015,
            ),
            child: CommonTextFormfield(
              onChanged: (value) {
                _updateDepartment(value);
              },
              label: "Stream / Department Name",
              hint: "Mechanical Department / Police Department",
              obscure: false,
              fillColor: Colors.transparent,
              controller: _departmentController,
              suffixIcon: const Icon(
                Icons.cabin,
                color: Colors.black,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Enter the Department first!";
                }

                return null;
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.height * 0.015,
              right: MediaQuery.of(context).size.height * 0.015,
              bottom: MediaQuery.of(context).size.height * 0.015,
            ),
            child: CommonTextFormfield(
              onChanged: (value) {
                _updateClass(value);
              },
              label: "class / Years of experience",
              hint: "2nd year",
              obscure: false,
              fillColor: Colors.transparent,
              controller: _classController,
              suffixIcon: const Icon(
                Icons.class_,
                color: Colors.black,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Enter the year first!";
                }

                return null;
              },
            ),
          ),
          GestureDetector(
            onTap: () {
              if (_formKey.currentState!.validate()) {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const BusRouteInfo()));
              }
            },
            child: const CustomButton(
              color: Colors.blue,
              buttonText: "Next",
            ),
          ),
        ],
      ),
    );
  }
}
