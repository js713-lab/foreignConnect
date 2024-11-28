import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import 'ConsultMessageScreen.dart';
import 'ItinerarySelectionDialog.dart';

class TimeSelectionScreen extends StatefulWidget {
  final Map<String, dynamic> consultant;

  const TimeSelectionScreen({
    required this.consultant,
    super.key,
  });

  @override
  State<TimeSelectionScreen> createState() => _TimeSelectionScreenState();
}

class _TimeSelectionScreenState extends State<TimeSelectionScreen> {
  int selectedDateIndex = 1; // Default to "Tomorrow"
  Set<String> selectedTimeSlots = {
    '3:00 p.m.',
    '4:00 p.m.'
  }; // Default selected times

  void _showItinerarySelectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => ItinerarySelectionDialog(
        consultant: widget.consultant,
      ),
    );
  }

  final List<Map<String, dynamic>> dateCards = [
    {
      'date': 'Today, 23 Feb',
      'slots': 'No slots available',
      'isAvailable': false,
    },
    {
      'date': 'Tomorrow, 24 Feb',
      'slots': '9 slots available',
      'isAvailable': true,
    },
    {
      'date': 'Thu, 25 Feb',
      'slots': '10 slots available',
      'isAvailable': true,
    },
  ];

  final List<Map<String, dynamic>> timeSlots = [
    {'time': '8:00 a.m.', 'isAvailable': false},
    {'time': '9:00 a.m.', 'isAvailable': true},
    {'time': '10:00 a.m.', 'isAvailable': true},
    {'time': '11:00 a.m.', 'isAvailable': true},
    {'time': '2:00 p.m.', 'isAvailable': true},
    {'time': '3:00 p.m.', 'isAvailable': true},
    {'time': '4:00 p.m.', 'isAvailable': true},
    {'time': '5:00 p.m.', 'isAvailable': true},
    {'time': '7:00 p.m.', 'isAvailable': true},
    {'time': '8:00 p.m.', 'isAvailable': true},
    {'time': 'Entire day', 'isAvailable': false},
  ];

  Widget _buildDateCard(
      String date, String slots, bool isAvailable, bool isSelected) {
    return GestureDetector(
      onTap: isAvailable
          ? () {
              setState(() {
                selectedDateIndex =
                    dateCards.indexWhere((card) => card['date'] == date);
                // Reset time slots when changing date
                selectedTimeSlots.clear();
              });
            }
          : null,
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFCE7D66)
              : (isAvailable ? Colors.white : Colors.grey.shade200),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? const Color(0xFFCE7D66) : Colors.transparent,
          ),
        ),
        child: Column(
          children: [
            Text(
              date,
              style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : (isAvailable ? Colors.black : Colors.grey),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              slots,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeSlot(String time, bool isAvailable,
      {bool selected = false}) {
    return GestureDetector(
      onTap: isAvailable
          ? () {
              setState(() {
                if (selected) {
                  selectedTimeSlots.remove(time);
                } else {
                  selectedTimeSlots.add(time);
                }
              });
            }
          : null,
      child: Container(
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFFCE7D66)
              : (isAvailable ? Colors.white : Colors.grey.shade200),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selected ? const Color(0xFFCE7D66) : Colors.grey.shade300,
          ),
        ),
        child: Center(
          child: Text(
            time,
            style: TextStyle(
              color: selected
                  ? Colors.white
                  : (isAvailable ? Colors.black : Colors.grey),
            ),
          ),
        ),
      ),
    );
  }

  double _calculateEstimatedCost() {
    return selectedTimeSlots.length * 20.0; // $20 per time slot
  }

  @override
  Widget build(BuildContext context) {
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
          'Select Time',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        children: [
          // Consultant Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    widget.consultant['image'],
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.consultant['name'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        'Travel Guide Service, Malaysia',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                      Row(
                        children: List.generate(
                          5,
                          (index) => Icon(
                            index < (widget.consultant['rating'] ?? 0)
                                ? Icons.star
                                : Icons.star_border,
                            color: Colors.amber,
                            size: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    widget.consultant['isFavorite']
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: widget.consultant['isFavorite']
                        ? Colors.red
                        : Colors.grey,
                  ),
                  onPressed: () {
                    // Handle favorite toggle
                  },
                ),
              ],
            ),
          ),

          // Date Selection
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: dateCards.map((card) {
                int index = dateCards.indexOf(card);
                return _buildDateCard(
                  card['date'],
                  card['slots'],
                  card['isAvailable'],
                  index == selectedDateIndex,
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 24),

          // Time Slots Grid
          Expanded(
            child: GridView.count(
              crossAxisCount: 3,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: timeSlots.map((slot) {
                return _buildTimeSlot(
                  slot['time'],
                  slot['isAvailable'],
                  selected: selectedTimeSlots.contains(slot['time']),
                );
              }).toList(),
            ),
          ),

          // Bottom Section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  'Estimated Cost: \$${_calculateEstimatedCost().toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed:
                            _showItinerarySelectionDialog, // Updated this line
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
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: selectedTimeSlots.isEmpty
                            ? null
                            : () {
                                final cartProvider = Provider.of<CartProvider>(
                                    context,
                                    listen: false);
                                final selectedDate =
                                    dateCards[selectedDateIndex]['date']
                                        .toString()
                                        .split(',')[1]
                                        .trim();

                                final List<String> formattedTimes =
                                    selectedTimeSlots
                                        .map((time) => '$selectedDate $time')
                                        .toList();

                                final cartItem = {
                                  ...widget.consultant,
                                  'quantity': 1,
                                  'selectedTimes': formattedTimes,
                                  'isSelected': true,
                                  'type': 'consultant',
                                };
                                cartProvider.addItem(cartItem);
                                Navigator.pushNamed(context, '/cart');
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFCE7D66),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Add to cart'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildDateCard(
    String date, String slots, bool isAvailable, bool isSelected) {
  return Container(
    margin: const EdgeInsets.only(right: 12),
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    decoration: BoxDecoration(
      color: isSelected
          ? const Color(0xFFCE7D66)
          : (isAvailable ? Colors.white : Colors.grey.shade200),
      borderRadius: BorderRadius.circular(8),
      border: Border.all(
        color: isSelected ? const Color(0xFFCE7D66) : Colors.transparent,
      ),
    ),
    child: Column(
      children: [
        Text(
          date,
          style: TextStyle(
            color: isSelected
                ? Colors.white
                : (isAvailable ? Colors.black : Colors.grey),
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          slots,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey,
            fontSize: 12,
          ),
        ),
      ],
    ),
  );
}

Widget _buildTimeSlot(String time, bool isAvailable, {bool selected = false}) {
  return Container(
    decoration: BoxDecoration(
      color: selected
          ? const Color(0xFFCE7D66)
          : (isAvailable ? Colors.white : Colors.grey.shade200),
      borderRadius: BorderRadius.circular(8),
      border: Border.all(
        color: selected ? const Color(0xFFCE7D66) : Colors.grey.shade300,
      ),
    ),
    child: Center(
      child: Text(
        time,
        style: TextStyle(
          color: selected
              ? Colors.white
              : (isAvailable ? Colors.black : Colors.grey),
        ),
      ),
    ),
  );
}
