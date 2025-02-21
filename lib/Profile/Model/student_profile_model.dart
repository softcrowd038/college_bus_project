import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';

Studentprofile studentprofileFromJson(String str) =>
    Studentprofile.fromJson(json.decode(str));

String studentprofileToJson(Studentprofile data) => json.encode(data.toJson());

class Studentprofile extends ChangeNotifier {
  String? _name;
  String? _collegeName;
  String? _department;
  String? _studentprofileClass;
  String? _email;
  String? _phoneNumber;
  String? _busRoute;
  String? _busStop;
  String? _busId;
  String? _routeId;
  String? _className;
  File? _profileImage;
  String? _emergencyContact;
  String? _uuid;
  String? _busName;

  Studentprofile({
    String? name,
    String? collegeName,
    String? department,
    String? studentprofileClass,
    String? email,
    String? phoneNumber,
    String? busRoute,
    String? busStop,
    String? busId,
    String? routeId,
    String? className,
    File? profileImage,
    String? emergencyContact,
    String? uuid,
    String? busName,
  })  : _name = name,
        _collegeName = collegeName,
        _department = department,
        _studentprofileClass = studentprofileClass,
        _email = email,
        _phoneNumber = phoneNumber,
        _busRoute = busRoute,
        _busStop = busStop,
        _busId = busId,
        _routeId = routeId,
        _profileImage = profileImage,
        _emergencyContact = emergencyContact,
        _uuid = uuid,
        _className = className,
        _busName = busName;

  factory Studentprofile.fromJson(Map<String, dynamic> json) => Studentprofile(
        name: json["name"],
        collegeName: json["college_name"],
        department: json["department"],
        studentprofileClass: json["class"],
        email: json["email"],
        phoneNumber: json["phone_number"],
        busRoute: json["bus_route"],
        busStop: json["bus_stop"],
        className: json["class"],
        busId: json["bus_id"],
        routeId: json["route_id"],
        profileImage: json["profile_image"],
        emergencyContact: json["emergency_contact"],
        uuid: json["uuid"],
        busName: json["bus_name"],
      );

  Map<String, dynamic> toJson() => {
        "name": _name,
        "college_name": _collegeName,
        "department": _department,
        "class": _className,
        "email": _email,
        "phone_number": _phoneNumber,
        "bus_route": _busRoute,
        "bus_stop": _busStop,
        "bus_id": _busId,
        "route_id": _routeId,
        "profile_image": _profileImage,
        "emergency_contact": _emergencyContact,
        "uuid": _uuid,
        "bus_name": _busName,
      };

  // Getters and Setters

  String? get name => _name;
  void setname(String value) {
    _name = value;
    notifyListeners();
  }

  String? get collegeName => _collegeName;
  void setcollegeName(String value) {
    _collegeName = value;
    notifyListeners();
  }

  String? get department => _department;
  void setdepartment(String value) {
    _department = value;
    notifyListeners();
  }

  String? get studentprofileClass => _studentprofileClass;
  void setstudentprofileClass(String value) {
    _studentprofileClass = value;
    notifyListeners();
  }

  String? get email => _email;
  void setemail(String value) {
    _email = value;
    notifyListeners();
  }

  String? get className => _className;
  void setClass(String value) {
    _className = value;
    notifyListeners();
  }

  String? get phoneNumber => _phoneNumber;
  void setphoneNumber(String value) {
    _phoneNumber = value;
    notifyListeners();
  }

  String? get busRoute => _busRoute;
  void setbusRoute(String value) {
    _busRoute = value;
    notifyListeners();
  }

  String? get busStop => _busStop;
  void setbusStop(String value) {
    _busStop = value;
    notifyListeners();
  }

  String? get busId => _busId;
  void setbusId(String value) {
    _busId = value;
    notifyListeners();
  }

  String? get routeId => _routeId;
  void setrouteId(String value) {
    _routeId = value;
    notifyListeners();
  }

  File? get profileImage => _profileImage;
  void setprofileImage(File? value) {
    _profileImage = value;
    notifyListeners();
  }

  String? get emergencyContact => _emergencyContact;
  void setemergencyContact(String value) {
    _emergencyContact = value;
    notifyListeners();
  }

  String? get uuid => _uuid;
  void setuuid(String value) {
    _uuid = value;
    notifyListeners();
  }

  String? get busName => _busName;
  void setbusName(String value) {
    _busName = value;
    notifyListeners();
  }
}
