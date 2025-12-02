import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme.dart';

class PaymentMethod {
  String type;
  String lastFour;
  String? cardholderName;
  String? expiryDate;
  bool isDefault;

  PaymentMethod({
    required this.type,
    required this.lastFour,
    this.cardholderName,
    this.expiryDate,
    this.isDefault = false,
  });

  IconData get icon {
    switch (type.toLowerCase()) {
      case 'visa':
        return Icons.credit_card;
      case 'mastercard':
        return Icons.credit_card;
      case 'paypal':
        return Icons.account_balance_wallet;
      case 'apple pay':
        return Icons.apple;
      default:
        return Icons.payment;
    }
  }

  Color get brandColor {
    switch (type.toLowerCase()) {
      case 'visa':
        return Colors.blue.shade700;
      case 'mastercard':
        return Colors.orange.shade700;
      case 'paypal':
        return Colors.indigo;
      case 'apple pay':
        return Colors.black;
      default:
        return kPrimary;
    }
  }
}

class PaymentMethodsPage extends StatefulWidget {
  const PaymentMethodsPage({super.key});

  @override
  State<PaymentMethodsPage> createState() => _PaymentMethodsPageState();
}

class _PaymentMethodsPageState extends State<PaymentMethodsPage> {
  final List<PaymentMethod> _payments = [
    PaymentMethod(
      type: 'Visa',
      lastFour: '4242',
      cardholderName: 'John Doe',
      expiryDate: '12/26',
      isDefault: true,
    ),
    PaymentMethod(
      type: 'Mastercard',
      lastFour: '0012',
      cardholderName: 'John Doe',
      expiryDate: '08/25',
    ),
    PaymentMethod(
      type: 'PayPal',
      lastFour: '***',
      cardholderName: 'john.doe@email.com',
    ),
  ];

