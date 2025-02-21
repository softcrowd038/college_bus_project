import 'dart:convert';
import 'package:flutter/material.dart';

List<BusDetails> busDetailsFromJson(String str) =>
    List<BusDetails>.from(json.decode(str).map((x) => BusDetails.fromJson(x)));

String busDetailsToJson(List<BusDetails> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BusDetails extends ChangeNotifier {
  int? _busId;
  String? _busName;
  int? _routeId;
  String? _qrCode;
  int? _totalSeats;
  String? _busDriver;
  String? _driverContact;
  String? _remark;
  String? _dailyColor;
  int? _duplicateBusId;

  BusDetails({
    int? busId,
    String? busName,
    int? routeId,
    String? qrCode,
    int? totalSeats,
    String? busDriver,
    String? driverContact,
    String? remark,
    String? dailyColor,
    int? duplicateBusId,
  }) {
    _busId = busId;
    _busName = busName;
    _routeId = routeId;
    _qrCode = qrCode;
    _totalSeats = totalSeats;
    _busDriver = busDriver;
    _driverContact = driverContact;
    _remark = remark;
    _dailyColor = dailyColor;
    _duplicateBusId = duplicateBusId;
  }

  // Getters
  int? get busId => _busId;
  String? get busName => _busName;
  int? get routeId => _routeId;
  String? get qrCode => _qrCode;
  int? get totalSeats => _totalSeats;
  String? get busDriver => _busDriver;
  String? get driverContact => _driverContact;
  String? get remark => _remark;
  String? get dailyColor => _dailyColor;
  int? get duplicateBusId => _duplicateBusId;

  // Setters
  void setbusId(int? value) {
    _busId = value;
    notifyListeners();
  }

  void setbusName(String? value) {
    _busName = value;
    notifyListeners();
  }

  void setrouteId(int? value) {
    _routeId = value;
    notifyListeners();
  }

  void setqrCode(String? value) {
    _qrCode = value;
    notifyListeners();
  }

  void settotalSeats(int? value) {
    _totalSeats = value;
    notifyListeners();
  }

  void setbusDriver(String? value) {
    _busDriver = value;
    notifyListeners();
  }

  void setdriverContact(String? value) {
    _driverContact = value;
    notifyListeners();
  }

  void setremark(String? value) {
    _remark = value;
    notifyListeners();
  }

  void setdailyColor(String? value) {
    _dailyColor = value;
    notifyListeners();
  }

  void setduplicateBusId(int? value) {
    _duplicateBusId = value;
    notifyListeners();
  }

  factory BusDetails.fromJson(Map<String, dynamic> json) => BusDetails(
        busId: json["bus_id"],
        busName: json["bus_name"],
        routeId: json["route_id"],
        qrCode: json["qr_code"],
        totalSeats: json["total_seats"],
        busDriver: json["bus_driver"],
        driverContact: json["driver_contact"],
        remark: json["remark"],
        dailyColor: json["daily_color"],
        duplicateBusId: json["duplicate_bus_id"],
      );

  Map<String, dynamic> toJson() => {
        "bus_id": _busId,
        "bus_name": _busName,
        "route_id": _routeId,
        "qr_code": _qrCode,
        "total_seats": _totalSeats,
        "bus_driver": _busDriver,
        "driver_contact": _driverContact,
        "remark": _remark,
        "daily_color": _dailyColor,
        "duplicate_bus_id": _duplicateBusId,
      };
}
