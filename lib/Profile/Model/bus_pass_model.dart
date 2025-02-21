import 'dart:convert';
import 'package:flutter/material.dart';

BusPass busPassFromJson(String str) => BusPass.fromJson(json.decode(str));

String busPassToJson(BusPass data) => json.encode(data.toJson());

class BusPass extends ChangeNotifier {
  String? _studentId;
  String? _studentName;
  String? _busName;
  String? _routeName;
  String? _plan;
  String? _price;
  DateTime? _issueDate;
  DateTime? _expiryDate;

  BusPass({
    String? studentId,
    String? studentName,
    String? busName,
    String? routeName,
    String? plan,
    String? price,
    DateTime? issueDate,
    DateTime? expiryDate,
  })  : _studentId = studentId,
        _studentName = studentName,
        _busName = busName,
        _routeName = routeName,
        _plan = plan,
        _price = price,
        _issueDate = issueDate,
        _expiryDate = expiryDate;

  // Getters
  String? get studentId => _studentId;
  String? get studentName => _studentName;
  String? get busName => _busName;
  String? get routeName => _routeName;
  String? get plan => _plan;
  String? get price => _price;
  DateTime? get issueDate => _issueDate;
  DateTime? get expiryDate => _expiryDate;

  // Setters with notifyListeners()
  void setstudentId(String value) {
    _studentId = value;
    notifyListeners();
  }

  void setstudentName(String value) {
    _studentName = value;
    notifyListeners();
  }

  void setbusName(String value) {
    _busName = value;
    notifyListeners();
  }

  void setrouteName(String value) {
    _routeName = value;
    notifyListeners();
  }

  void setplan(String value) {
    _plan = value;
    notifyListeners();
  }

  void setprice(String value) {
    _price = value;
    notifyListeners();
  }

  void setissueDate(DateTime value) {
    _issueDate = value;
    notifyListeners();
  }

  void setexpiryDate(DateTime value) {
    _expiryDate = value;
    notifyListeners();
  }

  factory BusPass.fromJson(Map<String, dynamic> json) => BusPass(
        studentId: json["student_id"],
        studentName: json["student_name"],
        busName: json["bus_name"],
        routeName: json["route_name"],
        plan: json["plan"],
        price: json["price"],
        issueDate: DateTime.parse(json["issue_date"]),
        expiryDate: DateTime.parse(json["expiry_date"]),
      );

  Map<String, dynamic> toJson() => {
        "student_id": _studentId,
        "student_name": _studentName,
        "bus_name": _busName,
        "route_name": _routeName,
        "plan": _plan,
        "price": _price,
        "issue_date":
            "${_issueDate!.year.toString().padLeft(4, '0')}-${_issueDate!.month.toString().padLeft(2, '0')}-${_issueDate!.day.toString().padLeft(2, '0')}",
        "expiry_date":
            "${_expiryDate!.year.toString().padLeft(4, '0')}-${_expiryDate!.month.toString().padLeft(2, '0')}-${_expiryDate!.day.toString().padLeft(2, '0')}",
      };
}
