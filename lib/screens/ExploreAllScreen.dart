import 'package:flutter/material.dart';

class ExploreAllScreen extends StatefulWidget {
  final String title;
  final List<Map<String, dynamic>> places;

  const ExploreAllScreen({
    super.key,
    required this.title,
    required this.places,
  });

  @override
  State<ExploreAllScreen> createState() => _ExploreAllScreenState();
}

class _ExploreAllScreenState extends State<ExploreAllScreen> {
  String selectedCategory = 'All';
  List<Map<String, dynamic>> filteredPlaces = [];
  final Map<String, IconData> categories = {
    'All': Icons.grid_view,
    'Restaurant': Icons.restaurant_outlined,
    'Park': Icons.park_outlined,
    'Entertainment': Icons.local_activity_outlined,
  };

  @override
  void initState() {
    super.initState();
    filteredPlaces = List.from(widget.places);
  }

  void _filterPlaces(String category) {
    setState(() {
      selectedCategory = category;
      if (category == 'All') {
        filteredPlaces = List.from(widget.places);
      } else {
        filteredPlaces =
            widget.places.where((place) => place['type'] == category).toList();
      }
    });
  }

  void _addToItinerary(BuildContext context, Map<String, dynamic> place) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${place['name']} added to itinerary'),
        backgroundColor: const Color(0xFFCE7D66),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            scrollDirection: Axis.horizontal,
            child: Row(
              children: categories.entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    selected: selectedCategory == entry.key,
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(entry.value, size: 16),
                        const SizedBox(width: 4),
                        Text(entry.key),
                      ],
                    ),
                    onSelected: (selected) => _filterPlaces(entry.key),
                    backgroundColor: Colors.transparent,
                    selectedColor: const Color(0xFFCE7D66),
                    labelStyle: TextStyle(
                      color: selectedCategory == entry.key
                          ? Colors.white
                          : Colors.grey,
                    ),
                    shape: StadiumBorder(
                      side: BorderSide(
                        color: selectedCategory == entry.key
                            ? const Color(0xFFCE7D66)
                            : Colors.grey,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: filteredPlaces.isEmpty
                ? const Center(
                    child: Text('No places found'),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: filteredPlaces.length,
                    itemBuilder: (context, index) {
                      final place = filteredPlaces[index];
                      return GestureDetector(
                        onTap: () {
                          // Handle place tap
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(16)),
                                    child: Image.asset(
                                      place['image'],
                                      height: 160,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: GestureDetector(
                                      onTap: () =>
                                          _addToItinerary(context, place),
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
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      place['name'],
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Icon(Icons.location_on,
                                            size: 14, color: Colors.grey),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            place['location'],
                                            style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 12,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFCE7D66)
                                            .withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        place['type'],
                                        style: const TextStyle(
                                          color: Color(0xFFCE7D66),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        const Icon(Icons.star,
                                            color: Colors.amber, size: 14),
                                        const SizedBox(width: 4),
                                        Text(
                                          place['rating'].toString(),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                        Text(
                                          ' (${place['reviews']} Reviews)',
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (place['price'] != null) ...[
                                      const SizedBox(height: 4),
                                      Text(
                                        '\$${place['price'].toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFFCE7D66),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
