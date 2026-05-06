import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(tr.t('support'))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _supportTile(Icons.call, tr.t('supportCenter'), '+93 778 511 935'),
          _supportTile(Icons.chat_bubble_outline, tr.t('liveChat'), 'Average reply: 2 min'),
          _supportTile(Icons.help_outline, tr.t('helpCenter'), 'Booking, payments and safety FAQs'),
          _supportTile(Icons.report_gmailerrorred, tr.t('reportIssue'), 'Submit complaints or trip issues'),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(tr.t('emergencyContacts'),
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
