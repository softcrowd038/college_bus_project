import 'package:college_bus_project/Profile/Model/student_profile_model.dart';
import 'package:college_bus_project/Profile/Pages/professional_details_page.dart';
import 'package:college_bus_project/Profile/widgets/profile_picture.dart';
import 'package:college_bus_project/login_and_registration/Widgets/common_textform_field.dart';
import 'package:college_bus_project/scanner/Components/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PersonalInfoPage extends StatefulWidget {
  const PersonalInfoPage({super.key});

  @override
  State<PersonalInfoPage> createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _emergencyContactController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _phoneNumberController = TextEditingController();
    _emergencyContactController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneNumberController.dispose();
    _emergencyContactController.dispose();

    super.dispose();
  }

  void _updateName(String value) {
    Provider.of<Studentprofile>(context, listen: false).setname(value);
  }

  void _updatePhoneNumber(String value) {
    Provider.of<Studentprofile>(context, listen: false).setphoneNumber(value);
  }

  void _updateEmergencyContact(String value) {
    Provider.of<Studentprofile>(context, listen: false)
        .setemergencyContact(value);
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
                'Step 1',
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height * 0.018,
                    fontWeight: FontWeight.w500),
              ),
              const Icon(Icons.arrow_forward_ios),
              Text(
                'Personal Information',
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height * 0.018,
                    fontWeight: FontWeight.w100),
              )
            ],
          )),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
              child: Padding(
            padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.height * 0.015,
              right: MediaQuery.of(context).size.height * 0.015,
              bottom: MediaQuery.of(context).size.height * 0.010,
              top: MediaQuery.of(context).size.height * 0.010,
            ),
            child: const ProfilePictureField(isEdit: false),
          )),
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
                  _updateName(value);
                },
                label: "name",
                hint: "sam radcliff",
                obscure: false,
                controller: _nameController,
                fillColor: Colors.transparent,
                suffixIcon: const Icon(
                  Icons.person,
                  color: Colors.black,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter the Email first!";
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
                _updatePhoneNumber(value);
              },
              label: "mobile number",
              hint: "+91 1234567890",
              obscure: false,
              fillColor: Colors.transparent,
              controller: _phoneNumberController,
              suffixIcon: const Icon(
                Icons.call,
                color: Colors.black,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Enter the Password first!";
                }
                if (value.length < 8) {
                  return "Password is too short, Enter up to 8 digits!";
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
                _updateEmergencyContact(value);
              },
              label: "emergency contact",
              hint: "+91 1234567890",
              obscure: false,
              fillColor: Colors.transparent,
              controller: _emergencyContactController,
              suffixIcon: const Icon(
                Icons.mobile_friendly,
                color: Colors.black,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Enter the Password first!";
                }
                if (value.length < 8) {
                  return "Password is too short, Enter up to 8 digits!";
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
                        builder: (context) => const ProfessionalDetailsPage()));
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
