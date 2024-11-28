import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_state.dart';
import '../services/biometric_service.dart';
import '../screens/settings/PrivacyScreen.dart';
import '../screens/settings/SecurityScreen.dart';
import '../screens/settings/SubscriptionScreen.dart';
import 'PersonalInfoScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final BiometricService _biometricService = BiometricService();
  bool _biometricEnabled = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadBiometricState();
  }

  Future<void> _loadBiometricState() async {
    try {
      final enabled = await _biometricService.isBiometricEnabled();
      if (mounted) {
        setState(() => _biometricEnabled = enabled);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading biometric state: $e')),
        );
      }
    }
  }

  Future<void> _toggleBiometric(bool value) async {
    setState(() => _isLoading = true);
    try {
      if (value) {
        final available = await _biometricService.isBiometricAvailable();
        if (!available) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Biometric authentication not available')),
            );
          }
          return;
        }

        final authenticated =
            await _biometricService.authenticateWithBiometrics();
        if (authenticated && mounted) {
          await _biometricService.setBiometricEnabled(true);
          setState(() => _biometricEnabled = true);
        }
      } else {
        await _biometricService.setBiometricEnabled(false);
        setState(() => _biometricEnabled = false);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error toggling biometric: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Widget _buildListTile(
    String title,
    String subtitle,
    IconData icon, {
    bool hasWarning = false,
    bool hasToggle = false,
    bool? toggleValue,
    Function(bool)? onToggle,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: const Color(0xFFCE7D66)),
      ),
      title: Text(title),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: Colors.grey[600], fontSize: 12),
      ),
      trailing: hasWarning
          ? const Icon(Icons.warning_amber_rounded, color: Colors.red)
          : hasToggle
              ? Switch(
                  value: toggleValue ?? false,
                  onChanged: onToggle,
                  activeColor: const Color(0xFFCE7D66),
                )
              : const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
        ),
        ...children,
      ],
    );
  }

  Widget _buildLogoutTile(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.logout, color: Colors.red),
      ),
      title: const Text('Log out', style: TextStyle(color: Colors.red)),
      subtitle: Text(
        'Further secure your account for safety',
        style: TextStyle(color: Colors.grey[600], fontSize: 12),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () async {
        await context.read<AuthStateProvider>().logout();
        if (context.mounted) {
          Navigator.pushReplacementNamed(context, '/');
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Settings'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                _buildSection('Account', [
                  _buildListTile(
                    'My Account',
                    'Make changes to your account',
                    Icons.person_outline,
                    hasWarning: true,
                    onTap: () async {
                      try {
                        final userDoc = await FirebaseFirestore.instance
                            .collection('users')
                            .doc(FirebaseAuth.instance.currentUser?.uid)
                            .get();

                        if (userDoc.exists && mounted) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PersonalInfoScreen(
                                userId: userDoc.id,
                                userEmail: userDoc.data()?['email'] ?? '',
                              ),
                            ),
                          );
                        }
                      } catch (e) {
                        // Handle error
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Error loading user data'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                  ),
                  _buildListTile(
                    'Security',
                    'Make changes to your account',
                    Icons.security_outlined,
                    hasWarning: true,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SecurityScreen(),
                      ),
                    ),
                  ),
                  _buildListTile(
                    'Face ID / Touch ID',
                    'Manage your device security',
                    Icons.fingerprint,
                    hasToggle: true,
                    toggleValue: _biometricEnabled,
                    onToggle: _toggleBiometric,
                  ),
                  _buildListTile(
                    'Subscription',
                    'Manage your subscription',
                    Icons.card_membership_outlined,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SubscriptionScreen(),
                      ),
                    ),
                  ),
                  _buildListTile(
                    'Privacy',
                    'Manage your privacy settings',
                    Icons.privacy_tip_outlined,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PrivacyScreen(),
                      ),
                    ),
                  ),
                ]),
                _buildSection('Partner Center', [
                  _buildListTile(
                    'Be Our Partner',
                    'Join our partnership program',
                    Icons.handshake_outlined,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PartnerScreen()),
                    ),
                  ),
                ]),
                _buildSection('Support', [
                  _buildListTile(
                    'Help & Support',
                    'Get assistance and FAQs',
                    Icons.help_outline,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HelpSupportScreen()),
                    ),
                  ),
                  _buildListTile(
                    'Terms & Policies',
                    'Review our terms and policies',
                    Icons.policy_outlined,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TermsPoliciesScreen()),
                    ),
                  ),
                  _buildListTile(
                    'Report a Problem',
                    'Submit issues or feedback',
                    Icons.report_problem_outlined,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ReportProblemScreen()),
                    ),
                  ),
                ]),
                _buildLogoutTile(context),
              ],
            ),
    );
  }
}

class ReportProblemScreen extends StatefulWidget {
  const ReportProblemScreen({super.key});

  @override
  _ReportProblemScreenState createState() => _ReportProblemScreenState();
}

class PartnerScreen extends StatelessWidget {
  const PartnerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Be Our Partner')),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Partner Benefits',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 16),
                  _buildBenefitTile(Icons.monetization_on, 'Revenue Sharing',
                      'Earn up to 30% commission on referred customers'),
                  _buildBenefitTile(Icons.support_agent, 'Dedicated Support',
                      '24/7 partner support channel'),
                  _buildBenefitTile(Icons.campaign, 'Marketing Resources',
                      'Access to marketing materials and training'),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFCE7D66),
              padding: EdgeInsets.symmetric(vertical: 16),
            ),
            child: Text('Apply Now'),
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitTile(IconData icon, String title, String subtitle) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFFCE7D66)),
      title: Text(title),
      subtitle: Text(subtitle),
    );
  }
}

class HelpSupportScreen extends StatelessWidget {
  final List<Map<String, String>> faqItems = [
    {
      'question': 'How do I reset my password?',
      'answer': 'Go to Security settings and select "Reset Password" option.'
    },
    {
      'question': 'How to enable biometric login?',
      'answer':
          'Navigate to Settings > Security > Face ID/Touch ID and toggle the switch.'
    },
    {
      'question': 'Payment failed?',
      'answer':
          'Please verify your payment method and try again. If the issue persists, contact support.'
    },
  ];

  HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Help & Support')),
      body: ListView.builder(
        itemCount: faqItems.length,
        itemBuilder: (context, index) {
          return ExpansionTile(
            title: Text(faqItems[index]['question']!),
            children: [
              Padding(
                padding: EdgeInsets.all(16),
                child: Text(faqItems[index]['answer']!),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ReportProblemScreenState extends State<ReportProblemScreen> {
  final _formKey = GlobalKey<FormState>();
  String _category = 'Technical';
  final _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Report a Problem')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            DropdownButtonFormField<String>(
              value: _category,
              decoration: InputDecoration(labelText: 'Category'),
              items: ['Technical', 'Account', 'Billing', 'Other']
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (value) => setState(() => _category = value!),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Please describe the problem' : null,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  // Submit report logic
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFCE7D66),
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text('Submit Report'),
            ),
          ],
        ),
      ),
    );
  }
}

class TermsPoliciesScreen extends StatelessWidget {
  const TermsPoliciesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Terms & Policies')),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              title: Text('Privacy Policy'),
              subtitle: Text('Last updated: March 2024'),
              onTap: () {},
            ),
          ),
          Card(
            child: ListTile(
              title: Text('Terms of Service'),
              subtitle: Text('Last updated: February 2024'),
              onTap: () {},
            ),
          ),
          Card(
            child: ListTile(
              title: Text('Cookie Policy'),
              subtitle: Text('Last updated: January 2024'),
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }
}
