import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../db/database_helper.dart';
import '../models/order.dart';
import '../providers/cart_provider.dart';
import '../theme.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  List<Order> _orders = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    setState(() => _loading = true);
    final orders = await DatabaseHelper.instance.fetchOrdersAsModels();
    setState(() {
      _orders = orders;
      _loading = false;
    });
  }

  Future<void> _handleReorder(Order order) async {
    if (order.id == null) return;

    // Fetch order items
    final items = await DatabaseHelper.instance.fetchOrderItemsAsModels(order.id!);

    if (items.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No items found for this order')),
        );
      }
      return;
    }

    // Convert to reorder format
    final reorderItems = items.map((item) => {
      'name': item.itemName,
      'price': item.unitPrice,
      'quantity': item.quantity,
    }).toList();

    if (!mounted) return;

    // Add to cart
    final cart = context.read<CartProvider>();
    cart.reorder(
      restaurantName: order.restaurantName,
      items: reorderItems,
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Added ${items.length} items from ${order.restaurantName}'),
          backgroundColor: Colors.green,
          action: SnackBarAction(
            label: 'View Cart',
            textColor: Colors.white,
            onPressed: () => context.push('/cart'),
          ),
        ),
      );
    }
  }

  Future<void> _clearAll() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear all orders?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await DatabaseHelper.instance.clearOrders();
      _loadOrders();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: _loading
          ? const Center(child: CircularProgressIndicator(color: kPrimary))
          : _orders.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.receipt_long_outlined,
                          size: 80, color: Colors.grey.shade300),
                      const SizedBox(height: 16),
                      Text(
                        'No orders yet',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Your Orders',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          TextButton.icon(
                            onPressed: _clearAll,
                            icon: const Icon(Icons.delete_outline, size: 18),
                            label: const Text('Clear All'),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: _loadOrders,
                        color: kPrimary,
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: _orders.length,
                          itemBuilder: (context, index) =>
                              _buildOrderCard(_orders[index]),
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }

  Widget _buildOrderCard(Order order) {
    final date = DateTime.tryParse(order.createdAt);
    final dateStr = date != null
        ? DateFormat('MMM d, y • h:mm a').format(date)
        : order.createdAt;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(kCardRadius),
        boxShadow: kCardShadow,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.restaurantName,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        dateStr,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: kPrimary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    order.status,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: kPrimary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Total: \$${order.total.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: kPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton.icon(
                      onPressed: () => _handleReorder(order),
                      icon: const Icon(Icons.replay, size: 16),
                      label: const Text('Reorder', style: TextStyle(fontSize: 13)),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                    const SizedBox(width: 8),
                    TextButton.icon(
                      onPressed: () {
                        if (order.id != null) {
                          context.push('/track/${order.id}');
                        }
                      },
                      icon: const Icon(Icons.location_on, size: 16),
                      label: const Text('Track', style: TextStyle(fontSize: 13)),
                      style: TextButton.styleFrom(
                        foregroundColor: kPrimary,
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                  ],
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }
}
