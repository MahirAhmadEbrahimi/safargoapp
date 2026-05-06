import 'package:flutter/material.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Support')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _supportTile(Icons.call, 'Call Center', '+93 778 511 935'),
          _supportTile(Icons.chat_bubble_outline, 'Live Chat', 'Average reply: 2 min'),
          _supportTile(Icons.help_outline, 'Help Center', 'Booking, payments and safety FAQs'),
          _supportTile(Icons.report_gmailerrorred, 'Report an Issue', 'Submit complaints or trip issues'),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Emergency Contacts',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                SizedBox(height: 6),
                Text('Police: 119'),
                Text('Ambulance: 102'),
                Text('Road Rescue: +93 700 111 222'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _supportTile(IconData icon, String title, String subtitle) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFDBEAFE),
          child: Icon(icon, color: const Color(0xFF2563EB)),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
