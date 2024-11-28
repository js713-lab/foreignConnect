// lib/screens/profile_screen.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:foreign_connect/screens/SettingScreen.dart';
import 'package:provider/provider.dart';
import '../services/auth_state.dart';
import 'CardScreen.dart';
import '../constants/style_constants.dart';
import '../services/foreign_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  List<CardDetails> cards = [];
  CardDetails? defaultCard;
  late TabController _tabController;
  List<Notification> _notifications = [];
  bool hasUnreadNotifications = true;
  int _selectedIndex = 4;

  String _username = 'User Name';
  String _nationality = 'Nationality';
  String _status = 'Status';
  String? _profileImage;
  List<Map<String, String>> contacts = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadInitialData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    await Future.wait([
      _loadUserData(),
      _loadContacts(),
      Future(() => _loadDummyNotifications()),
      _loadDefaultCard(),
    ]);
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> Function(List<CardDetails>, CardDetails?, CardDetails)
      get setDefaultCardFunction => (List<CardDetails> cards,
              CardDetails? defaultCard, CardDetails card) async {
            try {
              final prefs = await SharedPreferences.getInstance();
              await prefs.setString('default_card_id', card.id);

              setState(() {
                this.defaultCard = card;
              });
              await saveCards();
            } catch (e) {
              debugPrint('Error setting default card: $e');
            }
          };
  // Add this method
  void _loadDummyNotifications() {
    _notifications = [
      Notification(
        title: 'Welcome Back!',
        message: 'Plan your next adventure with us.',
        time: DateTime.now().subtract(const Duration(minutes: 30)),
      ),
      Notification(
        title: 'Trip Reminder',
        message: 'Your trip to Kyoto starts tomorrow',
        time: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      Notification(
        title: 'Special Offer',
        message: 'Get 20% off on your next hotel booking!',
        time: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatTime(DateTime time) {
    final difference = DateTime.now().difference(time);
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  void _showCardDetails(Map<String, dynamic>? userData) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CardScreen(
          initialName: userData?['name'] ?? 'Card Holder',
          initialCardNumber: userData?['card_number'] ?? '',
          initialBalance: userData?['balance']?.toString() ?? '0.00',
          initialBankName: userData?['bank_name'] ?? '',
          // Add missing required parameters
          cards: cards,
          defaultCard: defaultCard,
          onCardUpdated: (updatedCards, newDefaultCard) {
            setState(() {
              cards = updatedCards;
              defaultCard = newDefaultCard;
              saveCards(); // Call saveCards after updating state
            });
          },
          setDefaultCard: setDefaultCard,
        ),
      ),
    );
  }

  String _formatCardNumber(String number) {
    if (number.length != 16) return '**** **** **** ****';
    return '${number.substring(0, 4)} ${number.substring(4, 8)} ${number.substring(8, 12)} ${number.substring(12, 16)}';
  }

  String _formatBalance(dynamic balance) {
    if (balance == null) return '0.00';
    if (balance is String) {
      return double.tryParse(balance)?.toStringAsFixed(2) ?? '0.00';
    }
    if (balance is num) {
      return balance.toStringAsFixed(2);
    }
    return '0.00';
  }

  void _showNotifications() {
    setState(() {
      hasUnreadNotifications = false;
    });

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (_, controller) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Notifications',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.clear_all),
                      onPressed: () {
                        setState(() {
                          _notifications.clear();
                        });
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  controller: controller,
                  itemCount: _notifications.length,
                  itemBuilder: (context, index) {
                    final notification = _notifications[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor:
                            const Color(0xFFCE7D66).withOpacity(0.2),
                        child: const Icon(Icons.notifications,
                            color: Color(0xFFCE7D66)),
                      ),
                      title: Text(notification.title),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(notification.message),
                          Text(
                            _formatTime(notification.time),
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.more_vert),
                        onPressed: () => _showNotificationOptions(notification),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showNotificationOptions(Notification notification) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.mark_email_read),
              title: const Text('Mark as read'),
              onTap: () {
                // Implement mark as read functionality
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline),
              title: const Text('Delete notification'),
              onTap: () {
                setState(() {
                  _notifications
                      .removeWhere((n) => n.time == notification.time);
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _addContact(String name, String number) {
    setState(() {
      contacts.add({
        'name': name,
        'number': number,
      });
    });
    _saveContacts();
  }

  void _handleContacts() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Important Contacts',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: contacts.length,
                  itemBuilder: (context, index) {
                    final contact = contacts[index];
                    return _buildContactItem(
                      contact['name'] ?? '',
                      contact['number'] ?? '',
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _showAddContactDialog(context),
                child: const Text('Add New Contact'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddContactDialog(BuildContext context) {
    final nameController = TextEditingController();
    final numberController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Contact'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                hintText: 'Enter contact name',
              ),
            ),
            TextField(
              controller: numberController,
              decoration: const InputDecoration(
                labelText: 'Number',
                hintText: 'Enter phone number',
              ),
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (nameController.text.isNotEmpty &&
                  numberController.text.isNotEmpty) {
                _addContact(nameController.text, numberController.text);
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  Future<void> setDefaultCard(List<CardDetails> cards, CardDetails? defaultCard,
      CardDetails card) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('default_card_id', card.id);

      setState(() {
        this.defaultCard = card;
      });
      await saveCards(); // Update this to use the class method
    } catch (e) {
      debugPrint('Error setting default card: $e');
    }
  }

  Future<void> _loadUserData() async {
    final authState = context.read<AuthStateProvider>();

    if (!authState.isAuthenticated) {
      return;
    }

    final userData = await authState.getUserData();
    if (userData != null) {
      setState(() {
        _username = userData['name'] ?? 'User Name';
        _nationality = userData['nationality'] ?? 'Nationality';
        _status = userData['status'] ?? 'Status';
        _profileImage = userData['profile_image'];
      });
    }
  }

  Future<void> _loadContacts() async {
    final prefs = await SharedPreferences.getInstance();
    final contactsList = prefs.getStringList('contacts') ?? [];
    if (mounted) {
      setState(() {
        contacts = contactsList.map((contact) {
          final parts = contact.split('|');
          return {
            'name': parts[0],
            'number': parts[1],
          };
        }).toList();
      });
    }
  }

  Future<void> _loadDefaultCard() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final defaultCardId = prefs.getString('default_card_id');
      final cardsJson = prefs.getString('cards');

      if (cardsJson != null) {
        final cardsList = jsonDecode(cardsJson) as List;
        if (mounted) {
          setState(() {
            cards =
                cardsList.map((card) => CardDetails.fromJson(card)).toList();
            if (defaultCardId != null && cards.isNotEmpty) {
              defaultCard = cards.firstWhere(
                (card) => card.id == defaultCardId,
                orElse: () => cards.first,
              );
            } else {
              defaultCard = cards.isNotEmpty ? cards.first : null;
            }
          });
        }
      }
    } catch (e) {
      debugPrint('Error loading default card: $e');
    }
  }

  Future<void> saveCards() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cardsJson =
          json.encode(cards.map((card) => card.toJson()).toList());
      await prefs.setString('cards', cardsJson);

      if (defaultCard != null) {
        await prefs.setString('default_card_id', defaultCard!.id);
      }
    } catch (e) {
      print('Error saving cards: $e');
    }
  }

  Future<void> _saveContacts() async {
    final prefs = await SharedPreferences.getInstance();
    final contactsList = contacts
        .map((contact) => '${contact['name']}|${contact['number']}')
        .toList();
    await prefs.setStringList('contacts', contactsList);
  }

  Widget _buildSliverAppBar(AuthStateProvider authState) {
    return SliverAppBar(
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      backgroundColor: const Color(0xFFCE7D66),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              'https://images.unsplash.com/photo-1501785888041-af3ef285b470',
              fit: BoxFit.cover,
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),
          ],
        ),
        title: Text(
          _username,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      actions: !authState.isGuest
          ? [
              Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.notifications_outlined,
                        color: Colors.white),
                    onPressed: _showNotifications,
                  ),
                  if (hasUnreadNotifications)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 14,
                          minHeight: 14,
                        ),
                        child: const Text(
                          '3',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.settings_outlined, color: Colors.white),
                onPressed: () => _showSettingsModal(context),
              ),
            ]
          : null,
    );
  }

  Widget _buildStatsCard(Map<String, dynamic> userData) {
    final stats = [
      {'label': 'Trips', 'value': userData['trips_count']?.toString() ?? '0'},
      {
        'label': 'Countries',
        'value': userData['countries_count']?.toString() ?? '0'
      },
      {'label': 'Photos', 'value': userData['photos_count']?.toString() ?? '0'},
      {'label': 'Points', 'value': userData['points']?.toString() ?? '0'},
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: stats.asMap().entries.map((entry) {
          final stat = entry.value;
          return Expanded(
            child: Column(
              children: [
                Text(
                  stat['value']!,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFCE7D66),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  stat['label']!,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        indicatorColor: const Color(0xFFCE7D66),
        labelColor: const Color(0xFFCE7D66),
        unselectedLabelColor: Colors.grey,
        tabs: const [
          Tab(text: 'Trips'),
          Tab(text: 'Photos'),
          Tab(text: 'Reviews'),
        ],
      ),
    );
  }

  Widget _buildTabViews(Map<String, dynamic>? userData) {
    return SizedBox(
      height: 400,
      child: TabBarView(
        controller: _tabController,
        children: [
          _buildTripsTab(userData),
          _buildPhotosTab(userData),
          _buildReviewsTab(userData),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthStateProvider>(
      builder: (context, authState, _) {
        if (authState.isLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: Color(0xFFCE7D66)),
            ),
          );
        }

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              _buildSliverAppBar(authState),
              SliverToBoxAdapter(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      if (authState.isGuest)
                        _buildGuestBanner(context)
                      else
                        Column(
                          children: [
                            // Stats Section
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 20.0),
                              color: Colors.white,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  _buildStatItem('Trips', '0'),
                                  _buildStatItem('Countries', '0'),
                                  _buildStatItem('Photos', '0'),
                                  _buildStatItem('Points', '0'),
                                ],
                              ),
                            ),

                            // Remove _buildProfileInfo(null) from here

                            // Card Section
                            if (cards.isNotEmpty || defaultCard != null)
                              _buildVisaCard(null),

                            // Foreign Services
                            _buildServices(),

                            // Rest of the sections remain the same
                            buildTravelMap(),
                            buildUpcomingTrips(),
                            buildTravelPreferences(),
                            buildTravelBadges(),
                            _buildTabBar(),
                            SizedBox(
                              height: 400, // Fixed height for tab content
                              child: TabBarView(
                                controller: _tabController,
                                children: [
                                  _buildTripsTab(null),
                                  _buildPhotosTab(null),
                                  _buildReviewsTab(null),
                                ],
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProfileInfo(Map<String, dynamic>? userData) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.grey[200],
            backgroundImage:
                _profileImage != null ? NetworkImage(_profileImage!) : null,
            child: _profileImage == null
                ? const Icon(Icons.person, size: 50, color: Colors.grey)
                : null,
          ),
          const SizedBox(height: 16),
          Text(
            _username,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _nationality,
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(width: 8),
              Container(
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                _status,
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileContent(Map<String, dynamic>? userData) {
    return Column(
      children: [
        // Profile Card (Basic Info)
        Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.grey[200],
                child: const Icon(Icons.person, size: 40, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              Text(
                userData?['name'] ?? 'User',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                userData?['email'] ?? 'Email not available',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
        ),

        // User Stats
        Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatItem(
                  'Tours', userData?['tours_count']?.toString() ?? '0'),
              _buildStatItem(
                  'Reviews', userData?['reviews_count']?.toString() ?? '0'),
              _buildStatItem('Points', userData?['points']?.toString() ?? '0'),
            ],
          ),
        ),

        // User Info List
        Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoItem(Icons.location_on, 'Location',
                  userData?['location'] ?? 'Not specified'),
              _buildInfoItem(Icons.language, 'Language',
                  userData?['language'] ?? 'Not specified'),
              _buildInfoItem(
                  Icons.phone, 'Phone', userData?['phone'] ?? 'Not specified'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTripsTab(Map<String, dynamic>? userData) {
    final trips = [
      {
        'title': 'Tokyo Adventure',
        'date': 'March 15-22, 2024',
        'image': 'https://images.unsplash.com/photo-1503899036084-c55cdd92da26',
        'status': 'Completed',
        'rating': 4.8,
      },
      {
        'title': 'Kyoto Cultural Tour',
        'date': 'April 5-10, 2024',
        'image': 'https://images.unsplash.com/photo-1493976040374-85c8e12f0c0e',
        'status': 'Upcoming',
        'rating': 4.9,
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: trips.length,
      itemBuilder: (context, index) => _buildTripCard(trips[index]),
    );
  }

  Widget _buildPhotosTab(Map<String, dynamic>? userData) {
    final photos = [
      'https://images.unsplash.com/photo-1480796927426-f609979314bd',
      'https://images.unsplash.com/photo-1524413840807-0c3cb6fa808d',
      'https://images.unsplash.com/photo-1493780474015-ba834fd0ce2f',
      'https://images.unsplash.com/photo-1478436127897-769e1b3f0f36',
    ];

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: photos.length,
      itemBuilder: (context, index) => _buildPhotoItem(photos[index]),
    );
  }

  Widget _buildPhotoItem(String photoUrl) {
    return GestureDetector(
      onTap: () => _showPhotoDetail(photoUrl),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(
            image: NetworkImage(photoUrl),
            fit: BoxFit.cover,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
      ),
    );
  }

  void _showPhotoDetail(String photoUrl) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            image: DecorationImage(
              image: NetworkImage(photoUrl),
              fit: BoxFit.cover,
            ),
          ),
          constraints: const BoxConstraints(maxWidth: 500, maxHeight: 500),
          child: Stack(
            children: [
              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReviewCard(Map<String, dynamic> review) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (review['photos'] != null && (review['photos'] as List).isNotEmpty)
            Container(
              height: 150,
              decoration: BoxDecoration(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
                image: DecorationImage(
                  image: NetworkImage(review['photos'][0]),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      review['place'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber[700], size: 20),
                        const SizedBox(width: 4),
                        Text(
                          review['rating'].toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  review['comment'],
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      review['date'],
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                    Row(
                      children: [
                        Icon(Icons.favorite, color: Colors.red[400], size: 16),
                        const SizedBox(width: 4),
                        Text(
                          review['likes'].toString(),
                          style:
                              TextStyle(color: Colors.grey[600], fontSize: 12),
                        ),
                      ],
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

  Widget _buildReviewsTab(Map<String, dynamic>? userData) {
    final reviews = [
      {
        'place': 'Tokyo Tower',
        'rating': 4.5,
        'comment':
            'Amazing view of the city! Best time to visit is during sunset.',
        'date': '2 days ago',
        'likes': 24,
        'photos': [
          'https://images.unsplash.com/photo-1490806843957-31f4c9a91c65',
        ],
      },
      {
        'place': 'Sensoji Temple',
        'rating': 5.0,
        'comment':
            'Beautiful historic temple with great atmosphere. Don\'t miss the street food!',
        'date': '1 week ago',
        'likes': 42,
        'photos': [
          'https://images.unsplash.com/photo-1480796927426-f609979314bd',
        ],
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: reviews.length,
      itemBuilder: (context, index) => _buildReviewCard(reviews[index]),
    );
  }

  Widget _buildTripCard(Map<String, dynamic> trip) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 4,
      child: Column(
        children: [
          Container(
            height: 150,
            decoration: BoxDecoration(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              image: DecorationImage(
                image: NetworkImage(trip['image']),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      trip['title'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: trip['status'] == 'Completed'
                            ? Colors.green[100]
                            : Colors.blue[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        trip['status'],
                        style: TextStyle(
                          color: trip['status'] == 'Completed'
                              ? Colors.green[700]
                              : Colors.blue[700],
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.calendar_today,
                        size: 16, color: Colors.grey),
                    const SizedBox(width: 8),
                    Text(
                      trip['date'],
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber[700], size: 16),
                        const SizedBox(width: 4),
                        Text(
                          trip['rating'].toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
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

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFCE7D66), size: 20),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AuthStateProvider authState) {
    return AppBar(
      title: const Text(
        'Profile',
        style: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
      backgroundColor: Colors.white,
      elevation: 0,
      actions: !authState.isGuest
          ? [
              IconButton(
                icon: const Icon(Icons.notifications_outlined,
                    color: Colors.black),
                onPressed: () {
                  // Handle notifications
                },
              ),
              IconButton(
                icon: const Icon(Icons.settings_outlined, color: Colors.black),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SettingsScreen()),
                  );
                },
              ),
            ]
          : null,
    );
  }

  List<ForeignService> _getForeignServices() {
    return [
      ForeignService(
        name: 'Emergency\nCall',
        icon: Icons.phone,
        description: '24/7 Emergency Support',
        onTap: () => _handleEmergencyCall(),
      ),
      ForeignService(
        name: 'Visa Card',
        icon: Icons.credit_card,
        description: 'Manage your visa card',
        onTap: () => _handleVisaCard(context.read<AuthStateProvider>()),
      ),
      ForeignService(
        name: 'Language\nTranslation',
        icon: Icons.translate,
        description: 'Real-time translation',
        onTap: () => _handleTranslation(),
      ),
      ForeignService(
        name: 'Contact\nBook',
        icon: Icons.contacts,
        description: 'Important contacts',
        onTap: () => _handleContacts(),
      ),
      ForeignService(
        name: 'Recently\nView',
        icon: Icons.search,
        description: 'View history',
        onTap: () => _handleRecentlyView(),
      ),
    ];
  }

  void _handleEmergencyCall() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Emergency Call'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Emergency Contact Numbers:'),
            const SizedBox(height: 16),
            _buildEmergencyContact('Police', '+1 911'),
            _buildEmergencyContact('Ambulance', '+1 911'),
            _buildEmergencyContact('Embassy', '+1 555-0123'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyContact(String title, String number) {
    return ListTile(
      title: Text(title),
      subtitle: Text(number),
      trailing: IconButton(
        icon: const Icon(Icons.phone),
        onPressed: () {
          // Implement actual phone call functionality
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Calling $title...')),
          );
        },
      ),
    );
  }

  void _handleVisaCard(AuthStateProvider authState) async {
    final userData = await authState.getUserData();
    if (userData != null) {
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CardScreen(
            initialName: userData['name'] ?? 'Card Holder',
            initialCardNumber: userData['card_number'] ?? '',
            initialBalance: userData['balance']?.toString() ?? '0.00',
            initialBankName: userData['bank_name'] ?? '',
            cards: cards,
            defaultCard: defaultCard,
            onCardUpdated: (updatedCards, newDefaultCard) {
              setState(() {
                cards = updatedCards;
                defaultCard = newDefaultCard;
                saveCards();
              });
            },
            setDefaultCard: setDefaultCardFunction,
          ),
        ),
      );
    }
  }

  void _handleTranslation() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        height: 300,
        child: Column(
          children: [
            const Text('Language Translation',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                hintText: 'Enter text to translate',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Translation service coming soon')),
                );
              },
              child: const Text('Translate'),
            ),
          ],
        ),
      ),
    );
  }

  void _addNewContact() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text('Important Contacts',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView(
                children: [
                  _buildContactItem('Local Police', '+1 555-0111'),
                  _buildContactItem('Tourist Help', '+1 555-0222'),
                  _buildContactItem('Hospital', '+1 555-0333'),
                  _buildContactItem('Embassy', '+1 555-0444'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactItem(String name, String number) {
    return ListTile(
      title: Text(name),
      subtitle: Text(number),
      trailing: IconButton(
        icon: const Icon(Icons.phone),
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Calling $name...')),
          );
        },
      ),
    );
  }

  void _handleRecentlyView() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: const Text('Recently Viewed')),
          body: ListView(
            children: [
              _buildRecentItem('Tokyo Tower Visit', 'Yesterday'),
              _buildRecentItem('Mount Fuji Tour', '2 days ago'),
              _buildRecentItem('Kyoto Temple Tour', '3 days ago'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentItem(String title, String time) {
    return ListTile(
      title: Text(title),
      subtitle: Text(time),
      trailing: const Icon(Icons.arrow_forward_ios),
    );
  }

  Widget _buildGuestBanner(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'Create an account to access all features',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFFCE7D66),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Get personalized recommendations, save your favorite destinations, and more!',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, '/login'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFCE7D66),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Log In'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, '/signup'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFFCE7D66),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    side: const BorderSide(color: Color(0xFFCE7D66)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Sign Up'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildProfileHeader(Map<String, dynamic> userData) {
    return Container(
      padding: const EdgeInsets.all(StyleConstants.defaultPadding),
      decoration: const BoxDecoration(
        color: StyleConstants.primaryColor,
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(StyleConstants.borderRadius),
        ),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.white,
            backgroundImage: userData['profile_image'] != null
                ? NetworkImage(userData['profile_image'])
                : null,
            child: userData['profile_image'] == null
                ? const Icon(Icons.person, size: 50, color: Colors.grey)
                : null,
          ),
          const SizedBox(height: 16),
          Text(
            userData['name'] ?? 'User Name',
            style: StyleConstants.titleStyle.copyWith(color: Colors.white),
          ),
          Text(
            '${userData['nationality']} • ${userData['status']}',
            style: StyleConstants.subtitleStyle.copyWith(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget buildCardSection(Map<String, dynamic> userData) {
    return Container(
      margin: const EdgeInsets.all(StyleConstants.defaultPadding),
      decoration: StyleConstants.cardDecoration,
      child: Column(
        children: [
          ListTile(
            title: const Text('Bank of Singapore',
                style: StyleConstants.titleStyle),
            subtitle: Text(userData['card_number'] ?? '',
                style: StyleConstants.subtitleStyle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showCardDetails(userData),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard(Map<String, dynamic>? userData) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.grey[200],
            backgroundImage: userData?['profile_image'] != null
                ? NetworkImage(userData!['profile_image'])
                : null,
            child: userData?['profile_image'] == null
                ? const Icon(Icons.person, size: 40)
                : null,
          ),
          const SizedBox(height: 8),
          Text(
            userData?['name'] ?? 'User Name',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                userData?['nationality'] ?? 'Nationality',
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(width: 8),
              Container(
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                userData?['status'] ?? 'Status',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _navigateToCardScreen(Map<String, dynamic>? userData) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CardScreen(
          initialName: userData?['name'] ?? 'Card Holder',
          initialCardNumber: userData?['card_number'] ?? '',
          initialBalance: userData?['balance']?.toString() ?? '0.00',
          initialBankName: userData?['bank_name'] ?? '',
          cards: cards,
          defaultCard: defaultCard,
          onCardUpdated: (updatedCards, newDefaultCard) {
            setState(() {
              cards = updatedCards;
              defaultCard = newDefaultCard;
              saveCards();
            });
          },
          setDefaultCard: setDefaultCardFunction,
        ),
      ),
    );
  }

  Widget buildUpcomingTrips() {
    final upcomingTrips = [
      {
        'destination': 'Osaka, Japan',
        'startDate': DateTime.now().add(const Duration(days: 30)),
        'endDate': DateTime.now().add(const Duration(days: 35)),
        'imageUrl':
            'https://images.unsplash.com/photo-1590559899731-a382839e5549',
        'activities': ['Food Tour', 'Universal Studios', 'Castle Visit'],
        'budget': 2500.0,
      },
      {
        'destination': 'Seoul, South Korea',
        'startDate': DateTime.now().add(const Duration(days: 60)),
        'endDate': DateTime.now().add(const Duration(days: 67)),
        'imageUrl':
            'https://images.unsplash.com/photo-1590559899731-a382839e5549',
        'activities': ['Palace Tour', 'K-Pop Concert', 'Street Food'],
        'budget': 3000.0,
      },
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Upcoming Trips',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 320,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: upcomingTrips.length,
              itemBuilder: (context, index) {
                final trip = upcomingTrips[index];
                return Container(
                  width: 300,
                  margin: const EdgeInsets.only(right: 16),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(16)),
                          child: Image.network(
                            trip['imageUrl'] as String,
                            height: 150,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                trip['destination'] as String,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(Icons.calendar_today, size: 16),
                                  const SizedBox(width: 8),
                                  Text(
                                    '${_formatDate(trip['startDate'] as DateTime)} - ${_formatDate(trip['endDate'] as DateTime)}',
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                // Using Wrap for activities to prevent overflow
                                spacing: 8,
                                runSpacing: 8,
                                children: (trip['activities'] as List<String>)
                                    .map((activity) => Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.brown[50],
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Text(
                                            activity,
                                            style:
                                                const TextStyle(fontSize: 12),
                                          ),
                                        ))
                                    .toList(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVisaCard(Map<String, dynamic>? userData) {
    return GestureDetector(
      onTap: () => _handleVisaCard(context.read<AuthStateProvider>()),
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: defaultCard?.cardColor != null
                ? [
                    defaultCard!.cardColor,
                    defaultCard!.cardColor.withOpacity(0.8)
                  ]
                : [const Color(0xFFCE7D66), const Color(0xFFE9967A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      defaultCard?.name ?? userData?['name'] ?? 'Card Holder',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      defaultCard?.bankName ?? 'Bank Name',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                Icon(
                  Icons.credit_card,
                  color: Colors.white.withOpacity(0.8),
                  size: 32,
                ),
              ],
            ),
            const Spacer(),
            Text(
              _formatCardNumber(defaultCard?.number ?? ''),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                letterSpacing: 2,
                fontFamily: 'monospace',
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Balance',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '\$${_formatBalance(defaultCard?.balance ?? userData?['balance'])}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServices() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Foreign Services',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Handle view all action
                },
                child: Text(
                  'View All',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              _buildServiceCard(
                icon: Icons.phone,
                title: 'Emergency\nCall',
                onTap: _handleEmergencyCall,
              ),
              _buildServiceCard(
                icon: Icons.credit_card,
                title: 'Visa Card',
                onTap: () => _handleVisaCard(context.read<AuthStateProvider>()),
              ),
              _buildServiceCard(
                icon: Icons.translate,
                title: 'Language\nTranslation',
                onTap: _handleTranslation,
              ),
              _buildServiceCard(
                icon: Icons.contacts,
                title: 'Contact\nBook',
                onTap: _handleContacts,
              ),
              _buildServiceCard(
                icon: Icons.history,
                title: 'Recently\nView',
                onTap: _handleRecentlyView,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildServiceCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        margin: const EdgeInsets.only(right: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: const Color(0xFFCE7D66)),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceItem(IconData icon, String label,
      {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, size: 24),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildExperiences(Map<String, dynamic>? userData) {
    final experiences = _getDummyExperiences();

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${userData?['name']?.split(' ')[0] ?? 'User'}'s Itinerary",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...experiences.map((exp) => _buildExperienceCard(exp)),
        ],
      ),
    );
  }

  Widget _buildExperienceCard([Map<String, dynamic>? experience]) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                experience?['title'] ?? "No Title",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Handle view action
                },
                child: const Text('view'),
              ),
            ],
          ),
          Text(
            'Total Expenses: \$${experience?['total_expenses']?.toString() ?? '0'}',
            style: const TextStyle(color: Colors.grey),
          ),
          Text(
            'Total Days: ${experience?['total_days']?.toString() ?? '0'}',
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getDummyExperiences() {
    return [
      {
        'title': 'Tokyo Adventure',
        'total_expenses': 2500,
        'total_days': 7,
        'description': 'Exploring the vibrant streets of Tokyo',
        'date': '2024-03-15',
        'rating': 4.8,
      },
      {
        'title': 'Kyoto Cultural Tour',
        'total_expenses': 1800,
        'total_days': 5,
        'description': 'Traditional temples and gardens',
        'date': '2024-02-20',
        'rating': 4.9,
      },
      {
        'title': 'Osaka Food Journey',
        'total_expenses': 1200,
        'total_days': 4,
        'description': 'Tasting the best street food',
        'date': '2024-01-10',
        'rating': 4.7,
      },
    ];
  }

  Widget _buildNavItem(
      BuildContext context, IconData icon, String label, int index) {
    final isSelected = index == _selectedIndex;
    return InkWell(
      onTap: () => _onNavItemTapped(context, index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? const Color(0xFFCE7D66) : Colors.grey,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isSelected ? const Color(0xFFCE7D66) : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  void _onNavItemTapped(BuildContext context, int index) {
    setState(() => _selectedIndex = index);

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/destination');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/explore');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/community');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/articles');
        break;
      case 4:
        // Already on profile
        break;
    }
  }

  void _showSettingsModal(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SettingsScreen()),
    );
  }

  Widget buildTravelMap() {
    // This would be replaced with an actual map implementation
    return Container(
      height: 200,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Center(
        child: Text('Travel Map Coming Soon'),
      ),
    );
  }

  Widget buildTravelPreferences() {
    final travelPreferences = {
      'Adventure': 0.8,
      'Cultural': 0.9,
      'Food & Dining': 0.75,
      'Nature': 0.85,
      'Shopping': 0.6,
      'Relaxation': 0.7,
    };

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Travel Interests',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...travelPreferences.entries.map((entry) => Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(entry.key),
                      Text('${(entry.value * 100).toInt()}%'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: entry.value,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _getPreferenceColor(entry.key),
                      ),
                      minHeight: 8,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              )),
        ],
      ),
    );
  }

  Color _getPreferenceColor(String interest) {
    switch (interest) {
      case 'Adventure':
        return Colors.orange;
      case 'Cultural':
        return Colors.purple;
      case 'Food & Dining':
        return Colors.red;
      case 'Nature':
        return Colors.green;
      case 'Shopping':
        return Colors.blue;
      case 'Relaxation':
        return Colors.teal;
      default:
        return const Color(0xFFCE7D66);
    }
  }

  Widget _buildPreferenceRow(String interest, double value) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(interest),
            Text('${(value * 100).toInt()}%'),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: value,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(
              _getPreferenceColor(interest),
            ),
            minHeight: 8,
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget buildTravelBadges() {
    final badges = [
      TravelBadge(
        name: 'First Adventure',
        description: 'Completed first trip',
        imageUrl: 'assets/badges/first_adventure.png',
        earnedDate: DateTime.now().subtract(const Duration(days: 100)),
        color: Colors.blue,
      ),
      TravelBadge(
        name: 'Photo Master',
        description: 'Shared 100+ photos',
        imageUrl: 'assets/badges/photo_master.png',
        earnedDate: DateTime.now().subtract(const Duration(days: 50)),
        color: Colors.green,
      ),
      // Add more badges
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Travel Badges',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: badges.map((badge) => _buildBadge(badge)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(TravelBadge badge) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: badge.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: badge.color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.stars,
              color: badge.color,
              size: 32,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            badge.name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            badge.description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}

class Notification {
  final String title;
  final String message;
  final DateTime time;
  final bool isRead;

  Notification({
    required this.title,
    required this.message,
    required this.time,
    this.isRead = false,
  });
}

class TravelStats {
  final int tripsCount;
  final int countriesVisited;
  final int photosShared;
  final int reviewsWritten;
  final List<String> visitedCountries;
  final Map<String, int> travelPreferences;

  TravelStats({
    required this.tripsCount,
    required this.countriesVisited,
    required this.photosShared,
    required this.reviewsWritten,
    required this.visitedCountries,
    required this.travelPreferences,
  });
}

class TravelBadge {
  final String name;
  final String description;
  final String imageUrl;
  final DateTime earnedDate;
  final Color color;

  TravelBadge({
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.earnedDate,
    required this.color,
  });
}
