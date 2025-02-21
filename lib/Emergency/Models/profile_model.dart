import 'dart:convert';

List<StudentProfile> studentProfileFromJson(String str) =>
    List<StudentProfile>.from(
        json.decode(str).map((x) => StudentProfile.fromJson(x)));

String studentProfileToJson(List<StudentProfile> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class StudentProfile {
  final int studentId;
  final String name;
  final String collegeName;
  final String department;
  final String studentProfileClass;
  final String email;
  final String uuid;
  final String phoneNumber;
  final String busRoute;
  final String busStop;
  final int busId;
  final String busName;
  final int routeId;
  final String profileImage;
  final String emergencyContact;

  StudentProfile({
    required this.studentId,
    required this.name,
    required this.collegeName,
    required this.department,
    required this.studentProfileClass,
    required this.email,
    required this.uuid,
    required this.phoneNumber,
    required this.busRoute,
    required this.busStop,
    required this.busId,
    required this.busName,
    required this.routeId,
    required this.profileImage,
    required this.emergencyContact,
  });

  factory StudentProfile.fromJson(Map<String, dynamic> json) => StudentProfile(
        studentId: json["student_id"],
        name: json["name"],
        collegeName: json["college_name"],
        department: json["department"],
        studentProfileClass: json["class"],
        email: json["email"],
        uuid: json["uuid"],
        phoneNumber: json["phone_number"],
        busRoute: json["bus_route"],
        busStop: json["bus_stop"],
        busId: json["bus_id"],
        busName: json["bus_name"],
        routeId: json["route_id"],
        profileImage: json["profile_image"],
        emergencyContact: json["emergency_contact"],
      );

  Map<String, dynamic> toJson() => {
        "student_id": studentId,
        "name": name,
        "college_name": collegeName,
        "department": department,
        "class": studentProfileClass,
        "email": email,
        "uuid": uuid,
        "phone_number": phoneNumber,
        "bus_route": busRoute,
        "bus_stop": busStop,
        "bus_id": busId,
        "bus_name": busName,
        "route_id": routeId,
        "profile_image": profileImage,
        "emergency_contact": emergencyContact,
      };
}
