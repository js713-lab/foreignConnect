import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/DestinationScreen.dart';
import 'screens/LoginScreen.dart';
import 'screens/SignUpScreen.dart';
import 'screens/PurposeScreen.dart';
import 'screens/ForgotPasswordScreen.dart';
import 'screens/ProfileScreen.dart';
import 'screens/TourDetailScreen.dart';
import 'screens/CommunityScreen.dart';
import 'services/auth_state.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'firebase_options.dart';
import 'screens/ConsultantDetailScreen.dart';
import 'screens/CartScreen.dart';
import 'providers/cart_provider.dart';
import 'screens/copyright/privacyPolicyScreen.dart';
import 'screens/copyright/termOfServiceScreen.dart';
import 'providers/contacts_provider.dart';
import 'screens/TimeSelectionScreen.dart';
import 'screens/ConsultMessageScreen.dart';
import 'screens/ItineraryDetailScreen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class AppConstants {
  static const String apiKey = "AIzaSyC0b0qQEKUosWWP3UyKkeiqhbUNRJbKQOI";
  static const String authDomain = "foreignconnect-76d91.firebaseapp.com";
  static const String projectId = "foreignconnect-76d91";
  static const String storageBucket =
      "foreignconnect-76d91.firebasestorage.app";
  static const String messagingSenderId = "260778926337";
  static const String appId = "1:260778926337:web:5ef4edc2447bcc03adfb00";
  static const String measurementId = "G-QT318V5RG3";

  static const Color primaryColor = Color(0xFFCE7D66);
  static const Color scaffoldBackgroundColor = Colors.white;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: kIsWeb
        ? const FirebaseOptions(
            apiKey: AppConstants.apiKey,
            appId: AppConstants.appId,
            messagingSenderId: AppConstants.messagingSenderId,
            projectId: AppConstants.projectId,
          )
        : DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthStateProvider()),
        ChangeNotifierProvider(create: (_) => ContactsProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const WelcomeScreen());
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case '/signup':
        return MaterialPageRoute(builder: (_) => const SignUpScreen());
      case '/forgot-password':
        return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());
      case '/purpose':
        return MaterialPageRoute(builder: (_) => const PurposeScreen());
      case '/destination':
        return MaterialPageRoute(
            builder: (_) => const DestinationScreen(userName: ''));
      case '/profile':
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case '/consultant-detail':
        try {
          final Map<String, dynamic>? args =
              settings.arguments as Map<String, dynamic>?;
          if (args == null) {
            return MaterialPageRoute(
              builder: (_) => Scaffold(
                body: Center(child: Text('Missing consultant data')),
              ),
            );
          }
          return MaterialPageRoute(
            builder: (_) => ConsultantDetailScreen(consultant: args),
          );
        } catch (e) {
          return MaterialPageRoute(
            builder: (_) => Scaffold(
              body: Center(child: Text('Invalid consultant data')),
            ),
          );
        }
      case '/consult-message':
        final Map<String, dynamic> args =
            settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => ConsultMessageScreen(
            consultant: args['consultant'],
            itinerary: args['itinerary'],
          ),
        );
      case '/time-selection':
        if (settings.arguments is Map<String, dynamic>) {
          final consultant = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (_) => TimeSelectionScreen(consultant: consultant),
          );
        }
        return _errorRoute('Invalid consultant data');

      case '/cart':
        if (settings.arguments != null &&
            settings.arguments is! List<Map<String, dynamic>>) {
          return _errorRoute('Invalid cart data');
        }
        final cartItems =
            settings.arguments as List<Map<String, dynamic>>? ?? [];
        return MaterialPageRoute(
          builder: (_) => CartScreen(),
        );
      case '/privacy-policy':
        return MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen());
      case '/terms-of-service':
        return MaterialPageRoute(builder: (_) => const TermsOfServiceScreen());
      case '/itinerary-detail':
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => ItineraryDetailScreen(
            destination: args?['destination'] ?? '',
            days: args?['days'] ?? 3,
            nights: args?['nights'] ?? 2,
            purpose: args?['purpose'] ?? 'Travel',
          ),
        );
      default:
        return _errorRoute('Route not found');
    }
  }

  static Route<dynamic> _errorRoute(String message) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: Center(
          child: Text(message),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Foreign Connect',
      theme: ThemeData(
        primaryColor: AppConstants.primaryColor,
        scaffoldBackgroundColor: AppConstants.scaffoldBackgroundColor,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppConstants.primaryColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            minimumSize: const Size(double.infinity, 48),
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      onGenerateRoute: RouteGenerator.generateRoute,
      home: const WelcomeScreen(),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  void _navigateToIntroSplash(BuildContext context) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => const IntroSplashScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Image.asset(
                'assets/logo.png',
                width: 150,
                height: 150,
              ),
              const SizedBox(height: 40),
              const Text(
                'Welcome',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E1E1E),
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/login').then((success) {
                    if (success == true) {
                      _navigateToIntroSplash(context);
                    }
                  });
                },
                child: const Text('Log In'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/signup').then((success) {
                    if (success == true) {
                      _navigateToIntroSplash(context);
                    }
                  });
                },
                child: const Text('Sign Up'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  await context.read<AuthStateProvider>().setGuestMode(true);
                  if (context.mounted) {
                    _navigateToIntroSplash(context);
                  }
                },
                child: const Text('Continue As Guest'),
              ),
              const SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'By continuing, you agree to our ',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    GestureDetector(
                      onTap: () =>
                          Navigator.pushNamed(context, '/terms-of-service'),
                      child: Text(
                        'terms of service',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    Text(
                      ' & ',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    GestureDetector(
                      onTap: () =>
                          Navigator.pushNamed(context, '/privacy-policy'),
                      child: Text(
                        'privacy policy',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class IntroSplashScreen extends StatefulWidget {
  const IntroSplashScreen({super.key});

  @override
  State<IntroSplashScreen> createState() => _IntroSplashScreenState();
}

class _IntroSplashScreenState extends State<IntroSplashScreen> {
  int _currentPage = 0;
  String _firstName = '';

  final List<Map<String, dynamic>> _splashData = [
    {
      'image': 'assets/colosseum.jpg',
      'title': 'Explore Like Local ! Get To Know Unfamiliar Places Quickly !!',
      'subtitle': 'The Best Foreign Buddy When You are in Foreign Country !!'
    },
    {
      'image': 'assets/santorini.jpg',
      'title': 'What is your firstname?',
      'isInput': true
    }
  ];

  void _navigateNext() {
    if (_currentPage == 0) {
      setState(() => _currentPage = 1);
    } else if (_firstName.isNotEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MainNavigator(userName: _firstName),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF3E5),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                _splashData[_currentPage]['image'],
                height: 300,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 40),
              Text(
                _splashData[_currentPage]['title'],
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E1E1E),
                ),
                textAlign: TextAlign.center,
              ),
              if (_splashData[_currentPage]['subtitle'] != null) ...[
                const SizedBox(height: 16),
                Text(
                  _splashData[_currentPage]['subtitle'],
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: 40),
              if (_splashData[_currentPage]['isInput'] == true)
                TextField(
                  onChanged: (value) => _firstName = value,
                  decoration: InputDecoration(
                    hintText: 'Enter your name',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _navigateNext,
                child: Text(
                  _currentPage == 0 ? "Let's Continue" : "Start Exploring",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MainNavigator extends StatefulWidget {
  final String userName;
  const MainNavigator({super.key, required this.userName});

  @override
  State<MainNavigator> createState() => _MainNavigatorState();
}

class _MainNavigatorState extends State<MainNavigator> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      DestinationScreen(userName: widget.userName),
      const TourDetailScreen(),
      const CommunityScreen(),
      const ProfileScreen(),
    ];
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.jumpToPage(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Colors.grey[200]!,
              width: 1,
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFFCE7D66),
          unselectedItemColor: Colors.grey,
          backgroundColor: Colors.white,
          elevation: 0,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                _selectedIndex == 0 ? Icons.home : Icons.home_outlined,
                size: 24,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                _selectedIndex == 1
                    ? Icons.business_center
                    : Icons.business_center_outlined,
                size: 24,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                _selectedIndex == 2 ? Icons.language : Icons.language_outlined,
                size: 24,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                _selectedIndex == 3 ? Icons.person : Icons.person_outline,
                size: 24,
              ),
              label: '',
            ),
          ],
        ),
      ),
    );
  }
}
