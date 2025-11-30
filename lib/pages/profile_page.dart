import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme.dart';
import '../db/database_helper.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _userName = 'Loading...';
  String _userEmail = 'Loading...';

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final userData = await DatabaseHelper.instance.fetchUser();
    if (userData != null && mounted) {
      setState(() {
        _userName = userData['name'] as String;
        _userEmail = userData['email'] as String;
      });
    }
  }

  void _showEditProfileDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => _EditProfileDialog(
        initialName: _userName,
        initialEmail: _userEmail,
        onSave: (newName, newEmail) async {
          // 1. Save to Database
          await DatabaseHelper.instance.updateUser(newName, newEmail);
          
          // 2. Update local state and UI
          setState(() {
            _userName = newName;
            _userEmail = newEmail;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Profile updated to $newName')),
          );
        },
      ),
    );
  }

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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _userName, 
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _userEmail, 
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _showEditProfileDialog(context), 
                ),
              ],
            ),
          ),

          const SizedBox(height: 26),

          // Reset Database Button
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
            onTap: () => context.push('/addresses'),
          ),
          _tile(
            context,
            Icons.credit_card_outlined,
            'Payment Methods',
            onTap: () => context.push('/payment-methods'),
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
            onTap: () => context.push('/help-support'),
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

class _EditProfileDialog extends StatefulWidget {
  final String initialName;
  final String initialEmail;
  final Function(String newName, String newEmail) onSave;

  const _EditProfileDialog({
    required this.initialName,
    required this.initialEmail,
    required this.onSave,
  });

  @override
  State<_EditProfileDialog> createState() => __EditProfileDialogState();
}

class __EditProfileDialogState extends State<_EditProfileDialog> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _emailController = TextEditingController(text: widget.initialEmail);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      widget.onSave(_nameController.text, _emailController.text);
      Navigator.of(context).pop(); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Profile'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  // Simple email validation
                  if (!value.contains('@') || !value.contains('.')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton(
          onPressed: _saveProfile,
          child: const Text('Save'),
        ),
      ],
    );
  }
}