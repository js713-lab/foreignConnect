// lib/screens/foreign_wiki/foreign_wiki_screen.dart

import 'package:flutter/material.dart';
import 'CountryDetailScreen.dart';

class ForeignWikiScreen extends StatelessWidget {
  const ForeignWikiScreen({super.key});

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
        title: const Text(
          'ForeignWiki',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_outline, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SavedWikiScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'ForeignWiki is an open community Wiki that anyone can participate in editing, providing foreigners with real-time updated local information and guidance.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 24),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: wikiCountries.map((country) {
                  return _buildCountryCard(context, country);
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCountryCard(BuildContext context, Map<String, dynamic> country) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CountryDetailScreen(
              countryName: country['name'],
              countryData: wikiCountryDetails[country['name']] ?? {},
            ),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              country['image'],
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            country['name'],
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// Dummy data for countries
final List<Map<String, dynamic>> wikiCountries = [
  {'name': 'Singapore', 'image': 'assets/wiki/singapore.jpg'},
  {'name': 'Malaysia', 'image': 'assets/wiki/malaysia.jpg'},
  {'name': 'China', 'image': 'assets/wiki/china.jpg'},
  {'name': 'America', 'image': 'assets/wiki/america.jpg'},
  {'name': 'Taiwan', 'image': 'assets/wiki/taiwan.jpg'},
  {'name': 'Hong Kong', 'image': 'assets/wiki/hongkong.jpg'},
  {'name': 'Korea', 'image': 'assets/wiki/korea.jpg'},
  {'name': 'England', 'image': 'assets/wiki/england.jpg'},
];

// Updated wikiCountryDetails data
final Map<String, Map<String, dynamic>> wikiCountryDetails = {
  'Singapore': {
    'foodPosts': [
      {
        'title': 'Must-Try Singaporean Dishes!',
        'date': '23 November 2024',
        'description':
            'Discover the best local food in Singapore: Hainanese chicken rice, laksa, chili crab, and more traditional hawker favorites.',
        'images': ['assets/wiki/sg_food1.jpg', 'assets/wiki/sg_food2.jpg'],
        'likes': 5,
      },
      {
        'title': 'Hawker Center Guide',
        'date': '22 November 2024',
        'description':
            'Everything you need to know about eating at Singapore hawker centers - from finding the best stalls to understanding prices.',
        'images': ['assets/wiki/sg_hawker1.jpg', 'assets/wiki/sg_hawker2.jpg'],
        'likes': 3,
      },
    ],
    'dailyPosts': [
      {
        'title': 'Public Transportation Guide',
        'date': '21 November 2024',
        'description':
            'Getting around Singapore is easy with the MRT and bus system. Here\'s your complete guide to public transport.',
        'images': ['assets/wiki/sg_mrt.jpg', 'assets/wiki/sg_bus.jpg'],
        'likes': 7,
      },
      {
        'title': 'Shopping in Singapore',
        'date': '20 November 2024',
        'description':
            'From Orchard Road to neighborhood malls, here\'s your guide to shopping in Singapore.',
        'images': [
          'assets/wiki/sg_shopping1.jpg',
          'assets/wiki/sg_shopping2.jpg'
        ],
        'likes': 4,
      },
    ],
    'culturePosts': [
      {
        'title': 'Local Festivals and Celebrations',
        'date': '19 November 2024',
        'description':
            'Experience Singapore\'s multicultural heritage through its various festivals and celebrations throughout the year.',
        'images': [
          'assets/wiki/sg_festival1.jpg',
          'assets/wiki/sg_festival2.jpg'
        ],
        'likes': 6,
      },
    ],
    'trafficPosts': [
      {
        'title': 'Singapore Traffic Update',
        'date': '24 November 2024',
        'description': '',
        'images': ['assets/wiki/sg_traffic.jpg'],
        'likes': 2,
      },
    ],
  },
  'Malaysia': {
    'foodPosts': [
      {
        'title': 'Malaysian Street Food Guide',
        'date': '23 November 2024',
        'description':
            'From nasi lemak to roti canai, discover the best street food Malaysia has to offer.',
        'images': ['assets/wiki/my_food1.jpg', 'assets/wiki/my_food2.jpg'],
        'likes': 8,
      },
      {
        'title': 'Best Mamak Stalls in KL',
        'date': '22 November 2024',
        'description':
            'Your guide to finding the best mamak stalls in Kuala Lumpur for late-night dining.',
        'images': ['assets/wiki/my_mamak1.jpg', 'assets/wiki/my_mamak2.jpg'],
        'likes': 6,
      },
    ],
    'dailyPosts': [
      {
        'title': 'Living in Kuala Lumpur',
        'date': '21 November 2024',
        'description':
            'Essential tips for daily life in KL, from transportation to shopping and entertainment.',
        'images': ['assets/wiki/my_kl1.jpg', 'assets/wiki/my_kl2.jpg'],
        'likes': 5,
      },
    ],
    'culturePosts': [
      {
        'title': 'Malaysian Festivals',
        'date': '20 November 2024',
        'description':
            'Experience the diversity of Malaysian culture through its various festivals and celebrations.',
        'images': [
          'assets/wiki/my_festival1.jpg',
          'assets/wiki/my_festival2.jpg'
        ],
        'likes': 7,
      },
    ],
    'trafficPosts': [
      {
        'title': 'Malaysia Traffic Update',
        'date': '24 November 2024',
        'description': '',
        'images': ['assets/wiki/my_traffic.jpg'],
        'likes': 3,
      },
    ],
  },
  'China': {
    'foodPosts': [
      {
        'title': 'Regional Chinese Cuisines',
        'date': '23 November 2024',
        'description':
            'Explore the diverse flavors of Chinese regional cuisines, from Sichuan to Cantonese.',
        'images': ['assets/wiki/cn_food1.jpg', 'assets/wiki/cn_food2.jpg'],
        'likes': 9,
      },
    ],
    'dailyPosts': [
      {
        'title': 'Living in Chinese Cities',
        'date': '22 November 2024',
        'description':
            'Essential tips for daily life in major Chinese cities, including mobile payments and transportation.',
        'images': ['assets/wiki/cn_city1.jpg', 'assets/wiki/cn_city2.jpg'],
        'likes': 6,
      },
    ],
    'culturePosts': [
      {
        'title': 'Chinese Traditions',
        'date': '21 November 2024',
        'description':
            'Understanding important Chinese customs, traditions, and cultural practices.',
        'images': [
          'assets/wiki/cn_culture1.jpg',
          'assets/wiki/cn_culture2.jpg'
        ],
        'likes': 8,
      },
    ],
    'trafficPosts': [
      {
        'title': 'China Traffic Update',
        'date': '24 November 2024',
        'description': '',
        'images': ['assets/wiki/cn_traffic.jpg'],
        'likes': 4,
      },
    ],
  },
  'America': {
    'foodPosts': [
      {
        'title': 'American Food Culture',
        'date': '23 November 2024',
        'description':
            'From burgers to BBQ, explore the diverse food culture across different American regions.',
        'images': ['assets/wiki/us_food1.jpg', 'assets/wiki/us_food2.jpg'],
        'likes': 7,
      },
    ],
    'dailyPosts': [
      {
        'title': 'Living in the USA',
        'date': '22 November 2024',
        'description':
            'Essential tips for daily life in America, including transportation, shopping, and healthcare.',
        'images': ['assets/wiki/us_life1.jpg', 'assets/wiki/us_life2.jpg'],
        'likes': 5,
      },
    ],
    'culturePosts': [
      {
        'title': 'American Holidays',
        'date': '21 November 2024',
        'description':
            'Guide to major American holidays and celebrations throughout the year.',
        'images': [
          'assets/wiki/us_holiday1.jpg',
          'assets/wiki/us_holiday2.jpg'
        ],
        'likes': 6,
      },
    ],
    'trafficPosts': [
      {
        'title': 'America Traffic Update',
        'date': '24 November 2024',
        'description': '',
        'images': ['assets/wiki/us_traffic.jpg'],
        'likes': 3,
      },
    ],
  },
  'Taiwan': {
    'foodPosts': [
      {
        'title': 'Taiwan Night Market Guide',
        'date': '23 November 2024',
        'description':
            'Experience the best of Taiwan\'s famous night market food culture.',
        'images': ['assets/wiki/tw_food1.jpg', 'assets/wiki/tw_food2.jpg'],
        'likes': 8,
      },
    ],
    'dailyPosts': [
      {
        'title': 'Living in Taipei',
        'date': '22 November 2024',
        'description':
            'Essential tips for daily life in Taipei, from transportation to accommodation.',
        'images': ['assets/wiki/tw_life1.jpg', 'assets/wiki/tw_life2.jpg'],
        'likes': 6,
      },
    ],
    'culturePosts': [
      {
        'title': 'Taiwanese Traditions',
        'date': '21 November 2024',
        'description':
            'Discover the unique cultural traditions and customs of Taiwan.',
        'images': [
          'assets/wiki/tw_culture1.jpg',
          'assets/wiki/tw_culture2.jpg'
        ],
        'likes': 7,
      },
    ],
    'trafficPosts': [
      {
        'title': 'Taiwan Traffic Update',
        'date': '24 November 2024',
        'description': '',
        'images': ['assets/wiki/tw_traffic.jpg'],
        'likes': 2,
      },
    ],
  },
  'Hong Kong': {
    'foodPosts': [
      {
        'title': 'Hong Kong Food Guide',
        'date': '23 November 2024',
        'description':
            'From dim sum to street food, explore the best of Hong Kong\'s food scene.',
        'images': ['assets/wiki/hk_food1.jpg', 'assets/wiki/hk_food2.jpg'],
        'likes': 9,
      },
    ],
    'dailyPosts': [
      {
        'title': 'Living in Hong Kong',
        'date': '22 November 2024',
        'description':
            'Essential tips for daily life in Hong Kong, including housing and transportation.',
        'images': ['assets/wiki/hk_life1.jpg', 'assets/wiki/hk_life2.jpg'],
        'likes': 7,
      },
    ],
    'culturePosts': [
      {
        'title': 'Hong Kong Culture',
        'date': '21 November 2024',
        'description':
            'Understanding the unique blend of traditional and modern culture in Hong Kong.',
        'images': [
          'assets/wiki/hk_culture1.jpg',
          'assets/wiki/hk_culture2.jpg'
        ],
        'likes': 6,
      },
    ],
    'trafficPosts': [
      {
        'title': 'Hong Kong Traffic Update',
        'date': '24 November 2024',
        'description': '',
        'images': ['assets/wiki/hk_traffic.jpg'],
        'likes': 3,
      },
    ],
  },
  'Korea': {
    'foodPosts': [
      {
        'title': 'Korean Food Guide',
        'date': '23 November 2024',
        'description':
            'Discover popular Korean dishes and where to find them in Seoul.',
        'images': ['assets/wiki/kr_food1.jpg', 'assets/wiki/kr_food2.jpg'],
        'likes': 8,
      },
    ],
    'dailyPosts': [
      {
        'title': 'Living in Korea',
        'date': '22 November 2024',
        'description':
            'Essential tips for daily life in Korea, including accommodation and public services.',
        'images': ['assets/wiki/kr_life1.jpg', 'assets/wiki/kr_life2.jpg'],
        'likes': 6,
      },
    ],
    'culturePosts': [
      {
        'title': 'Korean Culture',
        'date': '21 November 2024',
        'description':
            'Understanding Korean customs, etiquette, and social norms.',
        'images': [
          'assets/wiki/kr_culture1.jpg',
          'assets/wiki/kr_culture2.jpg'
        ],
        'likes': 7,
      },
    ],
    'trafficPosts': [
      {
        'title': 'Korea Traffic Update',
        'date': '24 November 2024',
        'description': '',
        'images': ['assets/wiki/kr_traffic.jpg'],
        'likes': 2,
      },
    ],
  },
  'England': {
    'foodPosts': [
      {
        'title': 'British Cuisine Guide',
        'date': '23 November 2024',
        'description':
            'Beyond fish and chips: explore traditional and modern British cuisine.',
        'images': ['assets/wiki/uk_food1.jpg', 'assets/wiki/uk_food2.jpg'],
        'likes': 6,
      },
    ],
    'dailyPosts': [
      {
        'title': 'Living in London',
        'date': '22 November 2024',
        'description':
            'Essential tips for daily life in London, from transportation to accommodation.',
        'images': ['assets/wiki/uk_life1.jpg', 'assets/wiki/uk_life2.jpg'],
        'likes': 7,
      },
    ],
    'culturePosts': [
      {
        'title': 'British Culture',
        'date': '21 November 2024',
        'description':
            'Understanding British customs, traditions, and social etiquette.',
        'images': [
          'assets/wiki/uk_culture1.jpg',
          'assets/wiki/uk_culture2.jpg'
        ],
        'likes': 5,
      },
    ],
    'trafficPosts': [
      {
        'title': 'England Traffic Update',
        'date': '24 November 2024',
        'description': '',
        'images': ['assets/wiki/uk_traffic.jpg'],
        'likes': 3,
      },
    ],
  },
};

class SavedWikiScreen extends StatelessWidget {
  const SavedWikiScreen({super.key});

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
        title: const Text(
          'Saved Articles',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: savedWikiArticles.length,
        itemBuilder: (context, index) {
          final article = savedWikiArticles[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.asset(
                    article['image'],
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            article['country'],
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            article['date'],
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        article['title'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        article['description'],
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// Dummy data for saved wiki articles
final List<Map<String, dynamic>> savedWikiArticles = [
  {
    'country': 'Singapore',
    'title': 'Must-Try Local Food Spots in Chinatown',
    'date': '24 Nov 2024',
    'description':
        'Discover the hidden gems of Singapore\'s famous food scene in the heart of Chinatown. From traditional hawker stalls to modern fusion restaurants...',
    'image': 'assets/wiki/singapore_food.jpg',
  },
  {
    'country': 'Japan',
    'title': 'Cherry Blossom Festival Guide 2024',
    'date': '20 Nov 2024',
    'description':
        'Complete guide to enjoying the cherry blossom season in Japan. Best viewing spots, festival dates, and local customs you should know...',
    'image': 'assets/wiki/japan_sakura.jpg',
  },
  {
    'country': 'Korea',
    'title': 'Transportation Guide in Seoul',
    'date': '18 Nov 2024',
    'description':
        'Everything you need to know about getting around in Seoul. From subway routes to bus systems, and transportation apps...',
    'image': 'assets/wiki/korea_transport.jpg',
  },
  {
    'country': 'Malaysia',
    'title': 'Weekend Markets in Kuala Lumpur',
    'date': '15 Nov 2024',
    'description':
        'Explore the vibrant weekend markets of KL. From traditional craft markets to modern art bazaars, find the best spots for local shopping...',
    'image': 'assets/wiki/malaysia_market.jpg',
  }
];
