import 'package:flutter/material.dart';
import 'package:foreign_connect/providers/cart_provider.dart';
import 'package:provider/provider.dart';
import 'SingleTourDetailScreen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'ConsultantDetailScreen.dart';
import 'ConsultMessageScreen.dart';

class TourDetailScreen extends StatefulWidget {
  const TourDetailScreen({super.key});

  @override
  _TourDetailScreenState createState() => _TourDetailScreenState();
}

class _TourDetailScreenState extends State<TourDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> tours = [
    {
      'title': '3D2N SG Tour Package',
      'image': 'assets/images/singapore_1.jpg',
      'joined': '2yrs ago',
      'rating': 4.0,
      'reviews': 36,
      'priceHour': '10.0',
      'priceDay': '110.0',
      'nextAvailable': '10:00 tomorrow',
      'isFavorite': true,
    },
    {
      'title': '3D2N SG Tour Package',
      'image': 'assets/images/singapore_2.jpg',
      'joined': '1yrs ago',
      'rating': 4.4,
      'reviews': 18,
      'priceHour': '8.0',
      'priceDay': '100.0',
      'nextAvailable': '14:00 tomorrow',
      'isFavorite': false,
    },
    {
      'title': '3D2N SG Tour Package',
      'image': 'assets/images/singapore_3.jpg',
      'joined': '4yrs ago',
      'rating': 4.0,
      'reviews': 48,
      'priceHour': '10.0',
      'priceDay': '110.0',
      'nextAvailable': '4 December 2024',
      'isFavorite': true,
    },
  ];
  final List<Map<String, dynamic>> consultants = [
    {
      'name': 'Makabaka',
      'image': 'assets/images/consultants/consultant_1.jpg',
      'joined': '2yrs ago',
      'rating': 4.0,
      'reviews': 36,
      'priceHour': 10.0,
      'priceDay': 110.0,
      'nextAvailable': '10:00 tomorrow',
      'isFavorite': true,
      'services': [
        'Design unique itineraries based on customer needs to ensure that the travel experience is highly aligned with customer interests.',
        'Provide language translation services for foreign visitors to assist with local communication issues.',
        'Handle emergencies during the trip, such as lost luggage or lost travelers, to ensure that the trip goes smoothly.',
        'Arrange and coordinate local transportation to ensure a smooth and hassle-free trip.',
      ],
      'languages': ['English', 'Chinese'],
      'verified': true,
      'tourCount': 150
    },
    {
      'name': 'Usidisi',
      'image': 'assets/images/consultants/consultant_2.jpg',
      'joined': '1yrs ago',
      'rating': 4.4,
      'reviews': 18,
      'priceHour': 8.0,
      'priceDay': 100.0,
      'nextAvailable': '14:00 tomorrow',
      'isFavorite': false,
      'services': [
        'Design unique itineraries based on customer needs.',
        'Provide language translation services.',
        'Handle emergencies during the trip.',
      ],
      'languages': ['Malay', 'Chinese'],
      'verified': true,
      'tourCount': 15
    },
    {
      'name': 'Seng Seng',
      'image': 'assets/images/consultants/consultant_3.jpg',
      'joined': '4yrs ago',
      'rating': 4.0,
      'reviews': 48,
      'priceHour': 10.0,
      'priceDay': 110.0,
      'nextAvailable': '4 December 2024',
      'isFavorite': true,
      'services': [
        'Design unique itineraries.',
        'Provide translation services.',
        'Handle emergencies.',
        'Arrange transportation.',
      ],
      'languages': ['English', 'Chinese'],
      'verified': true,
      'tourCount': 150
    },
  ];
  void _onConsultantTapped(Map<String, dynamic> consultant) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ConsultantDetailScreen(consultant: consultant),
      ),
    );
  }

  void _onTourTapped(Map<String, dynamic> tour) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SingleTourDetailScreen(tour: tour),
      ),
    );
  }

