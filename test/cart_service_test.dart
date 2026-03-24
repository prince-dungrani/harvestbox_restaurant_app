import 'package:flutter_test/flutter_test.dart';
import 'package:harvestbox_restaurant_app/models/food_item.dart';
import 'package:harvestbox_restaurant_app/models/cart_item.dart';

/// Standalone cart logic tests that don't require Firebase initialization.
/// We test the cart operations directly using CartItem model + list operations.
void main() {
  // Sample food items for testing
  final testPizza = FoodItem(
    id: 'test_pizza_1',
    name: 'Test Margherita',
    description: 'A test pizza',
    price: 12.99,
    image: 'https://example.com/pizza.jpg',
    category: 'Pizza',
  );

  final testBurger = FoodItem(
    id: 'test_burger_1',
    name: 'Test Burger',
    description: 'A test burger',
    price: 9.50,
    image: 'https://example.com/burger.jpg',
    category: 'Burgers',
  );

  // ── Helper: Simulates CartService logic without Firebase ──
  late List<CartItem> cartItems;

  int itemCount() => cartItems.fold(0, (total, item) => total + item.quantity);
  double subtotal() =>
      cartItems.fold(0.0, (total, item) => total + item.totalPrice);

  void addItem(FoodItem foodItem) {
    final existingIndex =
        cartItems.indexWhere((item) => item.foodItem.id == foodItem.id);
    if (existingIndex >= 0) {
      cartItems[existingIndex].increment();
    } else {
      cartItems.add(CartItem(foodItem: foodItem));
    }
  }

  void removeItem(String foodItemId) {
    cartItems.removeWhere((item) => item.foodItem.id == foodItemId);
  }

  void incrementItem(String foodItemId) {
    final index =
        cartItems.indexWhere((item) => item.foodItem.id == foodItemId);
    if (index >= 0) cartItems[index].increment();
  }

  void decrementItem(String foodItemId) {
    final index =
        cartItems.indexWhere((item) => item.foodItem.id == foodItemId);
    if (index >= 0) {
      cartItems[index].decrement();
      if (cartItems[index].quantity == 0) removeItem(foodItemId);
    }
  }

  void updateQuantity(String foodItemId, int quantity) {
    final index =
        cartItems.indexWhere((item) => item.foodItem.id == foodItemId);
    if (index >= 0) {
      if (quantity <= 0) {
        removeItem(foodItemId);
      } else {
        cartItems[index].quantity = quantity;
      }
    }
  }

  bool isInCart(String foodItemId) {
    return cartItems.any((item) => item.foodItem.id == foodItemId);
  }

  int getQuantity(String foodItemId) {
    final index =
        cartItems.indexWhere((item) => item.foodItem.id == foodItemId);
    return index >= 0 ? cartItems[index].quantity : 0;
  }

  setUp(() {
    cartItems = [];
  });

  // ══════════════════════════════════════════
  // ADD ITEMS
  // ══════════════════════════════════════════
  group('Cart - Add Items', () {
    test('should start with an empty cart', () {
      expect(cartItems, isEmpty);
      expect(itemCount(), 0);
      expect(subtotal(), 0.0);
    });

    test('should add a new item to cart', () {
      addItem(testPizza);

      expect(cartItems.length, 1);
      expect(cartItems.first.foodItem.id, 'test_pizza_1');
      expect(itemCount(), 1);
    });

    test('should increment quantity when adding same item twice', () {
      addItem(testPizza);
      addItem(testPizza);

      expect(cartItems.length, 1); // Still 1 unique item
      expect(itemCount(), 2); // But quantity is 2
      expect(cartItems.first.quantity, 2);
    });

    test('should add multiple different items', () {
      addItem(testPizza);
      addItem(testBurger);

      expect(cartItems.length, 2);
      expect(itemCount(), 2);
    });
  });

  // ══════════════════════════════════════════
  // REMOVE ITEMS
  // ══════════════════════════════════════════
  group('Cart - Remove Items', () {
    test('should remove item from cart by ID', () {
      addItem(testPizza);
      addItem(testBurger);

      removeItem('test_pizza_1');

      expect(cartItems.length, 1);
      expect(cartItems.first.foodItem.id, 'test_burger_1');
    });

    test('should handle removing non-existent item gracefully', () {
      addItem(testPizza);
      removeItem('non_existent_id');

      expect(cartItems.length, 1); // No change
    });
  });

  // ══════════════════════════════════════════
  // UPDATE QUANTITY
  // ══════════════════════════════════════════
  group('Cart - Update Quantity', () {
    test('should increment item quantity', () {
      addItem(testPizza);
      incrementItem('test_pizza_1');

      expect(cartItems.first.quantity, 2);
    });

    test('should decrement item quantity', () {
      addItem(testPizza);
      addItem(testPizza); // qty = 2

      decrementItem('test_pizza_1');

      expect(cartItems.first.quantity, 1);
    });

    test('decrement stops at quantity 1 (CartItem guard)', () {
      addItem(testPizza);
      decrementItem('test_pizza_1');

      // CartItem.decrement() has a guard: only decrements if qty > 1
      // So calling decrement on qty=1 does nothing
      expect(cartItems.length, 1);
      expect(cartItems.first.quantity, 1);
    });

    test('should update quantity to specific value', () {
      addItem(testPizza);
      updateQuantity('test_pizza_1', 5);

      expect(cartItems.first.quantity, 5);
    });

    test('should remove item when quantity set to 0 or less', () {
      addItem(testPizza);
      updateQuantity('test_pizza_1', 0);

      expect(cartItems, isEmpty);
    });
  });

  // ══════════════════════════════════════════
  // CALCULATE TOTAL
  // ══════════════════════════════════════════
  group('Cart - Calculate Total', () {
    test('should calculate subtotal for single item', () {
      addItem(testPizza);

      expect(subtotal(), 12.99);
    });

    test('should calculate subtotal for multiple items', () {
      addItem(testPizza); // 12.99
      addItem(testBurger); // 9.50

      expect(subtotal(), closeTo(22.49, 0.01));
    });

    test('should calculate subtotal with quantity > 1', () {
      addItem(testPizza);
      addItem(testPizza); // qty = 2, price = 12.99 * 2

      expect(subtotal(), closeTo(25.98, 0.01));
    });

    test('should return 0 subtotal when cart is empty', () {
      expect(subtotal(), 0.0);
    });
  });

  // ══════════════════════════════════════════
  // CLEAR CART
  // ══════════════════════════════════════════
  group('Cart - Clear Cart', () {
    test('should clear all items from cart', () {
      addItem(testPizza);
      addItem(testBurger);

      cartItems.clear();

      expect(cartItems, isEmpty);
      expect(itemCount(), 0);
      expect(subtotal(), 0.0);
    });
  });

  // ══════════════════════════════════════════
  // UTILITY METHODS
  // ══════════════════════════════════════════
  group('Cart - Utility Methods', () {
    test('isInCart should return true for existing item', () {
      addItem(testPizza);
      expect(isInCart('test_pizza_1'), true);
    });

    test('isInCart should return false for non-existing item', () {
      expect(isInCart('test_pizza_1'), false);
    });

    test('getQuantity should return correct quantity', () {
      addItem(testPizza);
      addItem(testPizza);
      expect(getQuantity('test_pizza_1'), 2);
    });

    test('getQuantity should return 0 for non-existing item', () {
      expect(getQuantity('test_pizza_1'), 0);
    });
  });

  // ══════════════════════════════════════════
  // FOOD ITEM MODEL
  // ══════════════════════════════════════════
  group('FoodItem Model', () {
    test('should serialize to JSON', () {
      final json = testPizza.toJson();
      expect(json['id'], 'test_pizza_1');
      expect(json['name'], 'Test Margherita');
      expect(json['price'], 12.99);
      expect(json['category'], 'Pizza');
    });

    test('should deserialize from JSON', () {
      final json = {
        'id': 'test_1',
        'name': 'Test Item',
        'description': 'Desc',
        'price': 10.0,
        'image': 'url',
        'category': 'Pizza',
      };
      final item = FoodItem.fromJson(json);
      expect(item.id, 'test_1');
      expect(item.name, 'Test Item');
      expect(item.isAvailable, true); // Default
    });

    test('should handle optional fields with defaults', () {
      final json = {
        'id': 'test_2',
        'name': 'Minimal',
        'description': '',
        'price': 5.0,
        'image': '',
        'category': 'Other',
      };
      final item = FoodItem.fromJson(json);
      expect(item.rating, 0.0);
      expect(item.reviewCount, 0);
      expect(item.isVeg, false);
      expect(item.isSpicy, false);
      expect(item.isBestSeller, false);
      expect(item.isAvailable, true);
    });
  });

  // ══════════════════════════════════════════
  // CART ITEM MODEL
  // ══════════════════════════════════════════
  group('CartItem Model', () {
    test('should initialize with quantity 1', () {
      final cartItem = CartItem(foodItem: testPizza);
      expect(cartItem.quantity, 1);
    });

    test('should calculate totalPrice correctly', () {
      final cartItem = CartItem(foodItem: testPizza);
      cartItem.quantity = 3;
      expect(cartItem.totalPrice, closeTo(38.97, 0.01));
    });

    test('increment should increase quantity by 1', () {
      final cartItem = CartItem(foodItem: testPizza);
      cartItem.increment();
      expect(cartItem.quantity, 2);
    });

    test('decrement should decrease quantity by 1', () {
      final cartItem = CartItem(foodItem: testPizza);
      cartItem.quantity = 3;
      cartItem.decrement();
      expect(cartItem.quantity, 2);
    });
  });
}
