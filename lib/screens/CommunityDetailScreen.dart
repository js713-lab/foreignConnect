// community_detail_screen.dart
import 'package:flutter/material.dart';

class CommunityDetailScreen extends StatelessWidget {
  final String title;
  final String headerImage;
  final Map<String, dynamic> data;

  const CommunityDetailScreen({
    super.key,
    required this.title,
    required this.headerImage,
    required this.data,
  });

  void _showJoinSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text(
            'Joined Successfully!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          content: const Text(
            'You have successfully joined the group. You will receive notifications for upcoming events.',
            textAlign: TextAlign.center,
          ),
          actions: [
            Center(
              child: TextButton(
                child: const Text(
                  'OK',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Image
            Image.asset(
              headerImage,
              height: 200,
              fit: BoxFit.cover,
            ),

            // Subtitle
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                data['subtitle'],
                style: const TextStyle(
                  color: Colors.blue,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            // Join Now Button
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'JOIN NOW!!!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),

            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Different type of activities',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            // List of sections
            ...data['sections']
                .map<Widget>((section) => _buildSectionCard(context, section))
                .toList(),

            const SizedBox(height: 16),

            // Read More button
            Center(
              child: TextButton(
                onPressed: () {},
                child: const Text(
                  'Read More',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard(BuildContext context, Map<String, dynamic> section) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              section['image'],
              height: 150,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            section['title'],
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          ...section['details']
              .map<Widget>((detail) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${section['details'].indexOf(detail) + 1}. ',
                            style: const TextStyle(color: Colors.grey)),
                        Expanded(
                          child: Text(
                            detail,
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                  ))
              .toList(),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => _showJoinSuccessDialog(context),
              child: const Text('Join Group'),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
