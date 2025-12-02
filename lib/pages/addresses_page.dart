import 'package:flutter/material.dart';
import '../theme.dart';

class Address {
  String title;
  String street;
  String city;
  bool isDefault;

  Address({required this.title, required this.street, required this.city, this.isDefault = false});
}

class AddressesPage extends StatefulWidget {
  const AddressesPage({super.key});

  @override
  State<AddressesPage> createState() => _AddressesPageState();
}

class _AddressesPageState extends State<AddressesPage> {
  final List<Address> _addresses = [
    Address(title: 'Home', street: '123 Maple Street', city: 'Toronto, ON', isDefault: true),
    Address(title: 'Work', street: '456 King Street West', city: 'Toronto, ON'),
  ];

  void _showAddressDialog({Address? address, int? index}) {
    final isEditing = address != null;
    final titleController = TextEditingController(text: address?.title ?? '');
    final streetController = TextEditingController(text: address?.street ?? '');
    final cityController = TextEditingController(text: address?.city ?? '');
    bool isDefault = address?.isDefault ?? false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(isEditing ? 'Edit Address' : 'Add Address'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: 'Label (e.g., Home, Work)',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    prefixIcon: const Icon(Icons.label_outline),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: streetController,
                  decoration: InputDecoration(
                    labelText: 'Street Address',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    prefixIcon: const Icon(Icons.home_outlined),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: cityController,
                  decoration: InputDecoration(
                    labelText: 'City, Province',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    prefixIcon: const Icon(Icons.location_city),
                  ),
                ),
                const SizedBox(height: 16),
                CheckboxListTile(
                  value: isDefault,
                  onChanged: (v) => setDialogState(() => isDefault = v ?? false),
                  title: const Text('Set as default address'),
                  activeColor: kPrimary,
                  contentPadding: EdgeInsets.zero,
                ),
              ],
            ),
          ),
          actions: [
            if (isEditing)
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _deleteAddress(index!);
                },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Delete'),
              ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isEmpty || streetController.text.isEmpty || cityController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill in all fields')),
                  );
                  return;
                }

                Navigator.pop(context);

                if (isEditing) {
                  _updateAddress(index!, titleController.text, streetController.text, cityController.text, isDefault);
                } else {
                  _addAddress(titleController.text, streetController.text, cityController.text, isDefault);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimary,
                foregroundColor: Colors.white,
              ),
              child: Text(isEditing ? 'Save' : 'Add'),
            ),
          ],
        ),
      ),
    );
  }

  void _addAddress(String title, String street, String city, bool isDefault) {
    setState(() {
      if (isDefault) {
        for (var addr in _addresses) {
          addr.isDefault = false;
        }
      }
      _addresses.add(Address(title: title, street: street, city: city, isDefault: isDefault));
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$title address added'), backgroundColor: kPrimary),
    );
  }

  void _updateAddress(int index, String title, String street, String city, bool isDefault) {
    setState(() {
      if (isDefault) {
        for (var addr in _addresses) {
          addr.isDefault = false;
        }
      }
      _addresses[index] = Address(title: title, street: street, city: city, isDefault: isDefault);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$title address updated'), backgroundColor: kPrimary),
    );
  }

  void _deleteAddress(int index) {
    final address = _addresses[index];
    setState(() {
      _addresses.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${address.title} address deleted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _addresses.insert(index, address);
            });
          },
        ),
      ),
    );
  }

  void _setAsDefault(int index) {
    setState(() {
      for (int i = 0; i < _addresses.length; i++) {
        _addresses[i].isDefault = (i == index);
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${_addresses[index].title} set as default'), backgroundColor: kPrimary),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        title: const Text('My Addresses'),
        backgroundColor: kPrimary,
        foregroundColor: Colors.white,
      ),
      body: _addresses.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.location_off, size: 64, color: Colors.grey.shade300),
                  const SizedBox(height: 16),
                  Text(
                    'No addresses saved',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap + to add your first address',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _addresses.length,
              itemBuilder: (context, index) {
                final address = _addresses[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: kCardShadow,
                    border: address.isDefault ? Border.all(color: kPrimary, width: 2) : null,
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: address.isDefault ? kPrimary.withValues(alpha: 0.1) : Colors.grey.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        address.title.toLowerCase() == 'home' ? Icons.home :
                        address.title.toLowerCase() == 'work' ? Icons.work : Icons.location_on,
                        color: address.isDefault ? kPrimary : Colors.grey.shade600,
                      ),
                    ),
                    title: Row(
                      children: [
                        Text(
                          address.title,
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                        ),
                        if (address.isDefault) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: kPrimary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'Default',
                              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: kPrimary),
                            ),
                          ),
                        ],
                      ],
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        '${address.street}\n${address.city}',
                        style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                      ),
                    ),
                    trailing: PopupMenuButton(
                      icon: const Icon(Icons.more_vert),
                      itemBuilder: (context) => [
                        const PopupMenuItem(value: 'edit', child: Text('Edit')),
                        if (!address.isDefault)
                          const PopupMenuItem(value: 'default', child: Text('Set as default')),
                        const PopupMenuItem(value: 'delete', child: Text('Delete', style: TextStyle(color: Colors.red))),
                      ],
                      onSelected: (value) {
                        if (value == 'edit') {
                          _showAddressDialog(address: address, index: index);
                        } else if (value == 'default') {
                          _setAsDefault(index);
                        } else if (value == 'delete') {
                          _deleteAddress(index);
                        }
                      },
                    ),
                    onTap: () => _showAddressDialog(address: address, index: index),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddressDialog(),
        backgroundColor: kPrimary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
