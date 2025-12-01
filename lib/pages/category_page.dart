import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/restaurant_card.dart';
import '../data/sample_data.dart';
import '../theme.dart';

class CategoryPage extends StatelessWidget {
  final String categoryName;
  final String iconAsset;

  const CategoryPage({
    super.key,
    required this.categoryName,
    required this.iconAsset,
  });

  @override
  Widget build(BuildContext context) {
    // Filter restaurants by category
    final categoryRestaurants = restaurants
        .where((r) => r.category.toLowerCase() == categoryName.toLowerCase())
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName),
        backgroundColor: kPrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Category icon at top
          Image.asset(iconAsset, height: 150),
          const SizedBox(height: 20),
          Text(
            'Restaurants for $categoryName',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // List restaurants
          if (categoryRestaurants.isEmpty)
            Center(
              child: Text(
                'No restaurants found in $categoryName',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
              ),
            )
          else
            ...categoryRestaurants.map((r) => RestaurantCard(
                  title: r.name,
                  image: r.heroImage,
                  eta: r.eta,
                  fee: r.fee,
                  rating: r.rating,
                  count: r.ratingCount,
                  distance: r.distance,
                  onTap: () {
                  
                    context.push('/restaurant/${r.id}');
                  },
                )),
        ],
      ),
    );
  }
}
