import 'package:flutter/material.dart';
import 'booking_screen.dart';
import 'home_screen.dart';
import 'profile_screen.dart';
import 'services_screen.dart';
import 'support_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    BookingScreen(),
    ServicesScreen(),
    SupportScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: _screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        height: 80,
        selectedIndex: _currentIndex,
        indicatorColor: const Color(0xFFDBEAFE),
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
          NavigationDestination(
              icon: Icon(Icons.calendar_today_outlined), label: 'Booking'),
          NavigationDestination(icon: Icon(Icons.layers_outlined), label: 'Services'),
          NavigationDestination(icon: Icon(Icons.headset_mic_outlined), label: 'Support'),
          NavigationDestination(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }
}
