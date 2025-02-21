// To parse this JSON data, do
//
//     final routeDetails = routeDetailsFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/material.dart';

List<RouteDetails> routeDetailsFromJson(String str) => List<RouteDetails>.from(
    json.decode(str).map((x) => RouteDetails.fromJson(x)));

String routeDetailsToJson(List<RouteDetails> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RouteDetails extends ChangeNotifier {
  int? id;
  String? routeName;
  String? startingPoint;
  String? endingPoint;
  String? distance;
  String? remark;
  String? stops;

  RouteDetails({
    this.id,
    this.routeName,
    this.startingPoint,
    this.endingPoint,
    this.distance,
    this.remark,
    this.stops,
  });

  factory RouteDetails.fromJson(Map<String, dynamic> json) => RouteDetails(
        id: json["id"],
        routeName: json["route_name"],
        startingPoint: json["starting_point"],
        endingPoint: json["ending_point"],
        distance: json["distance"],
        remark: json["remark"],
        stops: json["stops"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "route_name": routeName,
        "starting_point": startingPoint,
        "ending_point": endingPoint,
        "distance": distance,
        "remark": remark,
        "stops": stops,
      };
}
