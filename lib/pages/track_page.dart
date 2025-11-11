import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme.dart';
import '../db/database_helper.dart';
import '../models/order.dart';
import '../models/order_item.dart';

class TrackPage extends StatefulWidget {
  final String orderId;
  
  const TrackPage({super.key, required this.orderId});

  @override
  State<TrackPage> createState() => _TrackPageState();
}

class _TrackPageState extends State<TrackPage> {
  Order? _order;
  List<OrderItem> _items = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadOrderDetails();
  }

  Future<void> _loadOrderDetails() async {
    try {
      final db = DatabaseHelper.instance;
      final orderId = int.parse(widget.orderId);
      
      // Fetch order
      final orders = await db.fetchOrdersAsModels();
      final order = orders.firstWhere((o) => o.id == orderId);
      
      // Fetch order items
      final itemMaps = await db.fetchOrderItems(orderId);
      final items = itemMaps.map((map) => OrderItem.fromMap(map)).toList();
      
      setState(() {
        _order = order;
        _items = items;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading order: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order #${widget.orderId}'),
        backgroundColor: kPrimary,
        foregroundColor: Colors.white,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: kPrimary))
          : _order == null
              ? const Center(child: Text('Order not found'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Order status card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: kPrimary,
                          borderRadius: BorderRadius.circular(kCardRadius),
                        ),
                        child: Column(
                          children: [
                            const Icon(
                              Icons.check_circle_outline,
                              size: 64,
                              color: Colors.white,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              _order!.status,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _order!.restaurantName,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white.withValues(alpha: 0.9),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Order details
                      const Text(
                        'Order Details',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Items list
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(kCardRadius),
                          boxShadow: kCardShadow,
                        ),
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _items.length,
                          separatorBuilder: (_, __) => const Divider(height: 1),
                          itemBuilder: (context, index) {
                            final item = _items[index];
                            return Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.itemName,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Qty: ${item.quantity}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    '\$${item.totalPrice.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: kPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Total
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: kBackground,
                          borderRadius: BorderRadius.circular(kCardRadius),
                          border: Border.all(color: kPrimary.withValues(alpha: 0.2)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              '\$${_order!.total.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: kPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Back to orders button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => context.go('/'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kPrimary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Back to Home',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}