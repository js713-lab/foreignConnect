// SubcriptionScreen.dart

import 'package:flutter/material.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Subscription')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSubscriptionCard(
            'Basic Plan',
            'Free',
            ['Basic features', 'Limited access'],
            isActive: true,
          ),
          _buildSubscriptionCard(
            'Premium Plan',
            '\$9.99/month',
            ['All features', 'Priority support', 'No ads'],
            isActive: false,
          ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionCard(
    String title,
    String price,
    List<String> features, {
    bool isActive = false,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: const TextStyle(fontSize: 18)),
                Text(price, style: const TextStyle(fontSize: 16)),
              ],
            ),
            const Divider(),
            ...features.map((feature) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      const Icon(Icons.check, size: 16),
                      const SizedBox(width: 8),
                      Text(feature),
                    ],
                  ),
                )),
            if (!isActive)
              ElevatedButton(
                onPressed: () {},
                child: const Text('Upgrade Now'),
              ),
          ],
        ),
      ),
    );
  }
}
