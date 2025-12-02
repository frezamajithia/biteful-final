import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/category_chip.dart';
import '../widgets/restaurant_card.dart';
import '../widgets/skeleton_card.dart';
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

  // Filter state
  String? _selectedCuisine;
  double _minRating = 0;
  String _sortBy = 'default'; // default, rating, distance

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

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Filters',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 20),

              // Cuisine filter
              const Text(
                'Cuisine',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: ['All', 'Chinese', 'Japanese', 'Dessert', 'American', 'Mexican']
                    .map((cuisine) => ChoiceChip(
                          label: Text(cuisine),
                          selected: _selectedCuisine == (cuisine == 'All' ? null : cuisine),
                          selectedColor: kPrimary.withValues(alpha: 0.2),
                          onSelected: (selected) {
                            setModalState(() {
                              _selectedCuisine = cuisine == 'All' ? null : cuisine;
                            });
                            setState(() {});
                          },
                        ))
                    .toList(),
              ),
              const SizedBox(height: 20),

              // Rating filter
              const Text(
                'Minimum Rating',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Slider(
                      value: _minRating,
                      min: 0,
                      max: 5,
                      divisions: 10,
                      activeColor: kPrimary,
                      label: _minRating.toStringAsFixed(1),
                      onChanged: (value) {
                        setModalState(() => _minRating = value);
                        setState(() {});
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: kPrimary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.star, size: 16, color: kStar),
                        const SizedBox(width: 4),
                        Text(
                          _minRating.toStringAsFixed(1),
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Sort by
              const Text(
                'Sort By',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                children: [
                  ChoiceChip(
                    label: const Text('Default'),
                    selected: _sortBy == 'default',
                    selectedColor: kPrimary.withValues(alpha: 0.2),
                    onSelected: (_) {
                      setModalState(() => _sortBy = 'default');
                      setState(() {});
                    },
                  ),
                  ChoiceChip(
                    label: const Text('Rating'),
                    selected: _sortBy == 'rating',
                    selectedColor: kPrimary.withValues(alpha: 0.2),
                    onSelected: (_) {
                      setModalState(() => _sortBy = 'rating');
                      setState(() {});
                    },
                  ),
                  ChoiceChip(
                    label: const Text('Distance'),
                    selected: _sortBy == 'distance',
                    selectedColor: kPrimary.withValues(alpha: 0.2),
                    onSelected: (_) {
                      setModalState(() => _sortBy = 'distance');
                      setState(() {});
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Apply & Reset buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        setModalState(() {
                          _selectedCuisine = null;
                          _minRating = 0;
                          _sortBy = 'default';
                        });
                        setState(() {});
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: BorderSide(color: Colors.grey.shade300),
                      ),
                      child: const Text('Reset'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(ctx),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text('Apply'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final titleMedium = Theme.of(context).textTheme.titleMedium;

    // Apply filters
    var filtered = _restaurants.where((r) {
      final q = _q.trim().toLowerCase();

      // Text search
      bool matchesSearch = true;
      if (q.isNotEmpty) {
        final inName = r.name.toLowerCase().contains(q);
        final inMenu = r.appetizers.any((m) =>
            m.title.toLowerCase().contains(q) ||
            m.desc.toLowerCase().contains(q));
        matchesSearch = inName || inMenu;
      }

      // Cuisine filter
      bool matchesCuisine = _selectedCuisine == null ||
          r.category.toLowerCase() == _selectedCuisine!.toLowerCase();

      // Rating filter
      bool matchesRating = r.rating >= _minRating;

      return matchesSearch && matchesCuisine && matchesRating;
    }).toList();

    // Apply sorting
    if (_sortBy == 'rating') {
      filtered.sort((a, b) => b.rating.compareTo(a.rating));
    } else if (_sortBy == 'distance') {
      filtered.sort((a, b) {
        final distA = double.tryParse(a.distance.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0;
        final distB = double.tryParse(b.distance.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0;
        return distA.compareTo(distB);
      });
    }

    final hasActiveFilters = _selectedCuisine != null || _minRating > 0 || _sortBy != 'default';

    return Scaffold(
      backgroundColor: kBackground,
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        color: kPrimary,
        child: ListView(
          children: [
            // Search bar with filter button
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
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
                  const SizedBox(width: 12),
                  // Filter button
                  GestureDetector(
                    onTap: _showFilterSheet,
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: hasActiveFilters ? kPrimary : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: kCardShadow,
                      ),
                      child: Badge(
                        isLabelVisible: hasActiveFilters,
                        backgroundColor: Colors.white,
                        label: Text(
                          '${(_selectedCuisine != null ? 1 : 0) + (_minRating > 0 ? 1 : 0) + (_sortBy != 'default' ? 1 : 0)}',
                          style: const TextStyle(color: kPrimary, fontSize: 10),
                        ),
                        child: Icon(
                          Icons.tune,
                          color: hasActiveFilters ? Colors.white : kPrimary,
                        ),
                      ),
                    ),
                  ),
                ],
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
              height: 66,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  CategoryChip(
                    label: 'American',
                    iconAsset: 'assets/icons/american.png',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CategoryPage(
                            categoryName: 'American',
                            iconAsset: 'assets/icons/american.png',
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

            // Restaurant list with skeleton loading
            if (_loading) ...[
              const SkeletonRestaurantCard(),
              const SkeletonRestaurantCard(),
              const SkeletonRestaurantCard(),
            ] else if (_error == null) ...filtered.map((r) {
              return RestaurantCard(
                id: r.id,
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
