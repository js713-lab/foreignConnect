// lib/widgets/category_chip.dart

import 'package:flutter/material.dart';

class CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Function(bool) onSelected;

  const CategoryChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onSelected,
  });

  Icon _getCategoryIcon() {
    switch (label) {
      case 'All':
        return const Icon(Icons.grid_view, size: 16);
      case 'Restaurants':
        return const Icon(Icons.restaurant, size: 16);
      case 'Parks':
        return const Icon(Icons.park, size: 16);
      case 'Entertainment':
        return const Icon(Icons.movie, size: 16);
      default:
        return const Icon(Icons.place, size: 16);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: FilterChip(
        selected: isSelected,
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _getCategoryIcon(),
            const SizedBox(width: 4),
            Text(label),
          ],
        ),
        backgroundColor: Colors.transparent,
        selectedColor: const Color(0xFFCE7D66),
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.grey,
        ),
        shape: StadiumBorder(
          side: BorderSide(
            color: isSelected ? const Color(0xFFCE7D66) : Colors.grey,
          ),
        ),
        onSelected: onSelected,
      ),
    );
  }
}
