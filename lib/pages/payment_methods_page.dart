import 'package:flutter/material.dart';

class PaymentMethod {
  final String type;
  final String lastFour;

  PaymentMethod({required this.type, required this.lastFour});

  IconData get icon {
    switch (type) {
      case 'Visa':
        return Icons.credit_card;
      case 'Mastercard':
        return Icons.credit_card;
      case 'PayPal':
        return Icons.payment;
      default:
        return Icons.attach_money;
    }
  }
}

final List<PaymentMethod> mockPayments = [
  PaymentMethod(type: 'Visa', lastFour: '4242'),
  PaymentMethod(type: 'Mastercard', lastFour: '0012'),
  PaymentMethod(type: 'PayPal', lastFour: '***'),
];

class PaymentMethodsPage extends StatelessWidget {
  const PaymentMethodsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Methods'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: mockPayments.isEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.credit_card_off, size: 48, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'No payment methods added yet.',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: mockPayments.length,
              itemBuilder: (context, index) {
                final payment = mockPayments[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    leading: Icon(payment.icon, color: Colors.blueAccent),
                    title: Text('${payment.type} ending in ${payment.lastFour}'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Selected ${payment.type}')),
                      );
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Add New Card functionality coming soon')),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}