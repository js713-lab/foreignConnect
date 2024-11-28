// consultant_detail_screen.dart
import 'package:flutter/material.dart';
import 'TimeSelectionScreen.dart';
import 'ItinerarySelectionDialog.dart';

class ConsultantDetailScreen extends StatelessWidget {
  final Map<String, dynamic> consultant;

  const ConsultantDetailScreen({
    super.key,
    required this.consultant,
  });

  void _navigateToTimeSelection(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TimeSelectionScreen(consultant: consultant),
      ),
    );
  }

  void _showConsultDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ItinerarySelectionDialog(consultant: consultant),
    );
  }

  @override
  Widget build(BuildContext context) {
    final reviews = [
      {
        'user': 'User1',
        'comment':
            'I highly recommend the guide, they were very patient with every question, and also recommended a lot of local food, great!',
      },
      {
        'user': 'User2',
        'comment':
            'The guide made sure we didn\'t have to worry about the trip, it was perfectly planned!',
      },
      {
        'user': 'User3',
        'comment':
            'The guide not only helped us plan the most suitable route, but also took special care of the elderly and children in the group.',
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Consultation',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Consultant Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      consultant['image'],
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              consultant['name'],
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Icon(
                              consultant['isFavorite']
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: consultant['isFavorite']
                                  ? Colors.red
                                  : Colors.grey,
                            ),
                          ],
                        ),
                        Text(
                          'Joined ${consultant['joined']}',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        Row(
                          children: List.generate(
                            5,
                            (index) => Icon(
                              index < (consultant['rating'] ?? 0)
                                  ? Icons.star
                                  : Icons.star_border,
                              color: Colors.amber,
                              size: 20,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '\$${consultant['priceHour']}/hrs    \$${consultant['priceDay']}/day',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Stats Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildStatCard(Icons.favorite, '89'),
                  const SizedBox(width: 16),
                  _buildStatCard(Icons.person_outline, '127'),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Services Section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Service:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...consultant['services'].asMap().entries.map(
                        (entry) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${entry.key + 1}. '),
                              Expanded(child: Text(entry.value)),
                            ],
                          ),
                        ),
                      ),
                ],
              ),
            ),

            // Reviews Section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Passenger Review:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Read More',
                          style: TextStyle(color: Color(0xFFCE7D66)),
                        ),
                      ),
                    ],
                  ),
                  ...reviews.map(
                    (review) => ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Colors.grey,
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      title: Text(review['user']!),
                      subtitle: Text(review['comment']!),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _navigateToTimeSelection(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFCE7D66),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Book Now'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _showConsultDialog(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFCE7D66),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Consult'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildStatCard(IconData icon, String count) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
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
        Icon(icon, color: const Color(0xFFCE7D66)),
        const SizedBox(width: 8),
        Text(count),
      ],
    ),
  );
}
