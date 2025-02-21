// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'package:college_bus_project/GoogleMapIntegration/Provider/location_provider.dart';
import 'package:college_bus_project/dashboard/components/seconadary_components/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LiveLocationTracker extends StatefulWidget {
  const LiveLocationTracker({super.key});

  @override
  LiveLocationTrackerState createState() => LiveLocationTrackerState();
}

class LiveLocationTrackerState extends State<LiveLocationTracker> {
  GoogleMapController? mapController;
  bool _isTextVisible = false;
  bool _showInitialMessage = true;
  bool _showCurrentAddress = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<LocationProvider>(context, listen: false)
          .requestLocationPermissionAndGetCurrentLocation();
    });

    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _showInitialMessage = false;
        });
      }
    });
  }

  @override
  void dispose() {
    mapController?.dispose();
    super.dispose();
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  void _handleTap() {
    setState(() {
      _isTextVisible = false;
    });
  }

  void _handleDoubleTap() {
    setState(() {
      _isTextVisible = true;

      _showCurrentAddress = true;

      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _showCurrentAddress = false;
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LocationProvider>(
      builder: (context, locationProvider, _) {
        LatLng? currentPosition = locationProvider.currentPosition;
        String? currentAddress = locationProvider.currentAddress;

        return GestureDetector(
          onTap: _handleTap,
          onDoubleTap: _handleDoubleTap,
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.30,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: [
                currentPosition == null
                    ? const Center(child: CircularProgressIndicator())
                    : GoogleMap(
                        onMapCreated: _onMapCreated,
                        initialCameraPosition: CameraPosition(
                          target: LatLng(
                            currentPosition.latitude,
                            currentPosition.longitude,
                          ),
                          zoom: 15,
                        ),
                        myLocationEnabled: true,
                        compassEnabled: true,
                        mapType: MapType.normal,
                        markers: {
                          Marker(
                            markerId: const MarkerId('current_location'),
                            position: currentPosition,
                            infoWindow: InfoWindow(
                              title: 'Current Location',
                              snippet: 'Latitude: ${currentPosition.latitude}, '
                                  'Longitude: ${currentPosition.longitude}',
                            ),
                          ),
                        },
                      ),
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                  bottom: _isTextVisible ? 10.0 : -100.0,
                  left: 10.0,
                  right: 10.0,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 500),
                    opacity: _isTextVisible ? 1.0 : 0.0,
                    child: _showCurrentAddress
                        ? Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: currentAddress != null
                                ? TextWidget(
                                    text1: currentAddress,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 16,
                                  )
                                : const Text(
                                    'Location not available',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                          )
                        : const SizedBox(),
                  ),
                ),
                if (_showInitialMessage)
                  Container(
                    height: MediaQuery.of(context).size.height * 0.30,
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                    ),
                    child: const Text(
                      'Double tap to see your current location',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
