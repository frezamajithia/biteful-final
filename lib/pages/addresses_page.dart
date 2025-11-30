import 'package:flutter/material.dart';

class Address {
  final String title;
  final String street;
  final String city;
  final bool isDefault;

  Address({required this.title, required this.street, required this.city, this.isDefault = false});
}

final List<Address> mockAddresses = [
  Address(title: 'Home', street: '123 Maple Street', city: 'Toronto, ON', isDefault: true),
  Address(title: 'Work', street: '456 King Street West', city: 'Toronto, ON'),
];

class AddressesPage extends StatelessWidget {
  const AddressesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Addresses'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: mockAddresses.length,
        itemBuilder: (context, index) {
          final address = mockAddresses[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 10),
            child: ListTile(
              leading: Icon(
                address.isDefault ? Icons.home_filled : Icons.location_on_outlined, 
                color: address.isDefault ? Theme.of(context).colorScheme.primary : Colors.grey[600]
              ),
              title: Text(address.title, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('${address.street}, ${address.city}'),
              trailing: address.isDefault
                  ? Chip(label: const Text('Default', style: TextStyle(fontSize: 10)), backgroundColor: Colors.green.shade100, labelStyle: TextStyle(color: Colors.green.shade700))
                  : null,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Editing ${address.title} address')),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Add New Address functionality coming soon')),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}