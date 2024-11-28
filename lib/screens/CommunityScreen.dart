// community_screen.dart
import 'package:flutter/material.dart';
import '../screens/MessageScreen.dart';
import '../screens/CommunityDetailScreen.dart';
import 'ForeignWikiScreen.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Community',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.message_outlined, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MessageScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'You can look for resolved foreigner\nissues or get advice from locals',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // ForeignWiki Search Bar with Navigation
              GestureDetector(
                onTap: () => _navigateToForeignWiki(context),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Row(
                    children: [
                      Text(
                        'Foreign Wiki',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16,
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.north_east,
                        color: Colors.grey[600],
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.search,
                        color: Colors.grey[600],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Community Header
              const Text(
                'Join The Community, Be Adapt to Foreign Cultural !!',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),

              // Grid of Community Features
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.85,
                children: [
                  _buildFeatureCard(
                    context,
                    'Social Gathering',
                    'assets/social_gathering.jpg',
                    communityData['social_gathering']!,
                  ),
                  _buildFeatureCard(
                    context,
                    'Job Searching',
                    'assets/job_searching.jpg',
                    communityData['job_searching']!,
                  ),
                  _buildFeatureCard(
                    context,
                    'Housing Searches',
                    'assets/housing_searches.jpg',
                    communityData['housing_searches']!,
                  ),
                  _buildFeatureCard(
                    context,
                    'Languages Communication',
                    'assets/languages.jpg',
                    communityData['languages_communication']!,
                  ),
                  _buildFeatureCard(
                    context,
                    'Volunteer service',
                    'assets/volunteer.jpg',
                    communityData['volunteer_service']!,
                  ),
                  _buildFeatureCard(
                    context,
                    'Parent-child Activities',
                    'assets/parent_child.jpg',
                    communityData['parent_child_activities']!,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

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

  void _navigateToForeignWiki(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ForeignWikiScreen(),
      ),
    );
  }

  Widget _buildFeatureCard(BuildContext context, String title, String imagePath,
      Map<String, dynamic> data) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CommunityDetailScreen(
              title: title,
              headerImage: imagePath,
              data: data,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        clipBehavior: Clip.hardEdge,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Dummy data for each community section
const communityData = {
  'social_gathering': {
    'subtitle': 'meet more new people and enjoy social events',
    'sections': [
      {
        'title': 'Cultural Exchange Gatherings',
        'image': 'assets/cultural_exchange.jpg',
        'details': [
          'Organize people from different cultures to share their culture, food and customs.',
          'Provide recommendations for cultural events, food and drinks.'
        ]
      },
      {
        'title': 'Movie Nights',
        'image': 'assets/movie_nights.jpg',
        'details': [
          'Film screenings at home or in a public place, combined with discussion on theme.',
          'Provides movie recommendations, viewing arrangements and snack recommendations.'
        ]
      },
      {
        'title': 'Themed Parties',
        'image': 'assets/themed_parties.jpg',
        'details': [
          'Hold themed parties such as Halloween parties, vintage parties, summer beach parties, etc.',
          'Provide theme decoration suggestions, clothing recommendations and related activity arrangements.'
        ]
      },
      {
        'title': 'Sports Events',
        'image': 'assets/sports_events.jpg',
        'details': [
          'Organize friendly games, running activities or fitness classes.',
          'Provide event schedule, participation methods and competition rules.'
        ]
      },
      {
        'title': 'Workshops',
        'image': 'assets/workshops.jpg',
        'details': [
          'Interactive learning sessions on various topics.',
          'Schedule of upcoming workshops and registration information.'
        ]
      }
    ]
  },
  'job_searching': {
    'subtitle': 'find job opportunities and career guidance',
    'sections': [
      {
        'title': 'Job Listings',
        'image': 'assets/job_listings.jpg',
        'details': [
          'Access curated job listings specifically for international professionals',
          'Filter opportunities by visa sponsorship availability and language requirements'
        ]
      },
      {
        'title': 'Career Mentorship',
        'image': 'assets/career_mentorship.jpg',
        'details': [
          'Connect with experienced professionals in your field',
          'Get guidance on career advancement and local work culture'
        ]
      },
      {
        'title': 'Resume & Interview Prep',
        'image': 'assets/resume_prep.jpg',
        'details': [
          'Get help adapting your resume to local standards and expectations',
          'Practice interviews with feedback on language and cultural aspects'
        ]
      },
      {
        'title': 'Networking Events',
        'image': 'assets/networking.jpg',
        'details': [
          'Join industry-specific meetups and professional gatherings',
          'Build connections with local professionals and companies'
        ]
      },
      {
        'title': 'Work Visa Support',
        'image': 'assets/visa_support.jpg',
        'details': [
          'Access resources and guidance for work visa applications',
          'Connect with experienced immigration consultants and professionals'
        ]
      }
    ]
  },
  'housing_searches': {
    'subtitle': 'find your perfect home away from home',
    'sections': [
      {
        'title': 'Property Listings',
        'image': 'assets/property_listings.jpg',
        'details': [
          'Browse verified rental listings with English support',
          'Filter by foreigner-friendly properties and locations'
        ]
      },
      {
        'title': 'Roommate Matching',
        'image': 'assets/roommate_matching.jpg',
        'details': [
          'Find compatible roommates with similar interests and lifestyles',
          'Connect with other expatriates or local residents'
        ]
      },
      {
        'title': 'Rental Guidance',
        'image': 'assets/rental_guidance.jpg',
        'details': [
          'Learn about local rental processes and requirements',
          'Get help with lease contracts and tenant rights'
        ]
      },
      {
        'title': 'Area Guides',
        'image': 'assets/area_guides.jpg',
        'details': [
          'Detailed information about different neighborhoods',
          'Insights on transportation, amenities, and community features'
        ]
      },
      {
        'title': 'Moving Assistance',
        'image': 'assets/moving_assistance.jpg',
        'details': [
          'Connect with reliable moving services and helpers',
          'Tips for settling into your new home and neighborhood'
        ]
      }
    ]
  },
  'languages_communication': {
    'subtitle': 'bridge the language gap and connect with locals',
    'sections': [
      {
        'title': 'Language Exchange',
        'image': 'assets/language_exchange.jpg',
        'details': [
          'Practice language skills with native speakers',
          'Exchange cultural insights while improving communication'
        ]
      },
      {
        'title': 'Conversation Groups',
        'image': 'assets/conversation_groups.jpg',
        'details': [
          'Join regular meetups focused on casual conversation practice',
          'Participate in themed discussions and cultural exchange'
        ]
      },
      {
        'title': 'Study Groups',
        'image': 'assets/study_groups.jpg',
        'details': [
          'Form or join groups preparing for language proficiency tests',
          'Share study resources and learning strategies'
        ]
      },
      {
        'title': 'Cultural Workshops',
        'image': 'assets/cultural_workshops.jpg',
        'details': [
          'Learn about local customs, etiquette, and communication styles',
          'Practice practical language skills for daily life situations'
        ]
      },
      {
        'title': 'Translation Support',
        'image': 'assets/translation_support.jpg',
        'details': [
          'Get help with important document translation',
          'Access community translation support for daily needs'
        ]
      }
    ]
  },
  'volunteer_service': {
    'subtitle': 'give back to your new community',
    'sections': [
      {
        'title': 'Community Service',
        'image': 'assets/community_service.jpg',
        'details': [
          'Participate in local community improvement projects',
          'Connect with neighbors while making a positive impact'
        ]
      },
      {
        'title': 'Environmental Projects',
        'image': 'assets/environmental_projects.jpg',
        'details': [
          'Join eco-friendly initiatives and clean-up events',
          'Contribute to local sustainability efforts'
        ]
      },
      {
        'title': 'Education Support',
        'image': 'assets/education_support.jpg',
        'details': [
          'Help with language teaching and cultural exchange programs',
          'Support after-school programs and educational initiatives'
        ]
      },
      {
        'title': 'Elderly Care',
        'image': 'assets/elderly_care.jpg',
        'details': [
          'Assist senior citizens with daily activities and companionship',
          'Participate in programs supporting the elderly community'
        ]
      },
      {
        'title': 'Crisis Response',
        'image': 'assets/crisis_response.jpg',
        'details': [
          'Support community emergency response and relief efforts',
          'Help organize and distribute resources during critical times'
        ]
      }
    ]
  },
  'parent_child_activities': {
    'subtitle': 'create memorable experiences for families',
    'sections': [
      {
        'title': 'Playgroups',
        'image': 'assets/playgroups.jpg',
        'details': [
          'Join international family meetups and playdates',
          'Connect with other expatriate and local families'
        ]
      },
      {
        'title': 'Educational Activities',
        'image': 'assets/educational_activities.jpg',
        'details': [
          'Participate in bilingual learning sessions and workshops',
          'Engage in cultural exchange activities for children'
        ]
      },
      {
        'title': 'Family Outings',
        'image': 'assets/family_outings.jpg',
        'details': [
          'Join group visits to family-friendly attractions',
          'Explore local destinations with other international families'
        ]
      },
      {
        'title': 'Creative Workshops',
        'image': 'assets/creative_workshops.jpg',
        'details': [
          'Engage in art, craft, and music activities for parents and children',
          'Develop creative skills while making new friends'
        ]
      },
      {
        'title': 'Sports & Recreation',
        'image': 'assets/sports_recreation.jpg',
        'details': [
          'Participate in family-friendly sports and outdoor activities',
          'Join group exercises and games for all ages'
        ]
      }
    ]
  }
};
