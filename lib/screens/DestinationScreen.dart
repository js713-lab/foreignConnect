import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';
import '../screens/ItineraryScreen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/place.dart';
import '../screens/MapScreen.dart';
import 'ItineraryListScreen.dart';
import 'ExploreAllScreen.dart';
import 'PlaceDetailScreen.dart';

class DestinationScreen extends StatefulWidget {
  final String userName;
  const DestinationScreen({super.key, required this.userName});

  @override
  _DestinationScreenState createState() => _DestinationScreenState();
}

class _DestinationScreenState extends State<DestinationScreen> {
  List<Place> filteredPlaces = [];

  String currentLocation = 'Loading...';
  bool isLoading = true;
  String selectedCategory = 'All';
  String selectedDestination = 'Singapore';
  Position? _currentPosition;
  late GoogleMapController _mapController;
  final Set<Marker> _markers = {};
  Map<String, List<Place>> itineraryDays = {
    'Day 1': [],
    'Day 2': [],
    'Day 3': [],
  };

  late List<Place> allPlaces;

  void _showDestinationPicker() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 300,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text(
                'Choose Destination',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: destinations.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(destinations[index]),
                      onTap: () {
                        setState(() {
                          selectedDestination = destinations[index];
                        });
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _openMap() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MapScreen(
          places: allPlaces
              .where((place) => place.latitude != 0.0 && place.longitude != 0.0)
              .toList(), // Only pass places with valid coordinates
          initialPosition: LatLng(
            _currentPosition?.latitude ?? 1.3521,
            _currentPosition?.longitude ?? 103.8198,
          ),
        ),
      ),
    );
  }

  void _viewPlaceDetails(Map<String, dynamic> location) {
    final place = Place(
      id: location['id'] ?? '1',
      title: location['name'],
      description: location['description'] ?? 'A beautiful place to visit',
      location: location['location'],
      imageUrl: location['image'],
      type: location['type'] ?? 'Attraction',
      rating: location['rating'].toDouble(),
      reviewCount: location['reviews'],
      price: location['price'] ?? 0.0,
      duration: null,
      category: 'Must Visit',
      weather: null,
      timeZone: null,
      arrival: null,
      latitude: 0.0,
      longitude: 0.0,
      distance: 0.0,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlaceDetailScreen(place: place),
      ),
    );
  }

  void _toggleFavorite(int index) {
    setState(() {
      exploreLocations[index]['isFavorite'] =
          !exploreLocations[index]['isFavorite'];
    });
  }

  void _viewExploreAllPlaces() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExploreAllScreen(
          title: 'Explore Like Local',
          places: peopleLiked,
        ),
      ),
    );
  }

  void _createItinerary() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ItineraryListScreen(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _initializePlaces();
    getCurrentLocation();
  }

  void _initializePlaces() {
    allPlaces = [
      Place(
        id: '1',
        title: 'Marina Bay Sands',
        description: 'Iconic integrated resort',
        location: 'Marina Bay, Singapore',
        imageUrl: 'assets/mbs.jpg',
        type: 'Hotel',
        rating: 4.8,
        reviewCount: 128,
        price: 550.0,
        duration: '2h 25min flight',
        category: 'Must Visit',
        weather: 'Light rain | 24°C - 28°C',
        timeZone: '-1 Hour Time Difference',
        arrival: 'Malaysia 12:00 | Singapore 12:00',
        latitude: 1.2834,
        longitude: 103.8607,
        distance: 0.0,
      ),
      // Add more places here
    ];
    filteredPlaces = List.from(allPlaces);
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  Future<void> getCurrentLocation() async {
    try {
      var status = await Permission.location.request();
      if (status.isGranted) {
        setState(() => isLoading = true);
        Position position = await Geolocator.getCurrentPosition();
        _currentPosition = position;

        List<Placemark> locationMarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );

        if (locationMarks.isNotEmpty) {
          Placemark place = locationMarks[0];
          setState(() {
            currentLocation = '${place.locality}, ${place.country}';
            isLoading = false;
          });
          _initializeMap();
        }
      } else {
        setState(() {
          currentLocation = 'Location permission denied';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        currentLocation = 'Error getting location';
        isLoading = false;
      });
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _initializeMap();
  }

  void _initializeMap() {
    if (_currentPosition != null) {
      _markers.add(
        Marker(
          markerId: const MarkerId('current_location'),
          position:
              LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
          infoWindow: const InfoWindow(title: 'Current Location'),
        ),
      );
    }
  }

  Widget _buildMap() {
    return SizedBox(
      height: 300,
      child: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: LatLng(
            _currentPosition?.latitude ?? 0,
            _currentPosition?.longitude ?? 0,
          ),
          zoom: 14.0,
        ),
        markers: _markers,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
      ),
    );
  }

  void _showPlaceDetails(Map<String, dynamic> place) {
    final placeObj = Place(
      id: place['id'] ?? '1',
      title: place['name'],
      description: place['description'] ?? 'A beautiful place to visit',
      location: place['location'],
      imageUrl: place['image'],
      type: place['type'] ?? 'Attraction',
      rating: place['rating'].toDouble(),
      reviewCount: place['reviews'],
      price: place['price'] ?? 0.0,
      duration: null,
      category: 'Must Visit',
      weather: null,
      timeZone: null,
      arrival: null,
      latitude: 0.0,
      longitude: 0.0,
      distance: 0.0,
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.9,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (_, controller) {
            return Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Place Details',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      placeObj.imageUrl,
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    placeObj.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        placeObj.location,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        _addToItinerary(place);
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFCE7D66),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Add to Itinerary'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _addToItinerary(Map<String, dynamic> place) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Add to Day',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ...itineraryDays.entries.map((entry) {
                return ListTile(
                  title: Text(entry.key),
                  trailing: Text('${entry.value.length} places'),
                  onTap: () {
                    final newPlace = Place(
                      id: place['id'] ?? '1',
                      title: place['name'],
                      description:
                          place['description'] ?? 'A beautiful place to visit',
                      location: place['location'],
                      imageUrl: place['image'],
                      type: place['type'] ?? 'Attraction',
                      rating: place['rating'].toDouble(),
                      reviewCount: place['reviews'],
                      price: place['price'] ?? 0.0,
                      duration: null,
                      category: 'Must Visit',
                      weather: null,
                      timeZone: null,
                      arrival: null,
                      latitude: 0.0,
                      longitude: 0.0,
                      distance: 0.0,
                    );

                    setState(() {
                      entry.value.add(newPlace);
                    });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Added to ${entry.key}'),
                        backgroundColor: const Color(0xFFCE7D66),
                      ),
                    );
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }

  void _viewItinerary() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ItineraryDetailScreen(
          destination: 'Singapore',
          purpose: 'Travel',
          days: 3,
          nights: 2,
        ),
      ),
    );
  }

  Color _getCategoryColor(String type) {
    switch (type) {
      case 'Restaurant':
        return Colors.orange;
      case 'Park':
        return Colors.green;
      case 'Hotel':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  void _searchPlaces(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredPlaces = allPlaces;
      } else {
        filteredPlaces = allPlaces.where((place) {
          return place.title.toLowerCase().contains(query.toLowerCase()) ||
              place.location.toLowerCase().contains(query.toLowerCase()) ||
              (place.type.toLowerCase().contains(query.toLowerCase()) ?? false);
        }).toList();
      }
    });
  }

  final List<String> destinations = [
    'Singapore',
    'Kuala Lumpur',
    'Bangkok',
    'Tokyo',
    'Seoul'
  ];

  final List<Map<String, dynamic>> exploreCategories = [
    {'icon': Icons.grid_view, 'label': 'All'},
    {'icon': Icons.restaurant_outlined, 'label': 'Resturants'},
    {'icon': Icons.park_outlined, 'label': 'Parks'},
    {'icon': Icons.local_activity_outlined, 'label': 'Entertainment'},
  ];

  final List<Map<String, dynamic>> exploreLocations = [
    {
      'name': 'Marina Bay Park',
      'location': 'Marina, SG',
      'rating': 4.0,
      'reviews': 36,
      'image': 'assets/images/marina_park.jpg',
      'isFavorite': true,
    },
    {
      'name': 'Marina Mountains',
      'location': 'Marina, SG',
      'rating': 4.0,
      'reviews': 36,
      'image': 'assets/images/marina_mountains.jpg',
      'isFavorite': false,
    },
  ];

  final List<Map<String, dynamic>> peopleLiked = [
    {
      'name': 'Marina Cafe',
      'location': 'Marina, SG',
      'rating': 4.0,
      'reviews': 36,
      'price': 40.0,
      'image': 'assets/images/marina_cafe.jpg',
      'type': 'Restaurant',
      'isFavorite': true,
    },
    {
      'name': 'Marina Park Cafe',
      'location': 'Marina, SG',
      'rating': 4.0,
      'reviews': 36,
      'price': 40.0,
      'image': 'assets/images/marina_park_cafe.jpg',
      'type': 'Park',
      'isFavorite': false,
    },
  ];

  Widget _buildPeopleLikedItem(Map<String, dynamic> place, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              place['image'],
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      place['name'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          peopleLiked[index]['isFavorite'] =
                              !peopleLiked[index]['isFavorite'];
                        });
                      },
                      child: Icon(
                        place['isFavorite']
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: Colors.red,
                        size: 20,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 12, color: Colors.grey[600]),
                    Text(
                      place['location'],
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        place['type'],
                        style: const TextStyle(fontSize: 10),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '\$${place['price'].toStringAsFixed(1)}/night',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.star,
                      size: 12,
                      color: Colors.amber,
                    ),
                    Text(
                      ' ${place['rating']}',
                      style: const TextStyle(fontSize: 12),
                    ),
                    Text(
                      ' (${place['reviews']} Reviews)',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              color: const Color(0xFF1E1E1E),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome, ${widget.userName}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Location',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                currentLocation,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                              const Icon(Icons.keyboard_arrow_down,
                                  color: Colors.white),
                            ],
                          ),
                        ],
                      ),
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.white,
                        child: Image.asset('assets/gif/avatar.gif'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Search and Action Buttons
                  // Replace the existing action buttons with:
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: _showDestinationPicker,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            height: 44,
                            decoration: BoxDecoration(
                              color: Colors.grey[800],
                              borderRadius: BorderRadius.circular(22),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.search, color: Colors.grey),
                                const SizedBox(width: 8),
                                Text(
                                  selectedDestination,
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: _createItinerary,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFCE7D66),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.add, color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: _openMap,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFCE7D66),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.map_outlined,
                              color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Content
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Explore Like Local Section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Explore Like Local',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton(
                            onPressed: _viewExploreAllPlaces,
                            child: Text(
                              'View all',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Categories
                      SizedBox(
                        height: 40,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: exploreCategories.length,
                          itemBuilder: (context, index) {
                            final category = exploreCategories[index];
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedCategory = category['label'];
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.only(right: 8),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                decoration: BoxDecoration(
                                  color: selectedCategory == category['label']
                                      ? const Color(0xFFCE7D66)
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: Colors.grey[300]!),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      category['icon'],
                                      size: 18,
                                      color:
                                          selectedCategory == category['label']
                                              ? Colors.white
                                              : Colors.grey,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      category['label'],
                                      style: TextStyle(
                                        color: selectedCategory ==
                                                category['label']
                                            ? Colors.white
                                            : Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Explore Locations
                      SizedBox(
                        height: 180,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: exploreLocations.length,
                          itemBuilder: (context, index) {
                            final location = exploreLocations[index];
                            return GestureDetector(
                              onTap: () => _viewPlaceDetails(location),
                              child: Container(
                                width: 160,
                                margin: const EdgeInsets.only(right: 16),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  image: DecorationImage(
                                    image: AssetImage(location['image']),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: Stack(
                                  children: [
                                    Positioned(
                                      top: 8,
                                      right: 8,
                                      child: GestureDetector(
                                        onTap: () => _toggleFavorite(index),
                                        child: Icon(
                                          location['isFavorite']
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 8,
                                      left: 8,
                                      child: GestureDetector(
                                        onTap: () => _addToItinerary(location),
                                        child: Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(Icons.add,
                                              color: Color(0xFFCE7D66)),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 8,
                                      left: 8,
                                      right: 8,
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              location['name'],
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Icon(Icons.location_on,
                                                    size: 12,
                                                    color: Colors.grey[600]),
                                                Text(
                                                  location['location'],
                                                  style: TextStyle(
                                                    color: Colors.grey[600],
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.star,
                                                  size: 12,
                                                  color: Colors.amber,
                                                ),
                                                Text(
                                                  ' ${location['rating']}',
                                                  style: const TextStyle(
                                                      fontSize: 12),
                                                ),
                                                Text(
                                                  ' (${location['reviews']} Reviews)',
                                                  style: TextStyle(
                                                    color: Colors.grey[600],
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                      // People Liked Section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'People Liked',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton(
                            onPressed: _viewExploreAllPlaces,
                            child: Text(
                              'View all',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // People Liked List
                      ...peopleLiked
                          .asMap()
                          .entries
                          .map((entry) => GestureDetector(
                                onTap: () => _viewPlaceDetails(entry.value),
                                child: _buildPeopleLikedItem(
                                    entry.value, entry.key),
                              )),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
