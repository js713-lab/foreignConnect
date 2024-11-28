import 'package:flutter/material.dart';

class ConsultMessageScreen extends StatelessWidget {
  final Map<String, dynamic> consultant;
  final Map<String, dynamic>? itinerary;

  const ConsultMessageScreen({
    super.key,
    required this.consultant,
    this.itinerary,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Consult',
            style: TextStyle(color: Colors.black),
          ),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Details'),
              Tab(text: 'Messages'),
            ],
            labelColor: Color(0xFFCE7D66),
            unselectedLabelColor: Colors.grey,
            indicatorColor: Color(0xFFCE7D66),
          ),
        ),
        body: TabBarView(
          children: [
            // Details Tab
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (itinerary != null)
                    Container(
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.all(16),
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
                          const Text(
                            'Selected Itinerary:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(
                                  itinerary!['image'],
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      itinerary!['title'],
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      itinerary!['date'],
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Billing Address',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Taylor University Lakeside Campus',
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          'Subang Jaya, Malaysia',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            OutlinedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.edit),
                              label: const Text('Edit Address'),
                            ),
                            const SizedBox(width: 8),
                            OutlinedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.note_add),
                              label: const Text('Add Note'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Payment Summary section
                  const PaymentSummarySection(),
                ],
              ),
            ),
            // Messages Tab
            const ConsultMessagesTab(),
          ],
        ),
      ),
    );
  }
}

class PaymentSummarySection extends StatelessWidget {
  const PaymentSummarySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Payment Summary',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Price'),
              const Text('\$99.99'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Delivery Fee'),
              Text(
                '\$1.0',
                style: TextStyle(
                  decoration: TextDecoration.lineThrough,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Payment Method',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.wallet, color: Colors.grey[600]),
                    const SizedBox(width: 8),
                    const Text('Cash/Wallet'),
                  ],
                ),
                const Text('\$5.53'),
              ],
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFCE7D66),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Order'),
            ),
          ),
        ],
      ),
    );
  }
}

class ConsultMessagesTab extends StatelessWidget {
  final Map<String, dynamic>? itinerary;

  const ConsultMessagesTab({
    super.key,
    this.itinerary,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Message card
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
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
              if (itinerary != null) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    itinerary!['image'],
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  itinerary!['title'],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'I would like to consult about this itinerary...',
                  style: TextStyle(color: Colors.grey),
                ),
              ] else ...[
                const Text(
                  'New Consultation',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'I would like to plan a new itinerary...',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  'assets/images/singapore_1.jpg',
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Abroad To SG',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'Heyy, i had an enquiry about.......Can u let me know the price/h',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),

        // Consultant list
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Ask and know more information from consult',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        // Consultant selection list
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: const [
              ConsultantSelectionTile(
                name: 'Makabaka',
                image: 'assets/images/consultants/consultant_1.jpg',
                rating: 4.0,
                reviews: 36,
                priceHour: 10.0,
                priceDay: 110.0,
                joined: '2yrs ago',
                isSelected: true,
              ),
              ConsultantSelectionTile(
                name: 'Usidisi',
                image: 'assets/images/consultants/consultant_2.jpg',
                rating: 4.4,
                reviews: 18,
                priceHour: 8.0,
                priceDay: 100.0,
                joined: '1yrs ago',
              ),
              ConsultantSelectionTile(
                name: 'Seng Seng',
                image: 'assets/images/consultants/consultant_3.jpg',
                rating: 4.0,
                reviews: 48,
                priceHour: 10.0,
                priceDay: 110.0,
                joined: '4yrs ago',
              ),
            ],
          ),
        ),

        // Click and Send button
        Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFCE7D66),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Click And Send'),
            ),
          ),
        ),
      ],
    );
  }
}

class ConsultantSelectionTile extends StatelessWidget {
  final String name;
  final String image;
  final double rating;
  final int reviews;
  final double priceHour;
  final double priceDay;
  final String joined;
  final bool isSelected;

  const ConsultantSelectionTile({
    super.key,
    required this.name,
    required this.image,
    required this.rating,
    required this.reviews,
    required this.priceHour,
    required this.priceDay,
    required this.joined,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? const Color(0xFFCE7D66) : Colors.grey.shade200,
        ),
      ),
      child: Row(
        children: [
          Checkbox(
            value: isSelected,
            onChanged: (value) {},
            activeColor: const Color(0xFFCE7D66),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              image,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Joined $joined',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    Text(' $rating'),
                    Text(
                      ' $reviews Reviews',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                Text(
                  '\$$priceHour/hrs    \$$priceDay/day',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
