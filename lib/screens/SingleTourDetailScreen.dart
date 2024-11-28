// lib/screens/tour_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import 'CartScreen.dart';

class SingleTourDetailScreen extends StatelessWidget {
  final Map<String, dynamic> tour;

  const SingleTourDetailScreen({
    super.key,
    required this.tour,
  });

// In SingleTourDetailScreen and ConsultantDetailScreen:

  void _addToCart(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    final cartItem = {
      'type': 'tour_package',
      'id': DateTime.now().toString(), // Generate a unique ID
      'title': tour['title'],
      'image': tour['image'],
      'price': double.parse(tour['priceDay'].toString()),
      'priceHour': double.parse(tour['priceHour'].toString()),
      'priceDay': double.parse(tour['priceDay'].toString()),
      'selectedTimes': ['28 Feb 2024'], // Default selected date
      'quantity': 1,
      'isSelected': true,
    };

    cartProvider.addItem(cartItem);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            const Text('Added to cart'),
            const Spacer(),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CartScreen(),
                  ),
                );
              },
              child: const Text(
                'View Cart',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFFCE7D66),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final reviews = [
      {
        'user': 'User1',
        'comment': 'Amazing tour experience! The guide was very knowledgeable.',
      },
      {
        'user': 'User2',
        'comment': 'Great value for money, saw all the main attractions.',
      },
      {
        'user': 'User3',
        'comment': 'Perfect organization and timing. Highly recommended!',
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
        title: Text(
          tour['title'],
          style: const TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tour Image
            Image.asset(
              tour['image'],
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),

            // Tour Details
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        tour['title'],
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(
                        tour['isFavorite']
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: tour['isFavorite'] ? Colors.red : Colors.grey,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                      Text(' ${tour['rating']}'),
                      Text(
                        ' (${tour['reviews']} Reviews)',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '\$${tour['priceHour']}/hrs    \$${tour['priceDay']}/day',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Tour Description
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Overview:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    tour['description'] ??
                        'Experience the best of the city with our comprehensive tour package...',
                    style: const TextStyle(height: 1.5),
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
                        'Reviews:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'View All',
                          style: TextStyle(color: Color(0xFFCE7D66)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ...reviews.map(
                    (review) => Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Colors.grey,
                          child: Icon(Icons.person, color: Colors.white),
                        ),
                        title: Row(
                          children: [
                            Text(review['user']!),
                            const SizedBox(width: 8),
                            const Row(
                              children: [
                                Icon(Icons.star, color: Colors.amber, size: 16),
                                Icon(Icons.star, color: Colors.amber, size: 16),
                                Icon(Icons.star, color: Colors.amber, size: 16),
                                Icon(Icons.star, color: Colors.amber, size: 16),
                                Icon(Icons.star_half,
                                    color: Colors.amber, size: 16),
                              ],
                            ),
                          ],
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(review['comment']!),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Available Times Section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Available Times:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildTimeChip('24 Feb 2024 10:00 AM'),
                      _buildTimeChip('24 Feb 2024 2:00 PM'),
                      _buildTimeChip('25 Feb 2024 10:00 AM'),
                      _buildTimeChip('25 Feb 2024 2:00 PM'),
                    ],
                  ),
                ],
              ),
            ),

            // What's Included Section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'What\'s Included:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildIncludedItem(Icons.directions_bus, 'Transportation'),
                  _buildIncludedItem(Icons.restaurant_menu, 'Meals'),
                  _buildIncludedItem(Icons.photo_camera, 'Photography'),
                  _buildIncludedItem(Icons.local_activity, 'Entrance Fees'),
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
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Next Available',
                        style: TextStyle(
                          color: Colors.red[300],
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        tour['nextAvailable'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _addToCart(context),
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
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeChip(String time) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFCE7D66).withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFCE7D66),
          width: 1,
        ),
      ),
      child: Text(
        time,
        style: const TextStyle(
          color: Color(0xFFCE7D66),
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildIncludedItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFCE7D66), size: 20),
          const SizedBox(width: 12),
          Text(text),
        ],
      ),
    );
  }
}
