import 'package:flutter/material.dart';
import '../screens/ItineraryDetailScreen.dart';
import '../screens/CreateItineraryScreen.dart';
import '../models/itinerary_model.dart';

class ItineraryListScreen extends StatefulWidget {
  const ItineraryListScreen({super.key});

  @override
  State<ItineraryListScreen> createState() => _ItineraryListScreenState();
}

class _ItineraryListScreenState extends State<ItineraryListScreen> {
  final List<Itinerary> itineraries = [
    Itinerary(
      destination: "Kuala Lumpur",
      purpose: "Travel",
      days: 3,
      nights: 2,
      imageUrl: "assets/images/singapore_skyline.jpg",
    ),
  ];

  String selectedFilter = 'All';
  final List<FilterOption> filterOptions = [
    FilterOption(label: 'All', icon: Icons.grid_view),
    FilterOption(label: 'Travel', icon: Icons.card_travel),
    FilterOption(label: 'Business', icon: Icons.business),
    FilterOption(label: 'Education', icon: Icons.school),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Itinerary'),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter options
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: filterOptions.map((option) {
                final isSelected = selectedFilter == option.label;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    selected: isSelected,
                    showCheckmark: false,
                    label: Row(
                      children: [
                        Icon(
                          option.icon,
                          size: 16,
                          color: isSelected ? Colors.white : Colors.black54,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          option.label,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black54,
                          ),
                        ),
                      ],
                    ),
                    backgroundColor: Colors.transparent,
                    selectedColor: const Color(0xFFCE816D),
                    side: BorderSide(
                      color: isSelected ? Colors.transparent : Colors.black12,
                    ),
                    onSelected: (bool selected) {
                      setState(() {
                        selectedFilter = option.label;
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: itineraries.length,
              itemBuilder: (context, index) {
                final itinerary = itineraries[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.grey.shade200),
                  ),
                  child: InkWell(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ItineraryDetailScreen(
                          destination: itinerary.destination,
                          days: itinerary.days,
                          nights: itinerary.nights,
                          purpose: itinerary.purpose,
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Itinerary ${index + 1}',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.more_vert),
                                onPressed: () {},
                              ),
                            ],
                          ),
                          Text(
                            '${itinerary.days}D${itinerary.nights}N ${itinerary.destination}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFEBE8),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              itinerary.purpose,
                              style: const TextStyle(
                                color: Color(0xFFCE816D),
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: SizedBox(
        width: MediaQuery.of(context).size.width - 32,
        child: FloatingActionButton.extended(
          backgroundColor: const Color(0xFFCE816D),
          onPressed: () => _createItinerary(),
          label: const Text('Create Itinerary'),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Future<void> _createItinerary() async {
    final result = await Navigator.push<Itinerary>(
      context,
      MaterialPageRoute(
        builder: (context) => CreateItineraryScreen(
          existingItinerariesCount: itineraries.length,
        ),
      ),
    );

    if (result != null) {
      setState(() {
        itineraries.add(result);
      });
    }
  }
}

class FilterOption {
  final String label;
  final IconData icon;

  FilterOption({required this.label, required this.icon});
}
