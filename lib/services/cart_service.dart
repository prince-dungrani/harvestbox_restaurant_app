import 'package:flutter/foundation.dart';
import '../models/cart_item.dart';
import '../models/food_item.dart';

class CartService extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  int get itemCount {
    return _items.fold(0, (total, item) => total + item.quantity);
  }

  double get subtotal {
    return _items.fold(0.0, (total, item) => total + item.totalPrice);
  }

  void addItem(FoodItem foodItem) {
    // Check if item already exists in cart
    final existingIndex = _items.indexWhere((item) => item.foodItem.id == foodItem.id);

    if (existingIndex >= 0) {
      // Item exists, increment quantity
      _items[existingIndex].increment();
    } else {
      // Add new item to cart
      _items.add(CartItem(foodItem: foodItem));
    }

    notifyListeners();
  }

  void removeItem(String foodItemId) {
    _items.removeWhere((item) => item.foodItem.id == foodItemId);
    notifyListeners();
  }

  void updateQuantity(String foodItemId, int quantity) {
    final index = _items.indexWhere((item) => item.foodItem.id == foodItemId);
    if (index >= 0) {
      if (quantity <= 0) {
        removeItem(foodItemId);
      } else {
        _items[index].quantity = quantity;
        notifyListeners();
      }
    }
  }

  void incrementItem(String foodItemId) {
    final index = _items.indexWhere((item) => item.foodItem.id == foodItemId);
    if (index >= 0) {
      _items[index].increment();
      notifyListeners();
    }
  }

  void decrementItem(String foodItemId) {
    final index = _items.indexWhere((item) => item.foodItem.id == foodItemId);
    if (index >= 0) {
      _items[index].decrement();
      if (_items[index].quantity == 0) {
        removeItem(foodItemId);
      }
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  bool isInCart(String foodItemId) {
    return _items.any((item) => item.foodItem.id == foodItemId);
  }

  int getQuantity(String foodItemId) {
    final index = _items.indexWhere((item) => item.foodItem.id == foodItemId);
    return index >= 0 ? _items[index].quantity : 0;
  }
}