  void _showPaymentDialog({PaymentMethod? payment, int? index}) {
    final isEditing = payment != null;
    final cardTypes = ['Visa', 'Mastercard', 'PayPal', 'Apple Pay'];
    String selectedType = payment?.type ?? 'Visa';
    final cardNumberController = TextEditingController(text: payment?.lastFour ?? '');
    final nameController = TextEditingController(text: payment?.cardholderName ?? '');
    final expiryController = TextEditingController(text: payment?.expiryDate ?? '');
    bool isDefault = payment?.isDefault ?? false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(isEditing ? 'Edit Payment Method' : 'Add Payment Method'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Card Type Dropdown
                DropdownButtonFormField<String>(
                  initialValue: selectedType,
                  decoration: InputDecoration(
                    labelText: 'Card Type',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    prefixIcon: const Icon(Icons.credit_card),
                  ),
                  items: cardTypes.map((type) => DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  )).toList(),
                  onChanged: (value) {
                    setDialogState(() => selectedType = value!);
                  },
                ),
                const SizedBox(height: 16),
                // Card Number (last 4 digits)
                TextField(
                  controller: cardNumberController,
                  decoration: InputDecoration(
                    labelText: selectedType == 'PayPal' ? 'Email' : 'Last 4 Digits',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    prefixIcon: Icon(selectedType == 'PayPal' ? Icons.email : Icons.pin),
                  ),
                  keyboardType: selectedType == 'PayPal'
                      ? TextInputType.emailAddress
                      : TextInputType.number,
                  maxLength: selectedType == 'PayPal' ? null : 4,
                  inputFormatters: selectedType == 'PayPal'
                      ? []
                      : [FilteringTextInputFormatter.digitsOnly],
                ),
                const SizedBox(height: 16),
                // Cardholder Name
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: selectedType == 'PayPal' ? 'Account Email' : 'Cardholder Name',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    prefixIcon: const Icon(Icons.person_outline),
                  ),
                  textCapitalization: TextCapitalization.words,
                ),
                if (selectedType != 'PayPal') ...[
                  const SizedBox(height: 16),
                  // Expiry Date
                  TextField(
                    controller: expiryController,
                    decoration: InputDecoration(
                      labelText: 'Expiry Date (MM/YY)',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      prefixIcon: const Icon(Icons.calendar_today),
                    ),
                    keyboardType: TextInputType.datetime,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9/]')),
                      LengthLimitingTextInputFormatter(5),
                    ],
                  ),
                ],
                const SizedBox(height: 16),
                CheckboxListTile(
                  value: isDefault,
                  onChanged: (v) => setDialogState(() => isDefault = v ?? false),
                  title: const Text('Set as default payment'),
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
                  _deletePayment(index!);
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
                final cardNumber = cardNumberController.text.trim();
                final name = nameController.text.trim();

                if (cardNumber.isEmpty || name.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill in all required fields')),
                  );
                  return;
                }

                if (selectedType != 'PayPal' && cardNumber.length != 4) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter exactly 4 digits')),
                  );
                  return;
                }

                Navigator.pop(context);

                if (isEditing) {
                  _updatePayment(index!, selectedType, cardNumber, name, expiryController.text, isDefault);
                } else {
                  _addPayment(selectedType, cardNumber, name, expiryController.text, isDefault);
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

  void _addPayment(String type, String lastFour, String name, String expiry, bool isDefault) {
    setState(() {
      if (isDefault) {
        for (var p in _payments) {
          p.isDefault = false;
        }
      }
      _payments.add(PaymentMethod(
        type: type,
        lastFour: lastFour,
        cardholderName: name,
        expiryDate: expiry.isNotEmpty ? expiry : null,
        isDefault: isDefault,
      ));
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$type added'), backgroundColor: kPrimary),
    );
  }

  void _updatePayment(int index, String type, String lastFour, String name, String expiry, bool isDefault) {
    setState(() {
      if (isDefault) {
        for (var p in _payments) {
          p.isDefault = false;
        }
      }
      _payments[index] = PaymentMethod(
        type: type,
        lastFour: lastFour,
        cardholderName: name,
        expiryDate: expiry.isNotEmpty ? expiry : null,
        isDefault: isDefault,
      );
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$type updated'), backgroundColor: kPrimary),
    );
  }

  void _deletePayment(int index) {
    final payment = _payments[index];
    setState(() {
      _payments.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${payment.type} removed'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _payments.insert(index, payment);
            });
          },
        ),
      ),
    );
  }

  void _setAsDefault(int index) {
    setState(() {
      for (int i = 0; i < _payments.length; i++) {
        _payments[i].isDefault = (i == index);
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${_payments[index].type} set as default'), backgroundColor: kPrimary),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        title: const Text('Payment Methods'),
        backgroundColor: kPrimary,
        foregroundColor: Colors.white,
      ),
      body: _payments.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.credit_card_off, size: 64, color: Colors.grey.shade300),
                  const SizedBox(height: 16),
                  Text(
                    'No payment methods',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap + to add a payment method',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _payments.length,
              itemBuilder: (context, index) {
                final payment = _payments[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: kCardShadow,
                    border: payment.isDefault ? Border.all(color: kPrimary, width: 2) : null,
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    leading: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: payment.brandColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(payment.icon, color: payment.brandColor, size: 28),
                    ),
                    title: Row(
                      children: [
                        Text(
                          payment.type,
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                        ),
                        if (payment.isDefault) ...[
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
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          payment.type == 'PayPal'
                              ? payment.cardholderName ?? 'PayPal Account'
                              : '•••• •••• •••• ${payment.lastFour}',
                          style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                        ),
                        if (payment.expiryDate != null && payment.expiryDate!.isNotEmpty)
                          Text(
                            'Expires ${payment.expiryDate}',
                            style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                          ),
                      ],
                    ),
                    trailing: PopupMenuButton(
                      icon: const Icon(Icons.more_vert),
                      itemBuilder: (context) => [
                        const PopupMenuItem(value: 'edit', child: Text('Edit')),
                        if (!payment.isDefault)
                          const PopupMenuItem(value: 'default', child: Text('Set as default')),
                        const PopupMenuItem(value: 'delete', child: Text('Delete', style: TextStyle(color: Colors.red))),
                      ],
                      onSelected: (value) {
                        if (value == 'edit') {
                          _showPaymentDialog(payment: payment, index: index);
                        } else if (value == 'default') {
                          _setAsDefault(index);
                        } else if (value == 'delete') {
                          _deletePayment(index);
                        }
                      },
                    ),
                    onTap: () => _showPaymentDialog(payment: payment, index: index),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showPaymentDialog(),
        backgroundColor: kPrimary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
