import 'package:flutter/material.dart';
import '../screens/ChatDetailScreen.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key});

  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  List<Map<String, dynamic>> events = [
    {
      'title': 'New York',
      'description':
          "There's a huge party of charity launch at the statue of liberty! Check us out on 12 December 2024 😊",
      'time': '2 hours ago',
      'image': 'assets/images/events/newyork.jpg',
    },
    {
      'title': 'Germany',
      'description':
          "There's a huge party of charity launch at the statue of liberty! Check us out on 12 December 2024 😊",
      'time': '16 hours ago',
      'image': 'assets/images/events/germany.jpg',
    },
  ];

  List<Map<String, dynamic>> notifications = [
    {
      'name': 'Makabaka',
      'message':
          "Thanks for choosing me as your tour guide! Can't wait to see you at tomorrow 3:00p.m.",
      'time': '2 hours ago',
      'image': 'assets/images/users/makabaka.jpg',
    },
    {
      'name': 'Updates',
      'message':
          'There will be a huge update coming Friday. The system will down for 2 hours at 5p.m.',
      'time': '5 minutes ago',
      'image': 'assets/images/system/updates.png',
    },
    {
      'name': 'User 1',
      'message':
          'Just went to the scenic spot that the guide took us to, it was really amazing! You have to see it!',
      'time': '2 hours ago',
      'image': 'assets/images/users/user1.jpg',
    },
    {
      'name': 'User 2',
      'message':
          "We are going to hang out at the night market after our trip today. Will you come? I hear there's a lot of good food!",
      'time': '2 hours ago',
      'image': 'assets/images/users/user2.jpg',
    },
    {
      'name': 'Movie Night',
      'message': "I can bring some chocolate and a drink. Let's make it 7OO.",
      'time': '6 hours ago',
      'image': 'assets/images/events/movie.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Message',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Events Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Events',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.notifications_none),
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...events.map((event) => _buildEventItem(event)),
          TextButton(
            onPressed: () {},
            child: const Text('More '),
          ),
          const SizedBox(height: 16),

          // Notifications Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Messages',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.notifications_none),
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...notifications
              .map((notification) => _buildNotificationItem(notification)),
        ],
      ),
    );
  }

  Widget _buildEventItem(Map<String, dynamic> event) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatDetailScreen(
              name: event['title'],
              imageUrl: event['image'],
              chatId: 'defaultChatId', // Add this
              userId: 'currentUserId', // Add this
              recipientId: 'recipientId', // Add this
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                event['image'],
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event['title'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    event['description'],
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    event['time'],
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 12,
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

  Widget _buildNotificationItem(Map<String, dynamic> notification) {
    return InkWell(
      onTap: () {
        // Update both Navigator.push calls in _buildEventItem and _buildNotificationItem
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatDetailScreen(
              name: notification['name'], // Changed from event['title']
              imageUrl: notification['image'], // Changed from event['image']
              chatId: 'defaultChatId',
              userId: 'currentUserId',
              recipientId: 'recipientId',
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage(notification['image']),
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
                        notification['name'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        notification['time'],
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification['message'],
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
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
