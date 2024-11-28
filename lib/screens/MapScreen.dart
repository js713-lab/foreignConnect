import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import '../models/place.dart';
import 'PlaceDetailScreen.dart';

class MapScreen extends StatefulWidget {
  final List<Place> places;
  final LatLng initialPosition;

  const MapScreen({
    super.key,
    required this.places,
    this.initialPosition = const LatLng(1.3521, 103.8198),
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  final Map<MarkerId, Marker> _markers = {};
  final double _defaultZoom = 12.0;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      _hasError = true;
    });
    _createMarkers();
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  Future<void> _updateMapWithLocationsFromFirestore() async {
    if (_hasError) return;

    try {
      final locations = await _getLocationsFromFirestore();
      if (mounted) {
        _addMarkersFromLocations(locations);
        _moveMapToFitLocations(locations);
      }
    } catch (e) {
      debugPrint('Error updating locations: $e');
      if (mounted) {
        setState(() {
          _hasError = true;
        });
      }
    }
  }

  Future<List<GeoPoint>> _getLocationsFromFirestore() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('locations').get();
      return snapshot.docs
          .map((doc) => doc.data()['location'] as GeoPoint)
          .toList();
    } catch (e) {
      debugPrint('Firestore error: $e');
      throw Exception('Failed to load locations');
    }
  }

  void _addMarkersFromLocations(List<GeoPoint> locations) {
    if (_hasError) return;

    setState(() {
      for (var location in locations) {
        final markerId = MarkerId('${location.latitude}-${location.longitude}');
        _markers[markerId] = Marker(
          markerId: markerId,
          position: LatLng(location.latitude, location.longitude),
        );
      }
    });
  }

  void _moveMapToFitLocations(List<GeoPoint> locations) {
    if (locations.isEmpty || _mapController == null || _hasError) return;

    try {
      final bounds = _calculateBounds(locations);
      _mapController?.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
    } catch (e) {
      debugPrint('Error moving camera: $e');
    }
  }

  LatLngBounds _calculateBounds(List<GeoPoint> locations) {
    var south = locations[0].latitude;
    var north = locations[0].latitude;
    var west = locations[0].longitude;
    var east = locations[0].longitude;

    for (var location in locations) {
      south = min(south, location.latitude);
      north = max(north, location.latitude);
      west = min(west, location.longitude);
      east = max(east, location.longitude);
    }

    return LatLngBounds(
      southwest: LatLng(south, west),
      northeast: LatLng(north, east),
    );
  }

  void _createMarkers() {
    for (var place in widget.places) {
      final markerId = MarkerId(place.id);
      final marker = Marker(
        markerId: markerId,
        position: LatLng(place.latitude, place.longitude),
        infoWindow: InfoWindow(
          title: place.title,
          snippet: place.location,
        ),
        onTap: () => _onMarkerTapped(place),
      );
      _markers[markerId] = marker;
    }
  }

  void _onMarkerTapped(Place place) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlaceDetailScreen(place: place),
      ),
    );
  }

  Widget _buildFallbackMap() {
    return Stack(
      children: [
        // Fallback static map image
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                  // 'https://api.mapbox.com/styles/v1/mapbox/light-v10/static/103.8198,1.3521,12/1080x1920?access_token=YOUR_MAPBOX_TOKEN',
                  // Alternative URL if you don't have Mapbox token:
                  'https://cdn.britannica.com/72/126572-050-BC04332E/Singapore-skyline-Marina-Bay.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          // Fallback if network image fails
          child: Image.asset(
            'assets/images/map_fallback.png',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey[200],
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.map_outlined,
                        size: 64,
                        color: Color(0xFFCE7D66).withOpacity(0.5),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Map preview unavailable',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        // Semi-transparent overlay
        Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.white.withOpacity(0.1),
        ),
        // Error message overlay
        Positioned(
          top: 16,
          left: 16,
          right: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Color(0xFFCE7D66),
                  size: 20,
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Unable to load map. Showing preview image.',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 14,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _hasError = false;
                    });
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Color(0xFFCE7D66),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Maps'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: _hasError ? _buildFallbackMap() : _buildGoogleMap(),
      floatingActionButton: !_hasError && _mapController != null
          ? FloatingActionButton(
              onPressed: () {
                _mapController?.animateCamera(
                  CameraUpdate.newLatLngZoom(
                    widget.initialPosition,
                    _defaultZoom,
                  ),
                );
              },
              backgroundColor: const Color(0xFFCE7D66),
              child: const Icon(Icons.center_focus_strong),
            )
          : null,
    );
  }

  Widget _buildGoogleMap() {
    try {
      return GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
          target: widget.initialPosition,
          zoom: _defaultZoom,
        ),
        markers: Set<Marker>.of(_markers.values),
        onMapCreated: (GoogleMapController controller) {
          try {
            setState(() {
              _mapController = controller;
              _hasError = false;
            });
          } catch (e) {
            debugPrint('Error in onMapCreated: $e');
            setState(() {
              _hasError = true;
            });
          }
        },
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        zoomControlsEnabled: false,
      );
    } catch (e) {
      debugPrint('Error creating map: $e');
      setState(() {
        _hasError = true;
      });
      return _buildFallbackMap();
    }
  }
}
