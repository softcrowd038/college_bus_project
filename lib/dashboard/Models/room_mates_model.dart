
import 'dart:convert';

List<BusMateProfile> busMateProfileFromJson(String str) => List<BusMateProfile>.from(json.decode(str).map((x) => BusMateProfile.fromJson(x)));

String busMateProfileToJson(List<BusMateProfile> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BusMateProfile {
    final int studentId;
    final String name;
    final String collegeName;
    final String department;
    final String busMateProfileClass;
    final String email;
    final String uuid;
    final String phoneNumber;
    final String busRoute;
    final String busStop;
    final int busId;
    final int routeId;
    final String profileImage;
    final DateTime passValidity;
    final String emergencyContact;

    BusMateProfile({
        required this.studentId,
        required this.name,
        required this.collegeName,
        required this.department,
        required this.busMateProfileClass,
        required this.email,
        required this.uuid,
        required this.phoneNumber,
        required this.busRoute,
        required this.busStop,
        required this.busId,
        required this.routeId,
        required this.profileImage,
        required this.passValidity,
        required this.emergencyContact,
    });

    factory BusMateProfile.fromJson(Map<String, dynamic> json) => BusMateProfile(
        studentId: json["student_id"],
        name: json["name"],
        collegeName: json["college_name"],
        department: json["department"],
        busMateProfileClass: json["class"],
        email: json["email"],
        uuid: json["uuid"],
        phoneNumber: json["phone_number"],
        busRoute: json["bus_route"],
        busStop: json["bus_stop"],
        busId: json["bus_id"],
        routeId: json["route_id"],
        profileImage: json["profile_image"],
        passValidity: DateTime.parse(json["pass_validity"]),
        emergencyContact: json["emergency_contact"],
    );

    Map<String, dynamic> toJson() => {
        "student_id": studentId,
        "name": name,
        "college_name": collegeName,
        "department": department,
        "class": busMateProfileClass,
        "email": email,
        "uuid": uuid,
        "phone_number": phoneNumber,
        "bus_route": busRoute,
        "bus_stop": busStop,
        "bus_id": busId,
        "route_id": routeId,
        "profile_image": profileImage,
        "pass_validity": "${passValidity.year.toString().padLeft(4, '0')}-${passValidity.month.toString().padLeft(2, '0')}-${passValidity.day.toString().padLeft(2, '0')}",
        "emergency_contact": emergencyContact,
    };
}
