import 'package:flutter/material.dart';

class BookingScreen extends StatelessWidget {
  const BookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Booking')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _ticketCard('Kabul', 'Mazar-i-Sharif', 'May 8, 2026', '6:00 AM', 'AFN 1,200'),
          const SizedBox(height: 12),
          _ticketCard('Kabul', 'Herat', 'May 12, 2026', '8:30 AM', 'AFN 2,500'),
          const SizedBox(height: 12),
          _ticketCard('Kabul', 'Kandahar', 'May 15, 2026', '7:45 AM', 'AFN 1,600'),
        ],
      ),
    );
  }

  Widget _ticketCard(String from, String to, String date, String time, String fare) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(date, style: const TextStyle(color: Colors.grey)),
              Text(time, style: const TextStyle(color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(from, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              const Icon(Icons.arrow_forward, color: Colors.blue),
              Text(to, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Bus • 2 Passengers', style: TextStyle(color: Colors.grey)),
              Text(fare,
                  style: const TextStyle(
                      color: Color(0xFF2563EB), fontWeight: FontWeight.w700, fontSize: 16)),
            ],
          ),
        ],
      ),
    );
  }
}
