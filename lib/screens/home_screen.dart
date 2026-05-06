import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopBar(),
              const SizedBox(height: 18),
              const Text(
                'Good morning,',
                style: TextStyle(fontSize: 22, color: Color(0xFF4B5563)),
              ),
              const Text(
                'Where are you heading?',
                style: TextStyle(fontSize: 38, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 20),
              _quickBookingCard(),
              const SizedBox(height: 18),
              _upcomingTripCard(),
              const SizedBox(height: 22),
              _sectionTitle('Popular Destinations', actionText: 'See all'),
              const SizedBox(height: 12),
              _popularDestinations(),
              const SizedBox(height: 20),
              _sectionTitle('Transport Type'),
              const SizedBox(height: 12),
              _transportTypes(),
              const SizedBox(height: 20),
              const Text(
                'AI Recommendation',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              _recommendationCard(),
              const SizedBox(height: 14),
              _promoCard(),
              const SizedBox(height: 20),
              _sectionTitle('Recent Trips', actionText: 'View all'),
              const SizedBox(height: 12),
              _recentTrip('Kabul', 'Jalalabad', 'Apr 28', 'AFN 800'),
              const SizedBox(height: 10),
              _recentTrip('Kabul', 'Mazar-i-Sharif', 'Apr 15', 'AFN 1,200'),
              const SizedBox(height: 10),
              _recentTrip('Kabul', 'Parwan', 'Apr 5', 'AFN 500'),
              const SizedBox(height: 20),
              const Text(
                'Safety Tips',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              _safetyTip(Icons.verified_user_outlined, 'Verify Your Driver',
                  'Always check driver ID and vehicle plate number',
                  const Color(0xFF3B82F6)),
              _safetyTip(Icons.warning_amber_rounded, 'Share Trip Details',
                  'Share your trip with family for safety',
                  const Color(0xFFF59E0B)),
              _safetyTip(Icons.call_outlined, 'Emergency Contacts',
                  'Keep emergency numbers saved and accessible',
                  const Color(0xFFEF4444)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Row(
      children: [
        Container(
          width: 54,
          height: 54,
          decoration: BoxDecoration(
            color: const Color(0xFF3B82F6),
            borderRadius: BorderRadius.circular(18),
          ),
          alignment: Alignment.center,
          child: const Text(
            'AT',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
          ),
        ),
        const SizedBox(width: 12),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('AI Transport',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 24)),
            Row(
              children: [
                Icon(Icons.location_on_outlined, size: 15, color: Colors.grey),
                SizedBox(width: 2),
                Text('Kabul',
                    style: TextStyle(color: Colors.grey, fontSize: 16)),
                Icon(Icons.keyboard_arrow_down, color: Colors.grey),
              ],
            ),
          ],
        ),
        const Spacer(),
        Badge(
          backgroundColor: Colors.red,
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.notifications_none, size: 30),
          ),
        ),
      ],
    );
  }

  Widget _quickBookingCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Quick Booking',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          _bookingTile(Icons.my_location, 'FROM', 'Kabul'),
          const SizedBox(height: 8),
          _bookingTile(Icons.send_outlined, 'TO', 'Select destination',
              trailing: Container(
                width: 52,
                height: 52,
                decoration: const BoxDecoration(
                  color: Color(0xFF3B82F6),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.swap_vert, color: Colors.white, size: 32),
              )),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3B82F6),
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(58),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              child: const Text('Search Routes',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bookingTile(IconData icon, String label, String value,
      {Widget? trailing}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFFE5EDF9),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: const Color(0xFF3B82F6), size: 28),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(fontSize: 14, color: Colors.grey)),
                Text(value,
                    style: const TextStyle(
                        fontSize: 33, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          if (trailing != null) trailing,
        ],
      ),
    );
  }

  Widget _upcomingTripCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF3B82F6), Color(0xFF0EA5E9)],
        ),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.calendar_today, color: Colors.white, size: 16),
              SizedBox(width: 8),
              Text('May 8, 2026',
                  style: TextStyle(color: Colors.white, fontSize: 16)),
              SizedBox(width: 8),
              Text('•', style: TextStyle(color: Colors.white)),
              SizedBox(width: 8),
              Icon(Icons.schedule, color: Colors.white, size: 16),
              SizedBox(width: 6),
              Text('6:00 AM',
                  style: TextStyle(color: Colors.white, fontSize: 16)),
            ],
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('FROM\nKabul',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w700)),
              Icon(Icons.arrow_forward, color: Colors.white, size: 22),
              Text('TO\nMazar-i-Sharif',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w700)),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Bus • 2 Passengers',
                  style: TextStyle(color: Colors.white, fontSize: 16)),
              Text('AFN 1,200',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title, {String? actionText}) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
          ),
        ),
        if (actionText != null)
          Text(actionText,
              style: const TextStyle(
                  color: Color(0xFF3B82F6),
                  fontWeight: FontWeight.w600,
                  fontSize: 20)),
      ],
    );
  }

  Widget _popularDestinations() {
    return SizedBox(
      height: 168,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _destinationCard('Mazar-i-Sharif', '4.8', const Color(0xFFBEE3F8)),
          _destinationCard('Herat', '4.7', const Color(0xFFD1D5DB)),
          _destinationCard('Kandahar', '4.5', const Color(0xFFFDE68A)),
        ],
      ),
    );
  }

  Widget _destinationCard(String name, String rating, Color bg) {
    return Container(
      width: 170,
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.92),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text('⭐ $rating',
                  style: const TextStyle(fontWeight: FontWeight.w600)),
            ),
          ),
          Positioned(
            left: 10,
            bottom: 10,
            child: Text(name,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  Widget _transportTypes() {
    return Row(
      children: [
        Expanded(child: _transportCard(Icons.directions_bus, 'Bus', 'Economy')),
        const SizedBox(width: 10),
        Expanded(child: _transportCard(Icons.local_shipping, 'Van', 'Comfort')),
        const SizedBox(width: 10),
        Expanded(
            child: _transportCard(Icons.directions_car, 'Private Car', 'Premium')),
      ],
    );
  }

  Widget _transportCard(IconData icon, String title, String sub) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: const Color(0xFF3B82F6)),
          ),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
          Text(sub, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _recommendationCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFCBD5E1)),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _Tag(label: 'Best Value', color: Color(0xFFE0E7FF)),
              SizedBox(width: 8),
              _Tag(label: 'Safest Route', color: Color(0xFFDCFCE7)),
            ],
          ),
          SizedBox(height: 10),
          Text('Kabul \u2192 Herat via Bamyan',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
          SizedBox(height: 4),
          Text('Scenic mountain route with verified drivers and rest stops.'),
          SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.schedule, size: 16, color: Colors.grey),
              SizedBox(width: 4),
              Text('14h', style: TextStyle(color: Colors.grey)),
              SizedBox(width: 14),
              Icon(Icons.shield_outlined, size: 16, color: Colors.grey),
              SizedBox(width: 4),
              Text('Verified', style: TextStyle(color: Colors.grey)),
              Spacer(),
              Text('AFN 2,500',
                  style: TextStyle(
                      color: Color(0xFF2563EB), fontWeight: FontWeight.w700)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _promoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF3C7),
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Row(
        children: [
          CircleAvatar(
            backgroundColor: Color(0xFFFCD34D),
            child: Icon(Icons.card_giftcard, color: Color(0xFFD97706)),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('20% Off First Trip!',
                    style:
                        TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                Text('Book your first intercity ride and save. Use code: FIRST20'),
              ],
            ),
          ),
          Icon(Icons.arrow_forward, color: Color(0xFFD97706)),
        ],
      ),
    );
  }

  Widget _recentTrip(String from, String to, String date, String price) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: Color(0xFFDCFCE7),
            child: Icon(Icons.check_circle_outline, color: Color(0xFF16A34A)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$from \u2192 $to',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w700)),
                Text(date, style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          Text(price,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
        ],
      ),
    );
  }

  Widget _safetyTip(
      IconData icon, String title, String subtitle, Color iconColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: iconColor.withValues(alpha: 0.14),
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 16)),
                Text(subtitle, style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String label;
  final Color color;

  const _Tag({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(30)),
      child: Text(label,
          style: const TextStyle(
              color: Color(0xFF4B5563), fontWeight: FontWeight.w600, fontSize: 12)),
    );
  }
}
