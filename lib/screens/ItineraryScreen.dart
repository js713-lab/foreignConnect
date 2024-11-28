import 'package:flutter/material.dart';
import '../models/todo_item.dart';
import '../models/activity.dart';
import '../models/day_plan.dart';
import '../widgets/activity_manager.dart';

class ItineraryDetailScreen extends StatefulWidget {
  final String destination;
  final int days;
  final int nights;
  final String purpose;

  const ItineraryDetailScreen({
    Key? key,
    required this.destination,
    required this.days,
    required this.nights,
    required this.purpose,
  }) : super(key: key);

  @override
  State<ItineraryDetailScreen> createState() => _ItineraryDetailScreenState();
}

class _ItineraryDetailScreenState extends State<ItineraryDetailScreen> {
  int _selectedDay = -1; // -1 for overview
  String _overviewText =
      '''Singapore is a modern and multicultural city-state with world-class attractions, shopping and food. 
Visitors can visit attractions such as the famous Gardens by the Bay, Merlion Park and Singapore Zoo 
to experience the natural and human beauty of the city. In addition, Singapore's shopping districts such 
as Orchard Road and Sentosa Island offer a wealth of shopping and entertainment options...''';

  final List<DayPlan> _dayPlans = [];
  final TextEditingController _overviewController = TextEditingController();
  bool _isEditingOverview = false;

  // Todo lists
  final List<TodoItem> _bookingItems = [
    TodoItem(title: 'Book Flight Tickets', isCompleted: true),
    TodoItem(title: 'Reserve Hotel', isCompleted: false),
    TodoItem(title: 'Airport Transfer', isCompleted: false),
    TodoItem(title: 'Travel Insurance', isCompleted: false),
    TodoItem(title: 'Restaurant Reservations', isCompleted: false),
  ];

  final List<TodoItem> _exploreItems = [
    TodoItem(title: 'Gardens by the Bay', isCompleted: true),
    TodoItem(title: 'Marina Bay Sands', isCompleted: false),
    TodoItem(title: 'Sentosa Island', isCompleted: false),
    TodoItem(title: 'Singapore Zoo', isCompleted: false),
    TodoItem(title: 'Night Safari', isCompleted: false),
    TodoItem(title: 'Universal Studios', isCompleted: false),
    TodoItem(title: 'Chinatown', isCompleted: false),
  ];

  final List<TodoItem> _packingItems = TodoItemGroups.generatePackingItems();

  @override
  void initState() {
    super.initState();
    _overviewController.text = _overviewText;
    _initializeDayPlans();
  }

  void _initializeDayPlans() {
    for (int i = 0; i < widget.days; i++) {
      _dayPlans.add(DayPlan(
        day: i + 1,
        activities: i == 0
            ? [
                Activity(
                  name: 'Gardens by the Bay',
                  timeRange: '11:00-13:00',
                  imageUrl: 'assets/gardens.jpg',
                  location: '18 Marina Gardens Drive',
                ),
                Activity(
                  name: 'Marina Bay Sands',
                  timeRange: '14:00-16:00',
                  imageUrl: 'assets/mbs.jpg',
                  location: '10 Bayfront Avenue',
                ),
                Activity(
                  name: 'Clarke Quay',
                  timeRange: '17:00-19:00',
                  imageUrl: 'assets/clarke_quay.jpg',
                  location: '3 River Valley Rd',
                ),
                Activity(
                  name: 'Spectra',
                  timeRange: '20:00-21:00',
                  imageUrl: 'assets/spectra.jpg',
                  location: 'Event Plaza at Marina Bay Sands',
                ),
              ]
            : [],
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Map section
          Stack(
            children: [
              Image.asset(
                'assets/singapore_map.jpg',
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
              Positioned(
                top: 40,
                left: 16,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${widget.days}D${widget.nights}N Tour',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildProgressSection(),
                        const SizedBox(height: 16),
                        _buildSimCardSection(),
                        const SizedBox(height: 16),
                        _buildDaySelector(),
                        const SizedBox(height: 16),
                        _selectedDay == -1
                            ? _buildOverviewSection()
                            : _buildDayContent(_selectedDay),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom buttons
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildBottomButton('Add To Apple Wallet'),
                const SizedBox(height: 8),
                _buildBottomButton('Add To Phone Calendar'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildProgressButton(
          'Book ${_bookingItems.where((item) => item.isCompleted).length}/6',
          () => _showTodoList('Booking Checklist', _bookingItems),
        ),
        _buildProgressButton(
          'Explore ${_exploreItems.where((item) => item.isCompleted).length}/7',
          () => _showTodoList('Places to Explore', _exploreItems),
        ),
        _buildProgressButton(
          'Pack ${_packingItems.where((item) => item.isCompleted).length}/30',
          () => _showTodoList('Packing List', _packingItems),
        ),
      ],
    );
  }

  Widget _buildSimCardSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'SIM Card',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'Enjoy seamless Internet access\nand phone calls for an easy trip!',
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
          const Spacer(),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFCE816D),
            ),
            onPressed: () {},
            child: const Text('Go', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildDaySelector() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildDayTab('Overview', -1),
          for (int i = 0; i < widget.days; i++) _buildDayTab('Day ${i + 1}', i),
        ],
      ),
    );
  }

  Widget _buildDayTab(String text, int day) {
    final isSelected = _selectedDay == day;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        onTap: () => setState(() => _selectedDay = day),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFCE816D) : Colors.white,
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            text,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOverviewSection() {
    return _isEditingOverview
        ? Column(
            children: [
              TextField(
                controller: _overviewController,
                maxLines: null,
                decoration: const InputDecoration(
                  hintText: 'Enter your travel notes...',
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _overviewText = _overviewController.text;
                    _isEditingOverview = false;
                  });
                },
                child: const Text('Save'),
              ),
            ],
          )
        : GestureDetector(
            onTap: () {
              setState(() {
                _isEditingOverview = true;
              });
            },
            child: Text(_overviewText),
          );
  }

  Widget _buildDayContent(int dayIndex) {
    final dayPlan = _dayPlans[dayIndex];
    return Column(
      children: [
        for (var activity in dayPlan.activities) _buildActivityItem(activity),
      ],
    );
  }

  Widget _buildActivityItem(Activity activity) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Column(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                  color: Color(0xFFCE816D),
                  shape: BoxShape.circle,
                ),
              ),
              Container(
                width: 2,
                height: 50,
                color: Colors.grey,
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          activity.name,
                          style: const TextStyle(
                            color: Color(0xFFCE816D),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          activity.timeRange,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      activity.imageUrl,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressButton(String text, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(text),
      ),
    );
  }

  Widget _buildBottomButton(String text) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFCE816D),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        onPressed: () {},
        child: Text(text, style: const TextStyle(color: Colors.white)),
      ),
    );
  }

  void _showTodoList(String title, List<TodoItem> items) {
    showModalBottomSheet(
      context: context,
      builder: (context) => TodoListWidget(
        title: title,
        items: items,
        onUpdateItems: (updatedItems) {
          setState(() {
            items.clear();
            items.addAll(updatedItems);
          });
        },
      ),
    );
  }
}

