import 'package:flutter/material.dart';

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // FAQs Section
          Text('Frequently Asked Questions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryColor)),
          const Divider(thickness: 2),
          _supportTile(
            context,
            Icons.question_answer_outlined,
            'How do I track my order?',
            'Order tracking details and estimated arrival time can be found on the "Orders" page.',
          ),
          _supportTile(
            context,
            Icons.monetization_on_outlined,
            'Payment Issues',
            'If your payment failed, please verify your card details or try a different payment method.',
          ),
          
          const SizedBox(height: 24),

          // Contact Section
          Text('Need more help?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryColor)),
          const Divider(thickness: 2),
          _contactTile(
            context,
            Icons.email_outlined,
            'Contact Support',
            'support@biteful.app',
          ),
          _contactTile(
            context,
            Icons.phone_outlined,
            'Call Hotline',
            '+1 (800) 555-FOOD',
          ),
        ],
      ),
    );
  }

  Widget _supportTile(BuildContext context, IconData icon, String title, String subtitle) {
    return ExpansionTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 72.0, right: 16.0, bottom: 8.0),
          child: Text(subtitle, style: const TextStyle(color: Colors.grey)),
        ),
      ],
    );
  }
  
  Widget _contactTile(BuildContext context, IconData icon, String title, String subtitle) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.open_in_new),
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Launching action for $title')),
        );
      },
    );
  }
}