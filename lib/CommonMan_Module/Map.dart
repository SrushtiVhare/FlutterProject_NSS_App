import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:async';

void main() {
  runApp(const RouteMapApp());
}

class RouteMapApp extends StatelessWidget {
  const RouteMapApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Route Planner',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const RouteMapScreen(),
    );
  }
}

class RouteMapScreen extends StatefulWidget {
  final String? destinationAddress;

  const RouteMapScreen({Key? key, this.destinationAddress}) : super(key: key);

  @override
  State<RouteMapScreen> createState() => _RouteMapScreenState();
}

class _RouteMapScreenState extends State<RouteMapScreen> {
  final TextEditingController _startLocationController =
      TextEditingController();
  final TextEditingController _endLocationController = TextEditingController();

  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  LatLng _initialPosition = const LatLng(18.5204, 73.8567); // Pune, India
  bool _isLoading = false;
  String? _distance;
  String? _duration;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();

    // Pre-fill destination if provided
    if (widget.destinationAddress != null &&
        widget.destinationAddress!.isNotEmpty) {
      _endLocationController.text = widget.destinationAddress!;
    }
  }

  @override
  void dispose() {
    _startLocationController.dispose();
    _endLocationController.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );

        setState(() {
          _initialPosition = LatLng(position.latitude, position.longitude);
        });

        _mapController?.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: _initialPosition, zoom: 14),
          ),
        );

        List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );

        if (placemarks.isNotEmpty) {
          Placemark place = placemarks[0];
          _startLocationController.text =
              '${place.street}, ${place.locality}, ${place.administrativeArea}';
        }
      }
    } catch (e) {
      log('Error getting location: $e');
    }
  }

  Future<LatLng?> _getCoordinatesFromAddress(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        return LatLng(locations[0].latitude, locations[0].longitude);
      }
    } catch (e) {
      log('Error geocoding address: $e');
    }
    return null;
  }

  void _searchRoute() async {
    if (_startLocationController.text.isEmpty ||
        _endLocationController.text.isEmpty) {
      _showMessage(
        'Please enter both starting and ending locations',
        Colors.red,
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _markers.clear();
      _polylines.clear();
    });

    try {
      LatLng? startCoords = await _getCoordinatesFromAddress(
        _startLocationController.text,
      );
      LatLng? endCoords = await _getCoordinatesFromAddress(
        _endLocationController.text,
      );

      if (startCoords == null || endCoords == null) {
        _showMessage('Could not find one or both locations', Colors.red);
        setState(() => _isLoading = false);
        return;
      }

      // Add markers
      setState(() {
        _markers.add(
          Marker(
            markerId: const MarkerId('start'),
            position: startCoords,
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueGreen,
            ),
            infoWindow: InfoWindow(
              title: 'Start',
              snippet: _startLocationController.text,
            ),
          ),
        );

        _markers.add(
          Marker(
            markerId: const MarkerId('end'),
            position: endCoords,
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueRed,
            ),
            infoWindow: InfoWindow(
              title: 'End',
              snippet: _endLocationController.text,
            ),
          ),
        );

        // Draw simple straight line (in production, use Google Directions API)
        _polylines.add(
          Polyline(
            polylineId: const PolylineId('route'),
            points: [startCoords, endCoords],
            color: Colors.blue,
            width: 5,
          ),
        );
      });

      // Calculate distance
      double distanceInMeters = Geolocator.distanceBetween(
        startCoords.latitude,
        startCoords.longitude,
        endCoords.latitude,
        endCoords.longitude,
      );

      setState(() {
        _distance = '${(distanceInMeters / 1000).toStringAsFixed(2)} km';
        _duration =
            '${(distanceInMeters / 1000 / 40 * 60).toStringAsFixed(0)} min';
      });

      // Adjust camera to show both markers
      LatLngBounds bounds = LatLngBounds(
        southwest: LatLng(
          startCoords.latitude < endCoords.latitude
              ? startCoords.latitude
              : endCoords.latitude,
          startCoords.longitude < endCoords.longitude
              ? startCoords.longitude
              : endCoords.longitude,
        ),
        northeast: LatLng(
          startCoords.latitude > endCoords.latitude
              ? startCoords.latitude
              : endCoords.latitude,
          startCoords.longitude > endCoords.longitude
              ? startCoords.longitude
              : endCoords.longitude,
        ),
      );

      _mapController?.animateCamera(CameraUpdate.newLatLngBounds(bounds, 100));

      _showMessage('Route found!', Colors.green);
    } catch (e) {
      _showMessage('Error finding route: $e', Colors.red);
    }

    setState(() => _isLoading = false);
  }

  void _swapLocations() {
    final temp = _startLocationController.text;
    _startLocationController.text = _endLocationController.text;
    _endLocationController.text = temp;
  }

  void _clearFields() {
    _startLocationController.clear();
    _endLocationController.clear();
    setState(() {
      _markers.clear();
      _polylines.clear();
      _distance = null;
      _duration = null;
    });
  }

  void _showMessage(String message, Color color) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message), backgroundColor: color));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Route Planner'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Google Map
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _initialPosition,
              zoom: 14,
            ),
            onMapCreated: (controller) {
              _mapController = controller;
            },
            markers: _markers,
            polylines: _polylines,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            zoomControlsEnabled: false,
          ),

          // Input Panel
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // Starting Location
                      TextField(
                        controller: _startLocationController,
                        decoration: InputDecoration(
                          hintText: 'Starting location',
                          prefixIcon: const Icon(
                            Icons.trip_origin,
                            color: Colors.green,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade50,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Swap Button
                      IconButton(
                        onPressed: _swapLocations,
                        icon: const Icon(Icons.swap_vert),
                        iconSize: 28,
                        color: Colors.blue,
                      ),

                      const SizedBox(height: 8),

                      // Ending Location
                      TextField(
                        controller: _endLocationController,
                        decoration: InputDecoration(
                          hintText: 'Ending location',
                          prefixIcon: const Icon(
                            Icons.location_on,
                            color: Colors.red,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade50,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Action Buttons
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _isLoading ? null : _searchRoute,
                              icon: _isLoading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Icon(Icons.search),
                              label: Text(
                                _isLoading ? 'Searching...' : 'Search Route',
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton(
                            onPressed: _clearFields,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey.shade300,
                              foregroundColor: Colors.black87,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 14,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Icon(Icons.clear),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Distance and Duration Info
          if (_distance != null && _duration != null)
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        const Icon(Icons.straighten, color: Colors.blue),
                        const SizedBox(height: 4),
                        Text(
                          _distance!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const Text('Distance', style: TextStyle(fontSize: 12)),
                      ],
                    ),
                    Container(
                      width: 1,
                      height: 40,
                      color: Colors.grey.shade300,
                    ),
                    Column(
                      children: [
                        const Icon(Icons.access_time, color: Colors.blue),
                        const SizedBox(height: 4),
                        Text(
                          _duration!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const Text('Duration', style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
