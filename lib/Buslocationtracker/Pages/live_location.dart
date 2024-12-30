import 'dart:async';
import 'package:college_bus_project/Buslocationtracker/provider/location_provider.dart';
import 'package:college_bus_project/GoogleMapIntegration/Provider/location_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';

class LiveLocationTracker extends StatefulWidget {
  const LiveLocationTracker({super.key});

  @override
  LiveLocationTrackerState createState() => LiveLocationTrackerState();
}

class LiveLocationTrackerState extends State<LiveLocationTracker> {
  GoogleMapController? mapController;
  Timer? _locationTimer;
  LatLng? apiLocation;
  LatLng? deviceLocation;
  double? distanceBetweenLocations;

  @override
  void initState() {
    super.initState();

    // Request location permissions and get the device's location
    final deviceProvider =
        Provider.of<LocationProvider>(context, listen: false);
    deviceProvider.requestLocationPermissionAndGetCurrentLocation();

    // Periodically fetch location data from the API
    _locationTimer = Timer.periodic(const Duration(seconds: 2), (timer) async {
      final apiProvider =
          Provider.of<LocationAPIProvider>(context, listen: false);
      await apiProvider.fetchLatLongIds();
      final locations = apiProvider.locations;

      if (locations.isNotEmpty) {
        final lat = double.tryParse(locations[0].lattitude) ?? 0.0;
        final lng = double.tryParse(locations[0].longitude) ?? 0.0;

        setState(() {
          apiLocation = LatLng(lat, lng);

          // Update the map and calculate the distance
          _updateMap(deviceProvider.currentPosition, apiLocation);
        });
      }
    });
  }

  @override
  void dispose() {
    mapController?.dispose();
    _locationTimer?.cancel();
    super.dispose();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _updateMap(LatLng? deviceLocation, LatLng? apiLocation) {
    if (deviceLocation != null && apiLocation != null) {
      // Calculate the distance between the two locations
      distanceBetweenLocations = Geolocator.distanceBetween(
        deviceLocation.latitude,
        deviceLocation.longitude,
        apiLocation.latitude,
        apiLocation.longitude,
      );

      // Move the camera to focus on the device location
      if (mapController != null) {
        mapController!.animateCamera(
          CameraUpdate.newLatLngBounds(
            LatLngBounds(
              southwest: LatLng(
                apiLocation.latitude < deviceLocation.latitude
                    ? apiLocation.latitude
                    : deviceLocation.latitude,
                apiLocation.longitude < deviceLocation.longitude
                    ? apiLocation.longitude
                    : deviceLocation.longitude,
              ),
              northeast: LatLng(
                apiLocation.latitude > deviceLocation.latitude
                    ? apiLocation.latitude
                    : deviceLocation.latitude,
                apiLocation.longitude > deviceLocation.longitude
                    ? apiLocation.longitude
                    : deviceLocation.longitude,
              ),
            ),
            50,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceProvider = Provider.of<LocationProvider>(context);

    deviceLocation = deviceProvider.currentPosition;

    return Scaffold(
      backgroundColor: Colors.white,
      body: deviceLocation == null || apiLocation == null
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: deviceLocation!,
                zoom: 13.5,
              ),
              myLocationEnabled: true,
              compassEnabled: true,
              mapType: MapType.normal,
              markers: {
                // Device location marker
                // Marker(
                //   markerId: const MarkerId('device_location'),
                //   position: deviceLocation!,
                //   infoWindow: InfoWindow(
                //     title: 'Device Location',
                //     snippet:
                //         'Latitude: ${deviceLocation!.latitude}, Longitude: ${deviceLocation!.longitude}',
                //   ),
                // ),
                // API location marker
                Marker(
                  markerId: const MarkerId('api_location'),
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueRed),
                  position: apiLocation!,
                  infoWindow: InfoWindow(
                    title: 'Bus Location',
                    snippet:
                        'Latitude: ${apiLocation!.latitude}, Longitude: ${apiLocation!.longitude}',
                  ),
                ),
              },
              // polylines: {
              //   if (deviceLocation != null && apiLocation != null)
              //     Polyline(
              //       polylineId: const PolylineId('route'),
              //       color: Colors.black,
              //       width: 5,
              //       points: [deviceLocation!, apiLocation!],
              //     ),
              // },
            ),
      floatingActionButton: distanceBetweenLocations != null
          ? FloatingActionButton.extended(
              onPressed: () {},
              label: Text(
                  'Distance: ${(distanceBetweenLocations! / 1000).toStringAsFixed(2)} km'),
              icon: const Icon(Icons.directions),
            )
          : null,
    );
  }
}
