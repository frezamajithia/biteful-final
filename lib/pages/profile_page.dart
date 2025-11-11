import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme.dart';
import '../db/database_helper.dart'; // ✅ ADD THIS

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          // Profile header
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: kCardShadow,
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 36,
                  backgroundColor: kPrimary.withValues(alpha: 0.1),
                  child: const Icon(Icons.person, size: 36, color: kPrimary),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Guest User',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'guest@biteful.app',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Edit profile coming soon')),
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 26),

          // ✅ ADD THIS DEBUG BUTTON
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.red.shade200),
            ),
            child: ListTile(
              leading: const Icon(Icons.delete_forever, size: 26, color: Colors.red),
              title: const Text(
                'Reset Database (Debug)',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.red),
              ),
              subtitle: const Text(
                'Fix database errors - App will restart',
                style: TextStyle(fontSize: 12),
              ),
              trailing: const Icon(Icons.warning, color: Colors.orange),
              onTap: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Reset Database?'),
                    content: const Text('This will delete all orders and fix database errors. App will close after reset.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        style: TextButton.styleFrom(foregroundColor: Colors.red),
                        child: const Text('Reset'),
                      ),
                    ],
                  ),
                );
                
                if (confirm == true) {
                  await DatabaseHelper.instance.deleteDatabase();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Database reset! Please close and reopen the app.'),
                        duration: Duration(seconds: 3),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                }
              },
            ),
          ),
          
          // Menu items
          _tile(
            context,
            Icons.location_on_outlined,
            'Addresses',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Address management coming soon')),
              );
            },
          ),
          _tile(
            context,
            Icons.credit_card_outlined,
            'Payment Methods',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Payment methods coming soon')),
              );
            },
          ),
          _tile(
            context,
            Icons.notifications_none,
            'Notifications',
            onTap: () => context.push('/notifications'),
          ),
          _tile(
            context,
            Icons.help_outline,
            'Help & Support',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Help & Support coming soon')),
              );
            },
          ),
          _tile(
            context,
            Icons.info_outline,
            'About',
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'Biteful',
                applicationVersion: '1.0.0',
                applicationIcon: const Icon(Icons.restaurant, size: 48, color: kPrimary),
                children: const [
                  Text('Your favorite food delivery app'),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _tile(BuildContext context, IconData icon, String label, {VoidCallback? onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, size: 26, color: kPrimary),
        title: Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}