class TodoListWidget extends StatefulWidget {
  final String title;
  final List<TodoItem> items;
  final Function(List<TodoItem>) onUpdateItems;

  const TodoListWidget({
    Key? key,
    required this.title,
    required this.items,
    required this.onUpdateItems,
  }) : super(key: key);

  @override
  State<TodoListWidget> createState() => _TodoListWidgetState();
}

class _TodoListWidgetState extends State<TodoListWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: widget.items.length,
              itemBuilder: (context, index) {
                final item = widget.items[index];
                return CheckboxListTile(
                  title: Text(item.title),
                  value: item.isCompleted,
                  onChanged: (bool? value) {
                    setState(() {
                      item.isCompleted = value ?? false;
                      widget.onUpdateItems(widget.items);
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Extension for generating todo item groups
extension TodoItemGroups on List<TodoItem> {
  static List<TodoItem> generateBookingItems() {
    return [
      TodoItem(title: 'Book Flight Tickets', isCompleted: true),
      TodoItem(title: 'Reserve Hotel', isCompleted: false),
      TodoItem(title: 'Airport Transfer', isCompleted: false),
      TodoItem(title: 'Travel Insurance', isCompleted: false),
      TodoItem(title: 'Restaurant Reservations', isCompleted: false),
      TodoItem(title: 'Attraction Tickets', isCompleted: false),
    ];
  }

  static List<TodoItem> generateExploreItems() {
    return [
      TodoItem(title: 'Gardens by the Bay', isCompleted: true),
      TodoItem(title: 'Marina Bay Sands', isCompleted: false),
      TodoItem(title: 'Sentosa Island', isCompleted: false),
      TodoItem(title: 'Singapore Zoo', isCompleted: false),
      TodoItem(title: 'Night Safari', isCompleted: false),
      TodoItem(title: 'Universal Studios', isCompleted: false),
      TodoItem(title: 'Chinatown', isCompleted: false),
    ];
  }

  static List<TodoItem> generatePackingItems() {
    return [
      // Documents
      TodoItem(title: 'Passport', isCompleted: false),
      TodoItem(title: 'Travel Documents', isCompleted: false),
      TodoItem(title: 'Insurance Cards', isCompleted: false),
      TodoItem(title: 'Booking Confirmations', isCompleted: false),
      TodoItem(title: 'Emergency Contacts', isCompleted: false),

      // Clothes
      TodoItem(title: 'T-shirts', isCompleted: false),
      TodoItem(title: 'Shorts/Pants', isCompleted: false),
      TodoItem(title: 'Underwear', isCompleted: false),
      TodoItem(title: 'Socks', isCompleted: false),
      TodoItem(title: 'Pajamas', isCompleted: false),
      TodoItem(title: 'Swimwear', isCompleted: false),
      TodoItem(title: 'Rain Jacket', isCompleted: false),
      TodoItem(title: 'Walking Shoes', isCompleted: false),
      TodoItem(title: 'Flip-flops', isCompleted: false),

      // Toiletries
      TodoItem(title: 'Toothbrush & Toothpaste', isCompleted: false),
      TodoItem(title: 'Shampoo & Conditioner', isCompleted: false),
      TodoItem(title: 'Body Wash', isCompleted: false),
      TodoItem(title: 'Deodorant', isCompleted: false),
      TodoItem(title: 'Sunscreen', isCompleted: false),
      TodoItem(title: 'Hair Brush', isCompleted: false),
      TodoItem(title: 'Medications', isCompleted: false),

      // Electronics
      TodoItem(title: 'Phone Charger', isCompleted: false),
      TodoItem(title: 'Power Bank', isCompleted: false),
      TodoItem(title: 'Camera', isCompleted: false),
      TodoItem(title: 'Universal Adapter', isCompleted: false),

      // Miscellaneous
      TodoItem(title: 'Daypack', isCompleted: false),
      TodoItem(title: 'Water Bottle', isCompleted: false),
      TodoItem(title: 'Umbrella', isCompleted: false),
      TodoItem(title: 'First Aid Kit', isCompleted: false),
      TodoItem(title: 'Hand Sanitizer', isCompleted: false),
    ];
  }
}
