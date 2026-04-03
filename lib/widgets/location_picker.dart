import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

class LocationPicker extends StatefulWidget {
  final Function(LatLng coordinates, String address) onLocationSelected;

  const LocationPicker({super.key, required this.onLocationSelected});

  @override
  State<LocationPicker> createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  LatLng? _currentPosition;
  LatLng? _selectedPosition;
  String? _selectedAddress;
  GoogleMapController? _mapController;
  bool _isLoading = true;
  double _distance = 0.0;
  final double _maxAllowedDistance = 100.0; // meters

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permission denied')),
        );
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
      _selectedPosition = _currentPosition;
      _isLoading = false;
    });
    _updateAddress(_selectedPosition!);
    _mapController?.animateCamera(CameraUpdate.newLatLngZoom(_selectedPosition!, 15));
  }

  Future<void> _updateAddress(LatLng position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        setState(() {
          _selectedAddress = '${place.street}, ${place.locality}, ${place.country}';
        });
      }
    } catch (e) {
      setState(() {
        _selectedAddress = 'Unknown location';
      });
    }
  }

  void _onMapTap(LatLng tappedPoint) {
    setState(() {
      _selectedPosition = tappedPoint;
    });
    _updateAddress(tappedPoint);
    _calculateDistance();
  }

  void _calculateDistance() {
    if (_currentPosition == null || _selectedPosition == null) return;
    double distance = Geolocator.distanceBetween(
      _currentPosition!.latitude,
      _currentPosition!.longitude,
      _selectedPosition!.latitude,
      _selectedPosition!.longitude,
    );
    setState(() {
      _distance = distance;
    });
  }

  void _confirmLocation() {
    if (_selectedPosition == null || _selectedAddress == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a location')),
      );
      return;
    }

    if (_distance > _maxAllowedDistance) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Location Mismatch'),
          content: Text(
            'The selected location is ${_distance.toStringAsFixed(0)} meters away from your current device location.\n\n'
            'For accurate training location, please select a point within ${_maxAllowedDistance.toStringAsFixed(0)} meters of your current position.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Go Back'),
            ),
          ],
        ),
      );
      return;
    }

    widget.onLocationSelected(_selectedPosition!, _selectedAddress!);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Training Location'),
        actions: [
          TextButton(
            onPressed: _confirmLocation,
            child: const Text('Confirm'),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: _currentPosition!,
                      zoom: 15,
                    ),
                    onMapCreated: (controller) => _mapController = controller,
                    onTap: _onMapTap,
                    markers: {
                      if (_currentPosition != null)
                        Marker(
                          markerId: const MarkerId('current'),
                          position: _currentPosition!,
                          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
                          infoWindow: const InfoWindow(title: 'Your device location'),
                        ),
                      if (_selectedPosition != null)
                        Marker(
                          markerId: const MarkerId('selected'),
                          position: _selectedPosition!,
                          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
                          infoWindow: const InfoWindow(title: 'Selected training location'),
                        ),
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _selectedAddress ?? 'Tap on map to select location',
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.location_on, size: 16),
                          const SizedBox(width: 4),
                          Text('Distance from device: ${_distance.toStringAsFixed(0)} m'),
                          const SizedBox(width: 16),
                          if (_distance > _maxAllowedDistance)
                            const Icon(Icons.warning, color: Colors.red, size: 16),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}