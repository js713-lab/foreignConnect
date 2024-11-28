import 'package:flutter/material.dart';
import 'package:foreign_connect/screens/DestinationScreen.dart';
import '../screens/ItineraryDetailScreen.dart';

class SuccessScreen extends StatelessWidget {
  final String destination;
  final int days;
  final int nights;
  final String purpose;

  const SuccessScreen({
    super.key,
    required this.destination,
    required this.days,
    required this.nights,
    required this.purpose,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.green.withOpacity(0.1),
              ),
              child: const Center(
                child: Icon(
                  Icons.check,
                  color: Colors.green,
                  size: 60,
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Congratulations!!!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Your Itinerary created\nsuccessfully !!!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFCE816D),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ItineraryDetailScreen(
                        destination: destination,
                        days: days,
                        nights: nights,
                        purpose: purpose,
                      ),
                    ),
                  );
                },
                child: const Text(
                  'Modify Your Itinerary',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const DestinationScreen(userName: 'userNameValue'),
                  ),
                );
              },
              child: const Text(
                'Back To Home',
                style: TextStyle(color: Color(0xFFCE816D)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
