import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../data/sample_data.dart';
import '../providers/cart_provider.dart';
import 'package:provider/provider.dart';
import '../theme.dart';

class RestaurantPage extends StatelessWidget {
  final String id;
  const RestaurantPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final r = restaurants.firstWhere((e) => e.id == id);

    return Scaffold(
      backgroundColor: kBackground,
      body: CustomScrollView(
        slivers: [
          // Stretchy blurred hero image
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            stretch: true,
            backgroundColor: kPrimary,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              onPressed: () => context.pop(),
            ),
            actions: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.3),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.share, color: Colors.white),
                ),
                onPressed: () {},
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    r.heroImage,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: kSecondary,
                      child: const Icon(Icons.restaurant, size: 64, color: Colors.white),
                    ),
                  ),
                  // Blur overlay
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 0.5, sigmaY: 0.5),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.6),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Restaurant name at bottom
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          r.name,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                blurRadius: 8,
                                color: Colors.black45,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${r.eta} • ${r.fee}',
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                blurRadius: 8,
                                color: Colors.black45,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              stretchModes: const [
                StretchMode.zoomBackground,
                StretchMode.blurBackground,
              ],
            ),
          ),

          // Menu content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.star, color: kStar, size: 20),
                      const SizedBox(width: 4),
                      Text(
                        '${r.rating} (${r.ratingCount} ratings) • ${r.distance}',
                        style: const TextStyle(fontSize: 14, color: Colors.black87),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Appetizers',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 12),
                  ...r.appetizers.map((m) => _MenuTile(item: m, rid: r.id)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  final MenuItem item;
  final String rid;
  const _MenuTile({required this.item, required this.rid});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: Colors.grey.withValues(alpha: 0.1)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.desc,
                    style: const TextStyle(fontSize: 13, color: Colors.black54),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${item.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: kPrimary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            FilledButton(
              onPressed: () {
                final cart = context.read<CartProvider>();
                final success = cart.addItem(item, rid);
                
                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${item.title} added to cart'),
                      duration: const Duration(seconds: 2),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: kPrimary,
                      action: SnackBarAction(
                        label: 'VIEW',
                        textColor: Colors.white,
                        onPressed: () => context.push('/cart'),
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Clear your cart to order from ${cart.restaurantName}'),
                      duration: const Duration(seconds: 3),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: kWarn,
                    ),
                  );
                }
              },
              style: FilledButton.styleFrom(
                backgroundColor: kPrimary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: const Text('Add', style: TextStyle(fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ),
    );
  }
}
