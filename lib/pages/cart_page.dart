import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/cart_provider.dart';
import '../widgets/soft_action_button.dart';
import '../theme.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    if (cart.items.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Cart'),
          backgroundColor: kPrimary,
          foregroundColor: Colors.white,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.shopping_cart_outlined,
                size: 120,
                color: Colors.grey.shade300,
              ),
              const SizedBox(height: 24),
              Text(
                'Your cart is empty',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Add items from restaurants to get started',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey.shade500,
                ),
              ),
              const SizedBox(height: 32),
              FilledButton.icon(
                onPressed: () => context.go('/'),
                icon: const Icon(Icons.restaurant_menu),
                label: const Text('Browse Restaurants'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Cart')),
      body: cart.items.isEmpty
          ? const Center(
              child: Text(
                'Your cart is empty',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Restaurant info
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(kCardRadius),
                      boxShadow: kCardShadow,
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.restaurant, color: kPrimary),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            cart.restaurantName ?? 'Restaurant',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Cart items
                  Expanded(
                    child: ListView.builder(
                      itemCount: cart.items.length,
                      itemBuilder: (context, i) {
                        final item = cart.items[i];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(kCardRadius),
                            boxShadow: kCardShadow,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.item.title,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '\$${item.item.price.toStringAsFixed(2)}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove_circle_outline),
                                    onPressed: () => cart.removeOne(item.item),
                                    color: kPrimary,
                                  ),
                                  Text(
                                    '${item.quantity}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.add_circle_outline),
                                    onPressed: () => cart.addItem(
                                      item.item,
                                      item.restaurantId,
                                    ),
                                    color: kPrimary,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Summary
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(kCardRadius),
                      boxShadow: kCardShadow,
                    ),
                    child: Column(
                      children: [
                        _row('Subtotal', '\$${cart.subtotal.toStringAsFixed(2)}'),
                        _row('Taxes', '\$${cart.taxes.toStringAsFixed(2)}'),
                        const Divider(height: 20),
                        _row('Total', '\$${cart.total.toStringAsFixed(2)}', bold: true),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: SoftActionButton(
                          label: 'Clear',
                          onPressed: () {
                            cart.clear();
                            context.pop();
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: SoftActionButton(
                          label: 'Checkout',
                          filledWhenIdle: true,
                          onPressed: () => context.push('/checkout'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }

  Widget _row(String label, String value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 15,
              fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 15,
              fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}