// termOfServiceScreen.dart

import 'package:flutter/material.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms of Service'),
        backgroundColor: const Color(0xFFCE7D66),
        foregroundColor: Colors.white,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Terms of Service',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E1E1E),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Last updated: November 21, 2024',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 24),
            Text(
              '1. Acceptance of Terms',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'By accessing or using our services, you agree to be bound by these terms of service.',
            ),
            SizedBox(height: 16),
            Text(
              '2. Use License',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'We grant you a limited, non-exclusive, non-transferable license to use our services for personal, non-commercial purposes.',
            ),
            SizedBox(height: 16),
            Text(
              '3. User Conduct',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'You agree not to use our services for any unlawful purpose or in any way that could damage, disable, or impair our services.',
            ),
            SizedBox(height: 16),
            Text(
              '4. Modifications',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'We reserve the right to modify or replace these terms of service at any time. Your continued use of our services following any changes constitutes acceptance of those changes.',
            ),
          ],
        ),
      ),
    );
  }
}
