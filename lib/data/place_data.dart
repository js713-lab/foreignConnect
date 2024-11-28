// lib/data/place_data.dart

import 'package:flutter/material.dart';

class PlacesData {
  static final List<Map<String, dynamic>> allPlaces = [
    {
      'id': '1',
      'title': 'Marina Bay Sands',
      'imageUrl': 'assets/mbs.jpg',
      'type': 'Hotel',
      'category': 'Travel',
      'location': 'Marina Bay, Singapore',
      'rating': 4.8,
      'reviewCount': 128,
      'price': '550',
      'description': 'Iconic integrated resort with infinity pool',
    },
    {
      'id': '2',
      'title': 'National University of Singapore',
      'imageUrl': 'assets/nus.jpg',
      'type': 'Education',
      'category': 'Study',
      'location': 'Kent Ridge, Singapore',
      'rating': 4.6,
      'reviewCount': 245,
      'price': 'Free',
      'description': 'Leading global university in Asia',
    },
    {
      'id': '3',
      'title': 'Singapore CBD',
      'imageUrl': 'assets/cbd.jpg',
      'type': 'Business',
      'category': 'Work',
      'location': 'Downtown Core, Singapore',
      'rating': 4.5,
      'reviewCount': 180,
      'price': 'Varies',
      'description': 'Prime business district with major corporations',
    },
    {
      'id': '4',
      'title': 'Gardens by the Bay',
      'imageUrl': 'assets/gardens.jpg',
      'type': 'Park',
      'category': 'Entertainment',
      'location': 'Marina Bay, Singapore',
      'rating': 4.7,
      'reviewCount': 320,
      'price': '28',
      'description': 'Futuristic nature park with Supertree Grove',
    },
    {
      'id': '5',
      'title': 'Tech Park',
      'imageUrl': 'assets/techpark.jpg',
      'type': 'Technology',
      'category': 'Work',
      'location': 'One-North, Singapore',
      'rating': 4.4,
      'reviewCount': 156,
      'price': 'Varies',
      'description': 'Singapore\'s leading technology hub',
    }
  ];

  static final Map<String, IconData> categories = {
    'All': Icons.grid_view,
    'Study': Icons.school,
    'Work': Icons.work,
    'Travel': Icons.flight,
    'Entertainment': Icons.movie,
    'Sports': Icons.sports,
    'Restaurants': Icons.restaurant,
    'Parks': Icons.park,
    'Cultural': Icons.museum,
    'Shopping': Icons.shopping_bag,
    'Nightlife': Icons.nightlife,
  };
}
