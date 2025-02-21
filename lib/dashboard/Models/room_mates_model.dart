class BusMateProfile {
  final int studentId;
  final String name;
  final String collegeName;
  final String department;
  final String studentClass;
  final String email;
  final String uuid;
  final String phoneNumber;
  final String busRoute;
  final String busStop;
  final int busId;
  final String busName;
  final int routeId;
  final String? profileImage;
  final String emergencyContact;

  BusMateProfile({
    required this.studentId,
    required this.name,
    required this.collegeName,
    required this.department,
    required this.studentClass,
    required this.email,
    required this.uuid,
    required this.phoneNumber,
    required this.busRoute,
    required this.busStop,
    required this.busId,
    required this.busName,
    required this.routeId,
    this.profileImage, // Allow null values
    required this.emergencyContact,
  });

  factory BusMateProfile.fromJson(Map<String, dynamic> json) {
    return BusMateProfile(
      studentId: json['student_id'] ?? 0,
      name: json['name'] ?? 'Unknown',
      collegeName: json['college_name'] ?? 'Unknown',
      department: json['department'] ?? 'Unknown',
      studentClass: json['class'] ?? 'Unknown',
      email: json['email'] ?? '',
      uuid: json['uuid'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      busRoute: json['bus_route'] ?? '',
      busStop: json['bus_stop'] ?? '',
      busId: json['bus_id'] ?? 0,
      busName: json['bus_name'] ?? '',
      routeId: json['route_id'] ?? 0,
      profileImage: json['profile_image'] ?? null,
      emergencyContact: json['emergency_contact'] ?? '',
    );
  }
}
