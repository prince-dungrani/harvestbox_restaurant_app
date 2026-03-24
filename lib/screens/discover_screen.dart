import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../data/mock_data.dart';
import '../models/meal_api_model.dart';
import '../services/api_service.dart';
import '../widgets/category_card.dart';
import '../widgets/filter_chip_widget.dart';
import 'category_screen.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  String _selectedFilter = 'Nearby';
  final List<String> _filters = ['Nearby', 'Under 30 mins', 'Top Rated'];
  final ApiService _apiService = ApiService();

  late Future<List<MealApiModel>> _suggestedMealsFuture;

  final Map<String, String> _categoryImages = {
    'Pizza': 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=400',
    'Burgers': 'https://images.unsplash.com/photo-1561758033-d89a9ad46330?w=400',
    'Salads': 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=400',
    'Desserts': 'https://images.unsplash.com/photo-1571877227200-a0d98ea607e9?w=400',
  };

  @override
  void initState() {
    super.initState();
    _suggestedMealsFuture = _apiService.searchMeals('chicken');
  }

  @override
  Widget build(BuildContext context) {
    final trendingCategories = MockData.getTrendingCategories();
    final recommendedItems = MockData.getRecommended();

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () {},
                  ),
                  const Text(
                    'Discover',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.shopping_cart),
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            // Search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppTheme.backgroundColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.search, color: Colors.grey),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Search for food, groceries...',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Filters
            Container(
              height: 45,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _filters.length,
                itemBuilder: (context, index) {
                  final filter = _filters[index];
                  final isSelected = filter == _selectedFilter;

                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: FilterChipWidget(
                      label: filter,
                      isSelected: isSelected,
                      onTap: () {
                        setState(() {
                          _selectedFilter = filter;
                        });
                      },
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 24),

            // Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ══════════════════════════════════════════
                    // 🌐 SUGGESTED FOR YOU — TheMealDB API
                    // ══════════════════════════════════════════
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            '🌍 Suggested for You',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.refresh,
                                color: AppTheme.primaryGreen),
                            onPressed: () {
                              setState(() {
                                _suggestedMealsFuture =
                                    _apiService.getRandomMeals(count: 6);
                              });
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // FutureBuilder for API data
                    FutureBuilder<List<MealApiModel>>(
                      future: _suggestedMealsFuture,
                      builder: (context, snapshot) {
                        // ⏳ Loading state
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const SizedBox(
                            height: 180,
                            child: Center(
                              child: CircularProgressIndicator(
                                color: AppTheme.primaryGreen,
                              ),
                            ),
                          );
                        }

                        // ❌ Error state
                        if (snapshot.hasError) {
                          return Container(
                            height: 120,
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.wifi_off,
                                      color: Colors.red, size: 32),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Failed to load suggestions',
                                    style:
                                        TextStyle(color: Colors.red.shade700),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        _suggestedMealsFuture = _apiService
                                            .searchMeals('chicken');
                                      });
                                    },
                                    child: const Text('Retry'),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        // ✅ Success state
                        final meals = snapshot.data ?? [];
                        if (meals.isEmpty) {
                          return const SizedBox(
                            height: 100,
                            child: Center(
                                child: Text('No suggestions available')),
                          );
                        }

                        return SizedBox(
                          height: 200,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            itemCount: meals.length,
                            itemBuilder: (context, index) {
                              final meal = meals[index];
                              return _buildMealSuggestionCard(meal);
                            },
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 24),

                    // Trending Categories
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'Trending Categories',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 1.5,
                        ),
                        itemCount: trendingCategories.length,
                        itemBuilder: (context, index) {
                          final category = trendingCategories[index];
                          return CategoryCard(
                            name: category,
                            image: _categoryImages[category] ?? '',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      CategoryScreen(category: category),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Recommended for You
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Recommended for You',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: const Text(
                              'See all',
                              style: TextStyle(color: AppTheme.primaryGreen),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Recommended items list
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: recommendedItems.length,
                      itemBuilder: (context, index) {
                        final item = recommendedItems[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Container(
                            height: 120,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                // Image
                                ClipRRect(
                                  borderRadius: const BorderRadius.horizontal(
                                    left: Radius.circular(16),
                                  ),
                                  child: Container(
                                    width: 100,
                                    height: double.infinity,
                                    color: Colors.grey.shade200,
                                    child: Image.network(
                                      item.image,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return const Icon(Icons.restaurant,
                                            size: 40);
                                      },
                                    ),
                                  ),
                                ),

                                // Details
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item.name,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              item.category,
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey.shade600,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                const Icon(Icons.star,
                                                    color: Colors.amber,
                                                    size: 16),
                                                const SizedBox(width: 4),
                                                Text(
                                                  '${item.rating} (${item.reviewCount}+)',
                                                  style: const TextStyle(
                                                      fontSize: 12),
                                                ),
                                              ],
                                            ),
                                            Text(
                                              '\$${item.price.toStringAsFixed(2)}',
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: AppTheme.primaryGreen,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                // Add button
                                Padding(
                                  padding: const EdgeInsets.only(right: 12),
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: const BoxDecoration(
                                      color: AppTheme.primaryGreen,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.add,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Meal suggestion card from API ──
  Widget _buildMealSuggestionCard(MealApiModel meal) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thumbnail
          ClipRRect(
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.network(
              '${meal.thumbnail}/preview',
              height: 110,
              width: double.infinity,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return Container(
                  height: 110,
                  color: Colors.grey.shade200,
                  child: const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                );
              },
              errorBuilder: (_, __, ___) => Container(
                height: 110,
                color: Colors.grey.shade200,
                child: const Icon(Icons.restaurant, size: 40),
              ),
            ),
          ),

          // Info
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  meal.name,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.location_on,
                        size: 12, color: Colors.grey.shade500),
                    const SizedBox(width: 2),
                    Expanded(
                      child: Text(
                        meal.area.isNotEmpty ? meal.area : meal.category,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
