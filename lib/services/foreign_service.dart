// lib/services/foreign_service.dart

import 'package:flutter/material.dart';

class ForeignService {
  final String name;
  final IconData icon;
  final String description;
  final VoidCallback onTap;

  ForeignService({
    required this.name,
    required this.icon,
    required this.description,
    required this.onTap,
  });
}
