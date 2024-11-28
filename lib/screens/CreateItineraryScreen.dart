import 'package:flutter/material.dart';
import '../models/itinerary_model.dart';

class CreateItineraryScreen extends StatefulWidget {
  final int existingItinerariesCount;

  const CreateItineraryScreen({
    super.key,
    required this.existingItinerariesCount,
  });

  @override
  _CreateItineraryScreenState createState() => _CreateItineraryScreenState();
}

class _CreateItineraryScreenState extends State<CreateItineraryScreen> {
  String? selectedStartingPoint;
  String? selectedDestination;
  String? selectedPurpose;
  int days = 3;
  int nights = 2;
  bool showError = false;

  // List of available starting points
  final List<String> startingPoints = [
    'Kuala Lumpur',
    'Singapore',
    'Bangkok',
    'Jakarta',
    'Manila',
    'Ho Chi Minh City',
  ];

  // List of available destinations
  final List<String> destinations = [
    'Singapore',
    'Kuala Lumpur',
    'Bangkok',
    'Jakarta',
    'Manila',
    'Tokyo',
    'Seoul',
    'Hong Kong',
    'Beijing',
    'Shanghai',
    'Taipei',
    'Ho Chi Minh City',
    'Hanoi',
    'Phnom Penh',
    'Vientiane',
    'Yangon',
  ];

  final List<String> purposes = ['Travel', 'Business', 'Education', 'Other'];

  @override
  void initState() {
    super.initState();
    // Set default starting point
    selectedStartingPoint = startingPoints[0];
  }

  void _validateAndNavigate() {
    if (selectedDestination != null) {
      final newItinerary = Itinerary(
        destination: selectedDestination!,
        purpose: selectedPurpose ?? 'Travel',
        days: days,
        nights: nights,
        imageUrl: 'assets/images/singapore_skyline.jpg',
      );

      Navigator.pop(context, newItinerary);
    } else {
      setState(() {
        showError = true;
      });
    }
  }

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Itinerary ${widget.existingItinerariesCount + 1}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Starting From',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: selectedStartingPoint,
                      items: startingPoints.map((String point) {
                        return DropdownMenuItem<String>(
                          value: point,
                          child: Text(point),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          selectedStartingPoint = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Heading to',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButton<String>(
                      isExpanded: true,
                      hint: const Text('Select Destination'),
                      value: selectedDestination,
                      items: destinations.map((String destination) {
                        return DropdownMenuItem<String>(
                          value: destination,
                          child: Text(destination),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          selectedDestination = value;
                          showError = false;
                        });
                      },
                    ),
                  ),
                  if (showError) ...[
                    const SizedBox(height: 8),
                    const Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.red, size: 16),
                        SizedBox(width: 8),
                        Text(
                          'Please select a destination',
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 24),
                  const Text(
                    'Purpose',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButton<String>(
                      isExpanded: true,
                      hint: const Text('Select Purpose'),
                      value: selectedPurpose,
                      items: purposes.map((String purpose) {
                        return DropdownMenuItem<String>(
                          value: purpose,
                          child: Text(purpose),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          selectedPurpose = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Days',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove),
                                onPressed: () {
                                  if (days > 1) {
                                    setState(() => days--);
                                  }
                                },
                              ),
                              Text('$days'),
                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () {
                                  setState(() => days++);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Nights',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove),
                                onPressed: () {
                                  if (nights > 0) {
                                    setState(() => nights--);
                                  }
                                },
                              ),
                              Text('$nights'),
                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () {
                                  setState(() => nights++);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFCE816D),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              onPressed: _validateAndNavigate,
              child: const Text(
                'Next',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
