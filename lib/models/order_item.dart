class OrderItem {
  final String foodItemId;
  final String name;
  final int quantity;
  final double price;
  final String imageUrl;

  OrderItem({
    required this.foodItemId,
    required this.name,
    required this.quantity,
    required this.price,
    required this.imageUrl,
  });

  // Calculate total price for this item
  double get totalPrice => price * quantity;

  // Convert to JSON for Firebase
  Map<String, dynamic> toJson() {
    return {
      'foodItemId': foodItemId,
      'name': name,
      'quantity': quantity,
      'price': price,
      'imageUrl': imageUrl,
    };
  }

  // Create from JSON
  factory OrderItem.fromJson(Map<dynamic, dynamic> json) {
    return OrderItem(
      foodItemId: json['foodItemId'] as String,
      name: json['name'] as String,
      quantity: json['quantity'] as int,
      price: (json['price'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String,
    );
  }
}
