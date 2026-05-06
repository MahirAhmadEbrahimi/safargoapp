import 'package:flutter/material.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final services = [
      {'icon': Icons.directions_bus, 'title': 'Intercity Rides', 'desc': 'Book safe bus rides between cities'},
      {'icon': Icons.directions_car, 'title': 'Private Cars', 'desc': 'Comfort rides with trained drivers'},
      {'icon': Icons.local_shipping, 'title': 'Van Comfort', 'desc': 'Affordable and family-friendly travel'},
      {'icon': Icons.security, 'title': 'Verified Drivers', 'desc': 'All drivers are identity verified'},
      {'icon': Icons.payments_outlined, 'title': 'Secure Payments', 'desc': 'Pay online or cash on pickup'},
      {'icon': Icons.support_agent, 'title': '24/7 Help', 'desc': 'Instant support before and during trip'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Services')),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: services.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.92,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        itemBuilder: (context, index) {
          final item = services[index];
          return Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: const Color(0xFFDBEAFE),
                  child: Icon(item['icon'] as IconData, color: const Color(0xFF2563EB)),
                ),
                const SizedBox(height: 10),
                Text(item['title'] as String,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                Text(item['desc'] as String,
                    style: const TextStyle(color: Colors.grey, fontSize: 13)),
              ],
            ),
          );
        },
      ),
    );
  }
}
