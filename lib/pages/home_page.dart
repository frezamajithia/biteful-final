import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/category_chip.dart';
import '../widgets/restaurant_card.dart';
import '../data/sample_data.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../theme.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _controller = TextEditingController();
  String _q = '';
  bool _refreshing = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    setState(() => _refreshing = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _refreshing = false);
  }

  @override
  Widget build(BuildContext context) {
    final titleMedium = Theme.of(context).textTheme.titleMedium;
    final filtered = restaurants.where((r) {
      final q = _q.trim().toLowerCase();
      if (q.isEmpty) return true;
      final inName = r.name.toLowerCase().contains(q);
      final inMenu = r.appetizers.any((m) =>
          m.title.toLowerCase().contains(q) ||
          m.desc.toLowerCase().contains(q));
      return inName || inMenu;
    }).toList();

    return Scaffold(
      backgroundColor: kBackground,
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        color: kPrimary,
        child: ListView(
          children: [
            // Search bar
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _controller,
                onChanged: (v) => setState(() => _q = v),
                decoration: InputDecoration(
                  hintText: 'Search restaurants or dishes...',
                  prefixIcon: const Icon(Icons.search, color: Colors.black54),
                  suffixIcon: _q.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: Colors.black54),
                          onPressed: () {
                            _controller.clear();
                            setState(() => _q = '');
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              ),
            ),

            // Categories section
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Categories',
                    style: titleMedium?.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (_refreshing)
                    const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: kPrimary,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 58,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: const [
                  CategoryChip(
                    label: 'Pizza',
                    iconAsset: 'assets/icons/pizza.png',
                  ),
                  SizedBox(width: 10),
                  CategoryChip(
                    label: 'Chinese',
                    iconAsset: 'assets/icons/chinese.png',
                  ),
                  SizedBox(width: 10),
                  CategoryChip(
                    label: 'Japanese',
                    iconAsset: 'assets/icons/japanese.png',
                  ),
                  SizedBox(width: 10),
                  CategoryChip(
                    label: 'Dessert',
                    iconAsset: 'assets/icons/dessert.png',
                  ),
                ],
              ),
            ),

            // Restaurants section
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Nearby Restaurants',
                style: titleMedium?.copyWith(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(height: 12),

            if (_q.isNotEmpty && filtered.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.search_off_rounded,
                        size: 64,
                        color: Colors.grey.shade300,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No restaurants found',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Try a different search',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            ...filtered.map((r) {
              return RestaurantCard(
                title: r.name,
                image: r.heroImage,
                eta: r.eta,
                fee: r.fee,
                rating: r.rating,
                count: r.ratingCount,
                distance: r.distance,
                onTap: () => context.push('/restaurant/${r.id}'),
              );
            }),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
