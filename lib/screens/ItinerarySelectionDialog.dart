import 'package:flutter/material.dart';
import 'ConsultMessageScreen.dart';

class ItinerarySelectionDialog extends StatelessWidget {
  final Map<String, dynamic> consultant;

  const ItinerarySelectionDialog({
    super.key,
    required this.consultant,
  });

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> savedItineraries = [
      {
        'title': 'Singapore 3D2N Trip',
        'image': 'assets/images/singapore_1.jpg',
        'date': '24 Feb 2024',
      },
      {
        'title': 'Malaysia Food Tour',
        'image': 'assets/images/singapore_2.jpg',
        'date': '25 Feb 2024',
      },
    ];

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Select Itinerary',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                // Start from zero option
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFFCE7D66),
                    child: Icon(Icons.add, color: Colors.white),
                  ),
                  title: const Text('Start New Itinerary'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ConsultMessageScreen(
                          consultant: consultant,
                          itinerary: null,
                        ),
                      ),
                    );
                  },
                ),
                const Divider(),
                // Saved itineraries
                ...savedItineraries.map((itinerary) => ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          itinerary['image'],
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(itinerary['title']),
                      subtitle: Text(itinerary['date']),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ConsultMessageScreen(
                              consultant: consultant,
                              itinerary: itinerary,
                            ),
                          ),
                        );
                      },
                    )),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ),
        ],
      ),
    );
  }
}
