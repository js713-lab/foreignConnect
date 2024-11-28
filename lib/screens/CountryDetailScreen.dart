import 'package:flutter/material.dart';

class CountryDetailScreen extends StatefulWidget {
  final String countryName;
  final Map<String, dynamic> countryData;

  const CountryDetailScreen({
    super.key,
    required this.countryName,
    required this.countryData,
  });

  @override
  State<CountryDetailScreen> createState() => _CountryDetailScreenState();
}

class _CountryDetailScreenState extends State<CountryDetailScreen> {
  String _selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.countryName,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'ForeignWiki is an open community Wiki that anyone can participate in editing, providing foreigners with real-time updated local information and guidance.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ),
          // Category Filters
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                _buildCategoryChip('All'),
                _buildCategoryChip('Food'),
                _buildCategoryChip('Daily'),
                _buildCategoryChip('Traffic'),
                _buildCategoryChip('Culture'),
              ],
            ),
          ),
          const Divider(),
          // Posts List
          Expanded(
            child: ListView.builder(
              itemCount: _getFilteredPosts().length,
              itemBuilder: (context, index) {
                final post = _getFilteredPosts()[index];
                return _buildPostCard(post);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String category) {
    final isSelected = _selectedCategory == category;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(category),
        selected: isSelected,
        backgroundColor: Colors.white,
        selectedColor: const Color(0xFFCE7D66),
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
        ),
        onSelected: (selected) {
          setState(() {
            _selectedCategory = category;
          });
        },
      ),
    );
  }

  Widget _buildPostCard(Map<String, dynamic> post) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 4,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                decoration: const BoxDecoration(
                  color: Color(0xFFCE7D66),
                  shape: BoxShape.circle,
                ),
              ),
              Expanded(
                child: Text(
                  post['title'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.verified, color: Color(0xFFCE7D66)),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () {},
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: List.generate(
                    post['likes'],
                    (index) => const Padding(
                      padding: EdgeInsets.only(right: 4),
                      child: CircleAvatar(radius: 8),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(post['date']),
                const SizedBox(height: 8),
                Text(post['description']),
                const SizedBox(height: 8),
                if (post['images'] != null)
                  SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: post['images'].length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              post['images'][index],
                              height: 120,
                              width: 120,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getFilteredPosts() {
    if (_selectedCategory == 'All') {
      return widget.countryData['foodPosts'] ?? [];
    } else if (_selectedCategory == 'Food') {
      return widget.countryData['foodPosts'] ?? [];
    } else if (_selectedCategory == 'Daily') {
      return widget.countryData['dailyPosts'] ?? [];
    } else if (_selectedCategory == 'Traffic') {
      return widget.countryData['trafficPosts'] ?? [];
    } else {
      return widget.countryData['culturePosts'] ?? [];
    }
  }
}
