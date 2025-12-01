import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/category_chip.dart';
import '../widgets/restaurant_card.dart';
import '../data/sample_data.dart';
import '../services/api_service.dart';
import '../theme.dart';
import 'category_page.dart'; // Import the category page

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _controller = TextEditingController();
  String _q = '';
  bool _loading = true;
  String? _error;
  List<RestaurantLite> _restaurants = [];

  @override
  void initState() {
    super.initState();
    _fetchRestaurants();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _fetchRestaurants() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final data = await ApiService.getRestaurants();
      setState(() {
        _restaurants = data;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  Future<void> _handleRefresh() async {
    await _fetchRestaurants();
  }

  @override
  Widget build(BuildContext context) {
    final titleMedium = Theme.of(context).textTheme.titleMedium;
    final filtered = _restaurants.where((r) {
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
                  if (_loading)
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
                children: [
                  CategoryChip(
                    label: 'Pizza',
                    iconAsset: 'assets/icons/pizza.png',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CategoryPage(
                            categoryName: 'Pizza',
                            iconAsset: 'assets/icons/pizza.png',
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 10),
                  CategoryChip(
                    label: 'Chinese',
                    iconAsset: 'assets/icons/chinese.png',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CategoryPage(
                            categoryName: 'Chinese',
                            iconAsset: 'assets/icons/chinese.png',
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 10),
                  CategoryChip(
                    label: 'Japanese',
                    iconAsset: 'assets/icons/japanese.png',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CategoryPage(
                            categoryName: 'Japanese',
                            iconAsset: 'assets/icons/japanese.png',
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 10),
                  CategoryChip(
                    label: 'Dessert',
                    iconAsset: 'assets/icons/dessert.png',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CategoryPage(
                            categoryName: 'Dessert',
                            iconAsset: 'assets/icons/dessert.png',
                          ),
                        ),
                      );
                    },
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

            // Error state
            if (_error != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.cloud_off_rounded,
                        size: 64,
                        color: Colors.grey.shade300,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Failed to load restaurants',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Pull down to try again',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade500,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _fetchRestaurants,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ),

            // Empty search results
            if (_error == null && _q.isNotEmpty && filtered.isEmpty)
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

            // Restaurant list
            if (_error == null) ...filtered.map((r) {
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
