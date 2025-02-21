// To parse this JSON data, do
//
//     final busPassDetails = busPassDetailsFromJson(jsonString);

import 'dart:convert';

List<BusPassDetails> busPassDetailsFromJson(String str) =>
    List<BusPassDetails>.from(
        json.decode(str).map((x) => BusPassDetails.fromJson(x)));

String busPassDetailsToJson(List<BusPassDetails> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BusPassDetails {
  int passId;
  int studentId;
  String studentName;
  String busName;
  String routeName;
  String plan;
  String price;
  DateTime issueDate;
  DateTime expiryDate;
  String status;
  DateTime createdAt;
  DateTime updatedAt;

  BusPassDetails({
    required this.passId,
    required this.studentId,
    required this.studentName,
    required this.busName,
    required this.routeName,
    required this.plan,
    required this.price,
    required this.issueDate,
    required this.expiryDate,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BusPassDetails.fromJson(Map<String, dynamic> json) => BusPassDetails(
        passId: json["pass_id"],
        studentId: json["student_id"],
        studentName: json["student_name"],
        busName: json["bus_name"],
        routeName: json["route_name"],
        plan: json["plan"],
        price: json["price"],
        issueDate: DateTime.parse(json["issue_date"]),
        expiryDate: DateTime.parse(json["expiry_date"]),
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "pass_id": passId,
        "student_id": studentId,
        "student_name": studentName,
        "bus_name": busName,
        "route_name": routeName,
        "plan": plan,
        "price": price,
        "issue_date": issueDate.toIso8601String(),
        "expiry_date": expiryDate.toIso8601String(),
        "status": status,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
