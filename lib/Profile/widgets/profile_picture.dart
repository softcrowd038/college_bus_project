// ignore_for_file: avoid_print, deprecated_member_use

import 'dart:io';
import 'package:college_bus_project/Profile/Model/student_profile_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfilePictureField extends StatefulWidget {
  final bool isEdit;

  const ProfilePictureField({super.key, required this.isEdit});

  @override
  ProfilePictureFieldState createState() => ProfilePictureFieldState();
}

class ProfilePictureFieldState extends State<ProfilePictureField> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.isEdit) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        _retainImage();
      });
    }
  }

  Future<void> _getImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      String fileExtension = pickedImage.path.split('.').last.toLowerCase();
      List<String> allowedExtensions = ['jpg', 'jpeg', 'png'];

      if (!allowedExtensions.contains(fileExtension)) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  'Invalid image format. Please select a JPG or PNG file.')),
        );
        return;
      }

      if (!mounted) return;
      Provider.of<Studentprofile>(context, listen: false)
          .setprofileImage(File(pickedImage.path));
    } else {
      if (!mounted) return;
      SchedulerBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('No image selected')));
      });
    }
  }

  Future<void> _retainImage() async {
    try {
      Studentprofile profileProvider =
          Provider.of<Studentprofile>(context, listen: false);

      if (profileProvider.profileImage == null ||
          profileProvider.profileImage!.path.isEmpty) {
        return;
      }

      if (await File(Provider.of<Studentprofile>(context, listen: false)
              .profileImage!
              .path)
          .exists()) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Image successfully retained')));
        return;
      }
      if (!mounted) return;
      SchedulerBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Image not found in Firestore')));
      });
    } catch (e) {
      print('Error retrieving image: $e');
      if (!mounted) return;
      SchedulerBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to retrieve image')));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileModel = Provider.of<Studentprofile>(context);
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: CircleAvatar(
            radius: 50,
            backgroundColor: Colors.blue.withOpacity(0.7),
            backgroundImage: profileModel.profileImage != null &&
                    profileModel.profileImage!.path.isNotEmpty
                ? FileImage(File(profileModel.profileImage!.path))
                : null,
            child: profileModel.profileImage == null ||
                    profileModel.profileImage!.path.isEmpty
                ? const Icon(
                    Icons.person,
                    size: 50,
                    color: Colors.blue,
                  )
                : null,
          ),
        ),
        const SizedBox(height: 10),
        Positioned(
          left: MediaQuery.of(context).size.height * 0.0420,
          top: MediaQuery.of(context).size.height * 0.0420,
          child: GestureDetector(
              onTap: () {
                _getImage();
              },
              child: Icon(
                Icons.camera_alt,
                size: MediaQuery.of(context).size.height * 0.040,
                color: Colors.white,
              )),
        )
      ],
    );
  }
}
