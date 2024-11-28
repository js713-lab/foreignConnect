// lib/data/wiki_data.dart

final Map<String, Map<String, dynamic>> wikiCountryDetails = {
  'Singapore': {
    'foodPosts': [
      {
        'title': 'Delicious Hainanese chicken rice!',
        'date': '23 September 2024',
        'description':
            'This dish is almost a household classic in Singapore, and the chicken is served with fragrant chicken fat rice and a little chili sauce, which is perfect! Especially Tian Tian Hainanese Chicken Rice at Maxwell Hawker Centre, which many people say is one of the must-eat.',
        'images': [
          'assets/wiki/singapore/chicken_rice_1.jpg',
          'assets/wiki/singapore/chicken_rice_2.jpg'
        ],
        'likes': 3,
        'verified': true,
      },
      {
        'title': 'The treasure stall in the alley!',
        'date': '17 September 2024',
        'description':
            'I recently went to a hidden alley pancake stand called Auntie Pancake, with no sign and only scent to find it. The thin crust is filled with peanut butter, coconut, and banana slices. It\'s so delicious! And for only \$2, you can eat and be satisfied!',
        'images': [
          'assets/wiki/singapore/pancake_1.jpg',
          'assets/wiki/singapore/pancake_2.jpg'
        ],
        'likes': 5,
        'verified': true,
      },
      {
        'title': 'It\'s really easy to make mapo tofu at home!',
        'date': '15 September 2024',
        'description':
            'Prepare a piece of tofu, 50 grams of minced pork, a spoonful of Pixian bean sauce, and add minced garlic, light soy sauce, sugar and chili powder. Stir-fry minced garlic and minced meat in a hot pan with good oil, then add bean paste and stir-fry well. Finally, add sliced tofu and simmer for 3-5 minutes.',
        'images': ['assets/wiki/singapore/mapo_tofu.jpg'],
        'likes': 6,
        'verified': true,
      }
    ],
    'dailyPosts': [
      {
        'title': 'MRT Guide for Newcomers',
        'date': '22 September 2024',
        'description':
            'A comprehensive guide to using Singapore\'s MRT system. Get your EZ-Link card from any station, top it up, and tap in/out at the gates. The system is color-coded and very intuitive to use!',
        'images': [
          'assets/wiki/singapore/mrt_1.jpg',
          'assets/wiki/singapore/mrt_2.jpg'
        ],
        'likes': 8,
        'verified': true,
      }
    ],
    'trafficPosts': [
      {
        'title': 'Weekend Bus Schedule Changes',
        'date': '21 September 2024',
        'description':
            'Important notice: Several bus routes will have modified schedules during weekends starting October. Check the updated timings here.',
        'images': ['assets/wiki/singapore/bus_schedule.jpg'],
        'likes': 4,
        'verified': true,
      }
    ],
    'culturePosts': [
      {
        'title': 'Mid-Autumn Festival Celebrations',
        'date': '20 September 2024',
        'description':
            'Gardens by the Bay is hosting a special lantern festival. Don\'t miss the beautiful displays and traditional mooncake tasting sessions!',
        'images': [
          'assets/wiki/singapore/lantern_1.jpg',
          'assets/wiki/singapore/lantern_2.jpg'
        ],
        'likes': 7,
        'verified': true,
      }
    ]
  },
  'Malaysia': {
    'foodPosts': [
      {
        'title': 'Best Nasi Lemak in KL!',
        'date': '22 September 2024',
        'description':
            'Found this amazing nasi lemak stall in Kampung Baru. The coconut rice is perfectly cooked and the sambal is spicy but not overwhelming.',
        'images': [
          'assets/wiki/malaysia/nasi_lemak_1.jpg',
          'assets/wiki/malaysia/nasi_lemak_2.jpg'
        ],
        'likes': 5,
        'verified': true,
      }
    ],
    // Future add other categories...
  },
  // Future add other countries...
};
