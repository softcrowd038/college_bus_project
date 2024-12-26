import 'dart:convert';

List<StudentCheckInAndCheckOut> studentCheckInAndCheckOutFromJson(String str) =>
    List<StudentCheckInAndCheckOut>.from(
        json.decode(str).map((x) => StudentCheckInAndCheckOut.fromJson(x)));

String studentCheckInAndCheckOutToJson(List<StudentCheckInAndCheckOut> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class StudentCheckInAndCheckOut {
  final int id;
  final int studentId;
  final DateTime checkInTime;
  final dynamic checkOutTime;
  final String status;
  final DateTime createdAt;

  StudentCheckInAndCheckOut({
    required this.id,
    required this.studentId,
    required this.checkInTime,
    required this.checkOutTime,
    required this.status,
    required this.createdAt,
  });

  factory StudentCheckInAndCheckOut.fromJson(Map<dynamic, dynamic> json) =>
      StudentCheckInAndCheckOut(
        id: json["id"],
        studentId: json["student_id"],
        checkInTime: DateTime.parse(json["check_in_time"]),
        checkOutTime: json["check_out_time"],
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "student_id": studentId,
        "check_in_time": checkInTime.toIso8601String(),
        "check_out_time": checkOutTime,
        "status": status,
        "created_at": createdAt.toIso8601String(),
      };
}
