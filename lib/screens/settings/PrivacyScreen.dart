// PrivaryScreen.dart

import 'package:flutter/material.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Privacy')),
      body: ListView(
        children: const [
          ListTile(
            title: Text('Privacy Policy'),
            subtitle: Text('Read our privacy policy'),
            leading: Icon(Icons.policy),
          ),
          ListTile(
            title: Text('Data Usage'),
            subtitle: Text('Manage how your data is used'),
            leading: Icon(Icons.data_usage),
          ),
          ListTile(
            title: Text('Account Data'),
            subtitle: Text('Download or delete your account data'),
            leading: Icon(Icons.download),
          ),
        ],
      ),
    );
  }
}
