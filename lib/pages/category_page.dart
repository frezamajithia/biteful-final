import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/restaurant_card.dart';
import '../data/sample_data.dart';
import '../theme.dart';

class CategoryPage extends StatefulWidget {
  final String categoryName;
  final String iconAsset;

  const CategoryPage({
    super.key,
    required this.categoryName,
    required this.iconAsset,
  });

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  String _sortBy = 'rating';

  List<RestaurantLite> get _filteredRestaurants {
    var list = restaurants.where((r) {
    
      if (widget.categoryName.toLowerCase() == 'american') {
        return r.category.toLowerCase() == 'american' || 
               r.category.toLowerCase() == 'pizza' ||
               r.category.toLowerCase() == 'burger';
      }
      return r.category.toLowerCase() == widget.categoryName.toLowerCase();
    }).toList();

    
    switch (_sortBy) {
      case 'rating':
        list.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'distance':
        list.sort((a, b) {
          final distA = double.tryParse(a.distance.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0;
          final distB = double.tryParse(b.distance.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0;
          return distA.compareTo(distB);
        });
        break;
      case 'delivery':
        list.sort((a, b) {
          final etaA = int.tryParse(a.eta.split('-').first) ?? 0;
          final etaB = int.tryParse(b.eta.split('-').first) ?? 0;
          return etaA.compareTo(etaB);
        });
        break;
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final categoryRestaurants = _filteredRestaurants;

    return Scaffold(
      backgroundColor: kBackground,
      body: CustomScrollView(
        slivers: [
          // Beautiful header with category icon
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            stretch: true,
            backgroundColor: kPrimary,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      kPrimary,
                      kPrimary.withValues(alpha: 0.8),
                      kSecondary.withValues(alpha: 0.6),
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      // Category icon in a decorated container
                      Container(
                        width: 80,
                        height: 80,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.15),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Image.asset(
                          widget.iconAsset,
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => Icon(
                            Icons.restaurant,
                            size: 40,
                            color: kPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        widget.categoryName,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${categoryRestaurants.length} restaurant${categoryRestaurants.length != 1 ? 's' : ''} available',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              stretchModes: const [StretchMode.zoomBackground],
            ),
          ),

          // Sort/filter bar
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: kCardShadow,
              ),
              child: Row(
                children: [
                  Icon(Icons.sort, color: kPrimary, size: 20),
                  const SizedBox(width: 8),
                  const Text(
                    'Sort by:',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: kTextDark,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _SortChip(
                            label: 'Rating',
                            icon: Icons.star,
                            isSelected: _sortBy == 'rating',
                            onTap: () => setState(() => _sortBy = 'rating'),
                          ),
                          const SizedBox(width: 8),
                          _SortChip(
                            label: 'Distance',
                            icon: Icons.location_on,
                            isSelected: _sortBy == 'distance',
                            onTap: () => setState(() => _sortBy = 'distance'),
                          ),
                          const SizedBox(width: 8),
                          _SortChip(
                            label: 'Fastest',
                            icon: Icons.access_time,
                            isSelected: _sortBy == 'delivery',
                            onTap: () => setState(() => _sortBy = 'delivery'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Results section
          if (categoryRestaurants.isEmpty)
            SliverFillRemaining(
              child: _EmptyState(categoryName: widget.categoryName),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final r = categoryRestaurants[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: RestaurantCard(
                        id: r.id,
                        title: r.name,
                        image: r.heroImage,
                        eta: r.eta,
                        fee: r.fee,
                        rating: r.rating,
                        count: r.ratingCount,
                        distance: r.distance,
                        onTap: () => context.push('/restaurant/${r.id}'),
                      ),
                    );
                  },
                  childCount: categoryRestaurants.length,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SortChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _SortChip({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? kPrimary : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? kPrimary : Colors.grey.shade200,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? Colors.white : Colors.grey.shade600,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String categoryName;

  const _EmptyState({required this.categoryName});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: kSecondary.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.restaurant_outlined,
                size: 48,
                color: kSecondary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No restaurants yet',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: kTextDark,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'We\'re working on adding more $categoryName restaurants to your area.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade600,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.explore),
              label: const Text('Explore other categories'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
