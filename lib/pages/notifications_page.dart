import 'package:flutter/material.dart';
import '../services/notify.dart';
import '../theme.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  bool _orderUpdates = true;
  bool _promos = false;
  bool _newRestaurants = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification settings'),
        backgroundColor: kPrimary,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Manage your notification preferences',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ),
          SwitchListTile.adaptive(
            title: const Text('Order updates'),
            subtitle: const Text('Driver status and ETA'),
            value: _orderUpdates,
            onChanged: (v) {
              setState(() => _orderUpdates = v);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(v ? 'Order updates enabled' : 'Order updates disabled'),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
            activeColor: kPrimary,
          ),
          SwitchListTile.adaptive(
            title: const Text('Promotions'),
            subtitle: const Text('Deals and recommendations'),
            value: _promos,
            onChanged: (v) {
              setState(() => _promos = v);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(v ? 'Promotions enabled' : 'Promotions disabled'),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
            activeColor: kPrimary,
          ),
          SwitchListTile.adaptive(
            title: const Text('New restaurants'),
            subtitle: const Text('Get notified about new restaurants nearby'),
            value: _newRestaurants,
            onChanged: (v) {
              setState(() => _newRestaurants = v);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(v ? 'New restaurant alerts enabled' : 'New restaurant alerts disabled'),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
            activeColor: kPrimary,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.notifications_active, color: kPrimary),
            title: const Text('Test notification'),
            subtitle: const Text('Send a test notification'),
            trailing: const Icon(Icons.send),
            onTap: () async {
              // ✅ FIXED: Use Notify.instance.show()
              await Notify.instance.show(
                title: 'Test Notification',
                body: 'This is a test notification from Biteful!',
              );
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Test notification sent!')),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
