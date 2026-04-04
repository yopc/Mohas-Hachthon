
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../providers/training_provider.dart';
import '../theme/app_theme2.dart';

class TrainingMapScreen extends StatefulWidget {
  const TrainingMapScreen({super.key});

  @override
  State<TrainingMapScreen> createState() => _TrainingMapScreenState();
}

class _TrainingMapScreenState extends State<TrainingMapScreen> {
  final Set<Marker> _markers = {};
  GoogleMapController? _mapController;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadTrainings();
    });
  }

  Future<void> _loadTrainings() async {
    final provider = Provider.of<TrainingProvider>(context, listen: false);
    // Ensure the stream is started
    provider.fetchTrainings();

    // Wait a moment for data to load (or use a listener)
    await Future.delayed(const Duration(milliseconds: 500));

    final trainings = provider.trainings;
    if (trainings.isEmpty) {
      setState(() => _isLoading = false);
      return;
    }

    final markers = <Marker>{};
    for (var training in trainings) {
      final lat = training.locationCoordinates.latitude;
      final lng = training.locationCoordinates.longitude;
      markers.add(
        Marker(
          markerId: MarkerId(training.id),
          position: LatLng(lat, lng),
          infoWindow: InfoWindow(
            title: training.title,
            snippet: '${training.module}\n${training.locationAddress}\n${_formatDate(training.date)}',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            training.date.isAfter(DateTime.now()) ? BitmapDescriptor.hueGreen : BitmapDescriptor.hueRed,
          ),
        ),
      );
    }

    setState(() {
      _markers.clear();
      _markers.addAll(markers);
      _isLoading = false;
    });

    // If there's at least one marker, center the map on the first one
    if (markers.isNotEmpty) {
      final first = markers.first;
      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(first.position, 12),
      );
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    if (!_isLoading && _markers.isNotEmpty) {
      final first = _markers.first;
      controller.animateCamera(CameraUpdate.newLatLngZoom(first.position, 12));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Training Locations Map'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _markers.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.map_outlined, size: 64, color: Colors.grey.shade400),
                      const SizedBox(height: 16),
                      Text(
                        'No training locations to display',
                        style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Schedule a training first',
                        style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                      ),
                    ],
                  ),
                )
              : GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: const CameraPosition(
                    target: LatLng(9.03, 38.74), // Center of Addis Ababa
                    zoom: 6,
                  ),
                  markers: _markers,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                ),
    );
  }

  String _formatDate(DateTime date) => '${date.day}/${date.month}/${date.year}';
}