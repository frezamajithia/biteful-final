import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../theme.dart';
import '../db/database_helper.dart';
import '../providers/favorites_provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _userName = 'Loading...';
  String _userEmail = 'Loading...';
  bool _darkMode = false;
  bool _locationServices = true;
  String _selectedLanguage = 'English';

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
          
          // Favorites section
          Consumer<FavoritesProvider>(
            builder: (context, favorites, _) {
              final count = favorites.favoriteIds.length;
              return _tile(
                context,
                Icons.favorite_outline,
                'My Favorites',
                trailing: count > 0
                    ? Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '$count',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.red.shade400,
                          ),
                        ),
                      )
                    : null,
                onTap: () => _showFavoritesSheet(context),
              );
            },
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

          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 8),
            child: Text(
              'Preferences',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
              ),
            ),
          ),

          // Dark Mode Toggle
          Container(
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
            child: SwitchListTile(
              secondary: const Icon(Icons.dark_mode_outlined, size: 26, color: kPrimary),
              title: const Text(
                'Dark Mode',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              subtitle: const Text('Coming soon', style: TextStyle(fontSize: 12)),
              value: _darkMode,
              activeTrackColor: kPrimary.withValues(alpha: 0.5),
              onChanged: (value) {
                setState(() => _darkMode = value);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Dark mode coming soon!'),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
            ),
          ),

          // Location Services Toggle
          Container(
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
            child: SwitchListTile(
              secondary: const Icon(Icons.location_on_outlined, size: 26, color: kPrimary),
              title: const Text(
                'Location Services',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              subtitle: const Text('For nearby restaurants', style: TextStyle(fontSize: 12)),
              value: _locationServices,
              activeTrackColor: kPrimary.withValues(alpha: 0.5),
              onChanged: (value) {
                setState(() => _locationServices = value);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(value ? 'Location enabled' : 'Location disabled'),
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
            ),
          ),

          // Language Selection
          _tile(
            context,
            Icons.language,
            'Language',
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: kPrimary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _selectedLanguage,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: kPrimary,
                ),
              ),
            ),
            onTap: () => _showLanguageDialog(),
          ),

          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 8),
            child: Text(
              'Support',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
              ),
            ),
          ),

          _tile(
            context,
            Icons.help_outline,
            'Help & Support',
            onTap: () => context.push('/help-support'),
          ),
          _tile(
            context,
            Icons.privacy_tip_outlined,
            'Privacy Policy',
            onTap: () => _showPolicyDialog('Privacy Policy'),
          ),
          _tile(
            context,
            Icons.description_outlined,
            'Terms of Service',
            onTap: () => _showPolicyDialog('Terms of Service'),
          ),
          _tile(
            context,
            Icons.star_outline,
            'Rate App',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Thanks for your support!'),
                  backgroundColor: kPrimary,
                ),
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

          const SizedBox(height: 16),

          // Logout button
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: ListTile(
              leading: Icon(Icons.logout, size: 26, color: Colors.grey.shade600),
              title: Text(
                'Log Out',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade600,
                ),
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Log Out?'),
                    content: const Text('Are you sure you want to log out?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Logged out successfully')),
                          );
                        },
                        style: TextButton.styleFrom(foregroundColor: Colors.red),
                        child: const Text('Log Out'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // App version
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: Text(
                'Biteful v1.0.0',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _languageOption('English'),
            _languageOption('Spanish'),
            _languageOption('French'),
            _languageOption('German'),
            _languageOption('Chinese'),
          ],
        ),
      ),
    );
  }

  Widget _languageOption(String language) {
    final isSelected = _selectedLanguage == language;
    return ListTile(
      title: Text(language),
      trailing: isSelected ? const Icon(Icons.check, color: kPrimary) : null,
      onTap: () {
        setState(() => _selectedLanguage = language);
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Language set to $language'),
            duration: const Duration(seconds: 1),
          ),
        );
      },
    );
  }

  void _showPolicyDialog(String title) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title == 'Privacy Policy'
                    ? 'Your privacy is important to us.\n\n'
                        '1. Data Collection: We collect information you provide directly, such as your name, email, and delivery address.\n\n'
                        '2. Usage: Your data is used solely to provide and improve our food delivery services.\n\n'
                        '3. Security: We implement industry-standard security measures to protect your information.\n\n'
                        '4. Third Parties: We do not sell your personal information to third parties.\n\n'
                        '5. Contact: For questions about this policy, contact support@biteful.com'
                    : 'Terms of Service\n\n'
                        '1. Acceptance: By using Biteful, you agree to these terms.\n\n'
                        '2. Service: Biteful provides a platform connecting users with local restaurants for food delivery.\n\n'
                        '3. Orders: All orders are subject to restaurant availability and delivery zones.\n\n'
                        '4. Payments: Payment is required at the time of order. Refunds are handled on a case-by-case basis.\n\n'
                        '5. User Conduct: Users must provide accurate information and use the service responsibly.\n\n'
                        '6. Changes: We reserve the right to modify these terms at any time.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showFavoritesSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        expand: false,
        builder: (_, scrollController) => Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'My Favorites',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
            ),
            Expanded(
              child: Consumer<FavoritesProvider>(
                builder: (context, favorites, _) {
                  return FutureBuilder<List<Map<String, dynamic>>>(
                    future: favorites.getFavorites(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.favorite_border, size: 64, color: Colors.grey.shade300),
                              const SizedBox(height: 16),
                              Text(
                                'No favorites yet',
                                style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Tap the heart on restaurants to save them',
                                style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                              ),
                            ],
                          ),
                        );
                      }
                      return ListView.builder(
                        controller: scrollController,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final fav = snapshot.data![index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: kCardShadow,
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              leading: CircleAvatar(
                                backgroundColor: kPrimary.withValues(alpha: 0.1),
                                child: const Icon(Icons.restaurant, color: kPrimary),
                              ),
                              title: Text(
                                fav['name'] as String,
                                style: const TextStyle(fontWeight: FontWeight.w600),
                              ),
                              subtitle: Row(
                                children: [
                                  const Icon(Icons.star, size: 14, color: kStar),
                                  const SizedBox(width: 4),
                                  Text('${(fav['rating'] as num).toStringAsFixed(1)}'),
                                ],
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.favorite, color: Colors.red),
                                onPressed: () {
                                  favorites.toggleFavorite(
                                    id: fav['id'] as String,
                                    name: fav['name'] as String,
                                  );
                                },
                              ),
                              onTap: () {
                                Navigator.pop(ctx);
                                context.push('/restaurant/${fav['id']}');
                              },
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tile(BuildContext context, IconData icon, String label, {VoidCallback? onTap, Widget? trailing}) {
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
        trailing: trailing ?? const Icon(Icons.chevron_right, color: Colors.grey),
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