import 'package:firebase_database/firebase_database.dart';
import '../models/food_item.dart';

class MenuService {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  final String _menuPath = 'menu_items';

  // ─── CREATE: Add a new menu item ───
  Future<String?> addMenuItem(FoodItem item) async {
    try {
      final newRef = _database.child(_menuPath).push();
      final itemWithId = FoodItem(
        id: newRef.key!,
        name: item.name,
        description: item.description,
        price: item.price,
        image: item.image,
        category: item.category,
        rating: item.rating,
        reviewCount: item.reviewCount,
        isVeg: item.isVeg,
        isSpicy: item.isSpicy,
        isBestSeller: item.isBestSeller,
        isAvailable: item.isAvailable,
      );
      await newRef.set(itemWithId.toJson());
      return newRef.key;
    } catch (e) {
      print('Error adding menu item: $e');
      rethrow;
    }
  }

  // ─── READ: Get all menu items (one-time) ───
  Future<List<FoodItem>> getMenuItems() async {
    try {
      final snapshot = await _database.child(_menuPath).get();
      if (!snapshot.exists) return [];

      final itemsMap = snapshot.value as Map<dynamic, dynamic>;
      return itemsMap.entries.map((entry) {
        final data = Map<String, dynamic>.from(entry.value as Map);
        data['id'] = entry.key;
        return FoodItem.fromJson(data);
      }).toList();
    } catch (e) {
      print('Error fetching menu items: $e');
      return [];
    }
  }

  // ─── READ: Stream of all menu items (real-time) ───
  Stream<List<FoodItem>> menuItemsStream() {
    return _database.child(_menuPath).onValue.map((event) {
      if (!event.snapshot.exists) return <FoodItem>[];

      final itemsMap = event.snapshot.value as Map<dynamic, dynamic>;
      final items = itemsMap.entries.map((entry) {
        final data = Map<String, dynamic>.from(entry.value as Map);
        data['id'] = entry.key;
        return FoodItem.fromJson(data);
      }).toList();

      // Sort by category then name
      items.sort((a, b) {
        final catCompare = a.category.compareTo(b.category);
        return catCompare != 0 ? catCompare : a.name.compareTo(b.name);
      });

      return items;
    });
  }

  // ─── READ: Get items by category (real-time) ───
  Stream<List<FoodItem>> menuItemsByCategoryStream(String category) {
    return menuItemsStream().map((items) {
      if (category == 'Recommended' || category == 'All') {
        return items.where((item) => item.isAvailable).toList();
      }
      return items
          .where((item) => item.category == category && item.isAvailable)
          .toList();
    });
  }

  // ─── UPDATE: Edit existing menu item ───
  Future<void> updateMenuItem(String itemId, Map<String, dynamic> updates) async {
    try {
      await _database.child(_menuPath).child(itemId).update(updates);
    } catch (e) {
      print('Error updating menu item: $e');
      rethrow;
    }
  }

  // ─── DELETE: Remove a menu item ───
  Future<void> deleteMenuItem(String itemId) async {
    try {
      await _database.child(_menuPath).child(itemId).remove();
    } catch (e) {
      print('Error deleting menu item: $e');
      rethrow;
    }
  }

  // ─── SEED: Populate Firebase with initial mock data ───
  Future<void> seedMenuItems(List<FoodItem> items) async {
    try {
      final snapshot = await _database.child(_menuPath).get();
      if (snapshot.exists) return; // Already seeded

      for (final item in items) {
        await addMenuItem(item);
      }
      print('Menu items seeded successfully!');
    } catch (e) {
      print('Error seeding menu items: $e');
    }
  }
}