// In TourDetailScreen class
  void _onBookNowPressed(Map<String, dynamic> item) {
    Navigator.pushNamed(
      context,
      '/time-selection',
      arguments: item,
    );
  }

  void _onAddToCartPressed(Map<String, dynamic> item) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final cartItem = {
      ...item,
      'quantity': 1,
      'selectedTimes': ['24 Feb 2024 3:00pm'],
      'isSelected': true,
      'type': item.containsKey('name') ? 'consultant' : 'tour',
    };

    cartProvider.addItem(cartItem);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Added to cart successfully'),
        backgroundColor: Color(0xFFCE7D66),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _navigateToCart() {
    Navigator.pushNamed(context, '/cart');
  }

  void _toggleFavorite(Map<String, dynamic> item, bool isTour) {
    setState(() {
      if (isTour) {
        final index = tours.indexWhere((tour) =>
            tour['title'] == item['title'] && tour['image'] == item['image']);
        if (index != -1) {
          tours[index] = {
            ...tours[index],
            'isFavorite': !tours[index]['isFavorite'],
          };
        }
      } else {
        final index = consultants.indexWhere((consultant) =>
            consultant['name'] == item['name'] &&
            consultant['image'] == item['image']);
        if (index != -1) {
          consultants[index] = {
            ...consultants[index],
            'isFavorite': !consultants[index]['isFavorite'],
          };
        }
      }
    });
  }

  void _addToCart(Map<String, dynamic> tour) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final cartItem = {
      ...tour,
      'quantity': 1,
      'selectedTimes': ['24 Feb 2024 3:00pm'],
      'isSelected': true,
      'type': 'tour',
    };
    cartProvider.addItem(cartItem);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Added to cart successfully'),
        backgroundColor: Color(0xFFCE7D66),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  Widget _buildTourCard(Map<String, dynamic> tour) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                child: Image.asset(
                  tour['image'],
                  width: double.infinity,
                  height: 180,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  icon: Icon(
                    tour['isFavorite'] ? Icons.favorite : Icons.favorite_border,
                    color: tour['isFavorite'] ? Colors.red : Colors.white,
                  ),
                  onPressed: () => _toggleFavorite(tour, true),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tour['title'],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Joined ${tour['joined']}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 18),
                    Text(
                      ' ${tour['rating']}',
                      style: const TextStyle(fontSize: 14),
                    ),
                    Text(
                      ' ${tour['reviews']} Reviews',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
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
                        Text(
                          '\$${tour['priceHour']}/hrs',
                          style: const TextStyle(fontSize: 14),
                        ),
                        Text(
                          '\$${tour['priceDay']}/day',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () => _onAddToCartPressed(tour),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFCE7D66),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        minimumSize: const Size(100, 40),
                      ),
                      child: const Text(
                          'Add to Cart'), // Changed from 'Book Now' to 'Add to Cart'
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

  Widget _buildConsultantCard(Map<String, dynamic> consultant, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
                child: Image.asset(
                  consultant['image'],
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            consultant['name'],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Icon(
                            consultant['isFavorite']
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: consultant['isFavorite']
                                ? Colors.red
                                : Colors.grey,
                            size: 20,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Joined ${consultant['joined']}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          Text(' ${consultant['rating']}'),
                          Text(
                            ' ${consultant['reviews']} Reviews',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '\$${consultant['priceHour']}/hrs',
                        style: const TextStyle(fontSize: 12),
                      ),
                      Text(
                        '\$${consultant['priceDay']}/day',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
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
                      consultant['nextAvailable'],
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () => _onBookNowPressed(consultant),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFCE7D66),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    minimumSize: const Size(80, 36),
                  ),
                  child: const Text(
                    'Book Now',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Text(
        'ForeignConnect',
        style: GoogleFonts.plusJakartaSans(
          color: Colors.black,
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
      backgroundColor: Colors.white,
      elevation: 0,
      actions: [
        IconButton(
          icon: const Icon(Icons.shopping_cart_outlined, color: Colors.black),
          onPressed: _navigateToCart,
        ),
      ],
    );
  }

  Widget _buildCartIcon() {
    return Stack(
      children: [
        IconButton(
          icon: const Icon(Icons.shopping_cart_outlined, color: Colors.black),
          onPressed: _navigateToCart,
        ),
        Positioned(
          right: 8,
          top: 8,
          child: Consumer<CartProvider>(
            builder: (context, cartProvider, child) {
              final itemCount = cartProvider.itemCount;
              return itemCount > 0
                  ? Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Color(0xFFCE7D66),
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        itemCount.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : const SizedBox();
            },
          ),
        ),
      ],
    );
  }

  Widget buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(30),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: const Color(0xFFCE7D66),
          borderRadius: BorderRadius.circular(30),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.grey[600],
        labelStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        tabs: const [
          Tab(text: 'Tour'),
          Tab(text: 'Consult'),
        ],
      ),
    );
  }

  Widget buildCustomTabBar() {
    return Container(
      margin: const EdgeInsets.all(16),
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Colors.grey[100],
      ),
      child: Container(
        padding: const EdgeInsets.all(4),
        child: TabBar(
          controller: _tabController,
          indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: const Color(0xFFCE7D66),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFCE7D66).withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          labelStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey[600],
          tabs: [
            Tab(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                ),
                child: const Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.map_outlined, size: 20),
                      SizedBox(width: 8),
                      Text('Tour'),
                    ],
                  ),
                ),
              ),
            ),
            Tab(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                ),
                child: const Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.person_outline, size: 20),
                      SizedBox(width: 8),
                      Text('Consult'),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(),
      body: Column(
        children: [
          buildCustomTabBar(), // Use the new custom tab bar
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                ListView.builder(
                  itemCount: tours.length,
                  itemBuilder: (context, index) => GestureDetector(
                    onTap: () => _onTourTapped(tours[index]),
                    child: _buildTourCard(tours[index]),
                  ),
                ),
                ListView.builder(
                  itemCount: consultants.length,
                  itemBuilder: (context, index) => GestureDetector(
                    onTap: () => _onConsultantTapped(consultants[index]),
                    child: _buildConsultantCard(consultants[index], index),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
