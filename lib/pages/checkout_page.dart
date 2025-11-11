import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../db/database_helper.dart';
import '../models/order.dart';
import '../models/order_item.dart';
import 'package:intl/intl.dart';
import '../services/notify.dart';
import '../theme.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});
  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  String _deliveryMethod = 'Delivery';
  TimeOfDay? _time;

  Future<void> _chooseMethod() async {
    final result = await showCupertinoModalPopup<String>(
      context: context,
      builder: (_) => CupertinoActionSheet(
        title: const Text('Delivery Method'),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () => Navigator.of(context).pop('Delivery'),
            child: const Text('Delivery'),
          ),
          CupertinoActionSheetAction(
            onPressed: () => Navigator.of(context).pop('Pickup'),
            child: const Text('Pickup'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
      ),
    );
    if (result != null) setState(() => _deliveryMethod = result);
  }

  Future<void> _pickTime() async {
    TimeOfDay selected = _time ?? TimeOfDay.now();
    await showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 250,
        color: Colors.white,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CupertinoButton(
                  child: const Text('Cancel'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                CupertinoButton(
                  child: const Text('Done'),
                  onPressed: () {
                    setState(() => _time = selected);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
            Expanded(
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.time,
                initialDateTime: DateTime.now(),
                onDateTimeChanged: (dt) {
                  selected = TimeOfDay.fromDateTime(dt);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(TimeOfDay? time) {
    if (time == null) return 'ASAP';
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat('h:mm a').format(dt);
  }

  Future<void> _placeOrder() async {
    final cart = context.read<CartProvider>();

    if (cart.items.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Your cart is empty')),
        );
      }
      return;
    }

    final now = DateTime.now();
    final ts = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

    final order = Order(
      restaurantName: cart.restaurantName ?? 'Unknown',
      total: cart.total,
      status: 'Placed ($_deliveryMethod)',
      createdAt: ts,
    );

    final orderItems = cart.items
        .map((c) => OrderItem(
              itemName: c.item.title,
              quantity: c.quantity,
              unitPrice: c.item.price,
            ))
        .toList();

    try {
      final db = DatabaseHelper.instance;
      final orderId = await db.insertOrder(order);
      
      for (final item in orderItems) {
        await db.insertOrderItem(orderId, item);
      }

      cart.clear();

      await Notify.instance.show(
        title: 'Order Confirmed',
        body: 'Your order from ${order.restaurantName} has been placed!',
      );

      if (mounted) {
        context.go('/order-confirmed/${orderId.toString()}');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error placing order: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: kPrimary,
        foregroundColor: Colors.white,
      ),
      body: cart.items.isEmpty
          ? const Center(child: Text('Your cart is empty'))
          : Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      // Delivery method
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: kCardShadow,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Delivery Method',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 12),
                            InkWell(
                              onTap: _chooseMethod,
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey.shade300),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(_deliveryMethod),
                                    const Icon(Icons.chevron_right),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Delivery time picker
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: kCardShadow,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Delivery Time',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 12),
                            InkWell(
                              onTap: _pickTime,
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey.shade300),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.access_time,
                                          size: 20,
                                          color: Colors.grey.shade600,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(_formatTime(_time)),
                                      ],
                                    ),
                                    const Icon(Icons.chevron_right),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Order summary
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: kCardShadow,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Order Summary',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 12),
                            ...cart.items.map((item) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('${item.quantity}x ${item.item.title}'),
                                  Text('\$${(item.item.price * item.quantity).toStringAsFixed(2)}'),
                                ],
                              ),
                            )),
                            const Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Total',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  '\$${cart.total.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: kPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Place order button
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    top: false,
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _placeOrder,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kPrimary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Place Order',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
