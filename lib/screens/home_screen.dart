import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../data/mock_data.dart';
import '../services/menu_service.dart';
import '../models/food_item.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/food_item_card.dart';
import '../widgets/filter_chip_widget.dart';
import 'discover_screen.dart';
import 'cart_screen.dart';
import 'editable_profile_screen.dart';
import 'admin_panel_screen.dart';

class HomeScreen extends StatefulWidget {
  final String? location;

  const HomeScreen({super.key, this.location});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentNavIndex = 0;
  String _selectedCategory = 'Recommended';
  final List<String> _categories = MockData.getCategories();
  final MenuService _menuService = MenuService();
  bool _hasSeeded = false;

  // Screens for bottom navigation
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      _buildHomeContent(),
      const DiscoverScreen(),
      const CartScreen(),
      const EditableProfileScreen(),
    ];
    _seedDataIfNeeded();
  }

  // Seed initial data from MockData if Firebase is empty
  Future<void> _seedDataIfNeeded() async {
    if (!_hasSeeded) {
      _hasSeeded = true;
      await _menuService.seedMenuItems(MockData.allItems);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: IndexedStack(
        index: _currentNavIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentNavIndex,
        onTap: (index) {
          setState(() {
            _currentNavIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildHomeContent() {
    return SafeArea(
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo and location
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryGreen.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.shopping_bag,
                        color: AppTheme.primaryGreen,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'HarvestBox',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                size: 14,
                                color: AppTheme.primaryGreen,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  widget.location ?? 'Brooklyn, NY',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Admin Panel button
                    IconButton(
                      icon: const Icon(Icons.admin_panel_settings,
                          color: AppTheme.primaryGreen),
                      tooltip: 'Admin Panel',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const AdminPanelScreen()),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.notifications_outlined),
                      onPressed: () {},
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Search bar
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search, color: Colors.grey),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Search for food items',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.tune, color: Colors.grey),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Category tabs
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = category == _selectedCategory;

                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: FilterChipWidget(
                    label: category,
                    isSelected: isSelected,
                    icon: _getCategoryIcon(category),
                    onTap: () {
                      setState(() {
                        _selectedCategory = category;
                        // Rebuild the home content screen
                        _screens[0] = _buildHomeContent();
                      });
                    },
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          // Popular Items Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Popular Items',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('See all'),
                ),
              ],
            ),
          ),

          // 🔥 Food items grid — powered by Firebase StreamBuilder
          Expanded(
            child: StreamBuilder<List<FoodItem>>(
              stream: _menuService.menuItemsByCategoryStream(_selectedCategory),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.error_outline,
                            size: 48, color: Colors.red),
                        const SizedBox(height: 8),
                        Text('Error loading items',
                            style: TextStyle(color: Colors.grey.shade600)),
                      ],
                    ),
                  );
                }

                final items = snapshot.data ?? [];

                if (items.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.restaurant_menu,
                            size: 48, color: Colors.grey.shade400),
                        const SizedBox(height: 8),
                        Text('No items in this category',
                            style: TextStyle(color: Colors.grey.shade600)),
                      ],
                    ),
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return FoodItemCard(item: items[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  IconData? _getCategoryIcon(String category) {
    switch (category) {
      case 'Pizza':
        return Icons.local_pizza;
      case 'Burgers':
        return Icons.lunch_dining;
      case 'Coffee':
        return Icons.local_cafe;
      default:
        return null;
    }
  }
}
