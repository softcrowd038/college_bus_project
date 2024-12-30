import 'dart:convert';

List<LocationModel> locationModelFromJson(String str) => List<LocationModel>.from(json.decode(str).map((x) => LocationModel.fromJson(x)));

String locationModelToJson(List<LocationModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LocationModel {
    final int id;
    final String lattitude;
    final String longitude;
    final String location;
    final int busId;

    LocationModel({
        required this.id,
        required this.lattitude,
        required this.longitude,
        required this.location,
        required this.busId,
    });

    factory LocationModel.fromJson(Map<String, dynamic> json) => LocationModel(
        id: json["id"],
        lattitude: json["lattitude"],
        longitude: json["longitude"],
        location: json["location"],
        busId: json["bus_id"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "lattitude": lattitude,
        "longitude": longitude,
        "location": location,
        "bus_id": busId,
    };
}
