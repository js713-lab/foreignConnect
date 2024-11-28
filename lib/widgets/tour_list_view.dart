// lib/widgets/tour_list_view.dart

import 'package:flutter/material.dart';

class TourListView extends StatelessWidget {
  final List<Map<String, dynamic>> tours;
  final Function(int) onFavoritePressed;
  final Function(Map<String, dynamic>) onBookNow;

  const TourListView({
    super.key,
    required this.tours,
    required this.onFavoritePressed,
    required this.onBookNow,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: tours.length,
      itemBuilder: (context, index) {
        final tour = tours[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        tour['image'],
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
                                tour['title'],
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  tour['isFavorite']
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: tour['isFavorite']
                                      ? Colors.red
                                      : Colors.grey,
                                ),
                                onPressed: () => onFavoritePressed(index),
                              ),
                            ],
                          ),
                          Text(
                            'Joined ${tour['joined']}',
                            style: TextStyle(
                                color: Colors.grey[600], fontSize: 12),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.star,
                                  color: Colors.amber, size: 16),
                              Text(' ${tour['rating']}'),
                              Text(
                                ' (${tour['reviews']} Reviews)',
                                style: TextStyle(
                                    color: Colors.grey[600], fontSize: 12),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('\$${tour['priceHour']}/hrs'),
                        Text(
                          '\$${tour['priceDay']}/day',
                          style:
                              TextStyle(color: Colors.grey[600], fontSize: 12),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () => onBookNow(tour),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFCE7D66),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Book Now'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
