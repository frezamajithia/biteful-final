import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../db/database_helper.dart';
import '../models/order.dart';
import '../models/order_item.dart';
import '../services/api_service.dart';
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

  // Promo code state
  final _promoController = TextEditingController();
  String? _appliedPromo;
  double _discount = 0;
  String? _promoError;

  // Valid promo codes
  static const Map<String, double> _promoCodes = {
    'WELCOME10': 0.10,    // 10% off
    'SAVE20': 0.20,       // 20% off
    'FREESHIP': 0.05,     // 5% off (simulating free shipping)
    'BITEFUL50': 0.50,    // 50% off (special promo)
  };

  void _applyPromoCode() {
    final code = _promoController.text.trim().toUpperCase();

    if (code.isEmpty) {
      setState(() => _promoError = 'Please enter a promo code');
      return;
    }

    if (_promoCodes.containsKey(code)) {
      setState(() {
        _appliedPromo = code;
        _discount = _promoCodes[code]!;
        _promoError = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Promo code applied! ${(_discount * 100).toInt()}% off'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      setState(() {
        _promoError = 'Invalid promo code';
        _appliedPromo = null;
        _discount = 0;
      });
    }
  }

  void _removePromoCode() {
    setState(() {
      _appliedPromo = null;
      _discount = 0;
      _promoController.clear();
      _promoError = null;
    });
  }

  double _getFinalTotal(CartProvider cart) {
    final discountAmount = cart.subtotal * _discount;
    return cart.total - discountAmount;
  }

  Widget _summaryRow(String label, String value, {bool isDiscount = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: isDiscount ? Colors.green.shade700 : Colors.grey.shade700,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isDiscount ? FontWeight.w600 : FontWeight.w500,
              color: isDiscount ? Colors.green.shade700 : Colors.grey.shade800,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

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
    final finalTotal = _getFinalTotal(cart);

    final order = Order(
      restaurantName: cart.restaurantName ?? 'Unknown',
      total: finalTotal,
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
      // Save to local database
      final db = DatabaseHelper.instance;
      final orderId = await db.insertOrder(order);

      for (final item in orderItems) {
        await db.insertOrderItem(orderId, item);
      }

      // POST to remote API
      await ApiService.createOrder(
        restaurantName: order.restaurantName,
        items: orderItems.map((item) => {
          'name': item.itemName,
          'quantity': item.quantity,
          'price': item.unitPrice,
        }).toList(),
        total: finalTotal,
        status: order.status,
      );

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

                      // Promo code section
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
                            Row(
                              children: [
                                const Icon(Icons.local_offer, color: kPrimary, size: 20),
                                const SizedBox(width: 8),
                                const Text(
                                  'Promo Code',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                if (_appliedPromo != null) ...[
                                  const Spacer(),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.green.shade50,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.check_circle, color: Colors.green.shade600, size: 14),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${(_discount * 100).toInt()}% OFF',
                                          style: TextStyle(
                                            color: Colors.green.shade700,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 12),
                            if (_appliedPromo != null)
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.green.shade50,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.green.shade200),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            _appliedPromo!,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              color: Colors.green.shade700,
                                            ),
                                          ),
                                          Text(
                                            'You save \$${(cart.subtotal * _discount).toStringAsFixed(2)}',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.green.shade600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: _removePromoCode,
                                      icon: const Icon(Icons.close, size: 18),
                                      color: Colors.green.shade700,
                                    ),
                                  ],
                                ),
                              )
                            else
                              Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: _promoController,
                                      textCapitalization: TextCapitalization.characters,
                                      decoration: InputDecoration(
                                        hintText: 'Enter promo code',
                                        errorText: _promoError,
                                        filled: true,
                                        fillColor: Colors.grey.shade50,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                          borderSide: BorderSide(color: Colors.grey.shade300),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                          borderSide: BorderSide(color: Colors.grey.shade300),
                                        ),
                                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  ElevatedButton(
                                    onPressed: _applyPromoCode,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: kPrimary,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: const Text('Apply'),
                                  ),
                                ],
                              ),
                            const SizedBox(height: 8),
                            Text(
                              'Try: WELCOME10, SAVE20, BITEFUL50',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey.shade500,
                                fontStyle: FontStyle.italic,
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
                            // Subtotal
                            _summaryRow('Subtotal', '\$${cart.subtotal.toStringAsFixed(2)}'),
                            _summaryRow('Taxes (13%)', '\$${cart.taxes.toStringAsFixed(2)}'),
                            if (_discount > 0) ...[
                              _summaryRow(
                                'Discount ($_appliedPromo)',
                                '-\$${(cart.subtotal * _discount).toStringAsFixed(2)}',
                                isDiscount: true,
                              ),
                            ],
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
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    if (_discount > 0)
                                      Text(
                                        '\$${cart.total.toStringAsFixed(2)}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey.shade500,
                                          decoration: TextDecoration.lineThrough,
                                        ),
                                      ),
                                    Text(
                                      '\$${_getFinalTotal(cart).toStringAsFixed(2)}',
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
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Proceed to Payment button
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
                        onPressed: () async {
                          final finalTotal = _getFinalTotal(cart);
                          final result = await context.push<bool>('/payment/${finalTotal.toStringAsFixed(2)}');
                          if (result == true && mounted) {
                            await _placeOrder();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kPrimary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.payment, size: 22),
                            const SizedBox(width: 8),
                            Text(
                              'Proceed to Payment • \$${_getFinalTotal(cart).toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
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
