import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
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
    final tr = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: _screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        height: 80,
        selectedIndex: _currentIndex,
        indicatorColor: const Color(0xFFDBEAFE),
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        destinations: [
          NavigationDestination(icon: const Icon(Icons.home_outlined), label: tr.t('home')),
          NavigationDestination(
              icon: const Icon(Icons.calendar_today_outlined), label: tr.t('booking')),
          NavigationDestination(icon: const Icon(Icons.layers_outlined), label: tr.t('services')),
          NavigationDestination(icon: const Icon(Icons.headset_mic_outlined), label: tr.t('support')),
          NavigationDestination(icon: const Icon(Icons.person_outline), label: tr.t('profile')),
        ],
      ),
    );
  }
}
