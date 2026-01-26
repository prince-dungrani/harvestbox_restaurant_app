class FoodItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final String image;
  final String category;
  final double rating;
  final int reviewCount;
  final bool isVeg;
  final bool isSpicy;
  final bool isBestSeller;
  final bool isAvailable;

  FoodItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    required this.category,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.isVeg = false,
    this.isSpicy = false,
    this.isBestSeller = false,
    this.isAvailable = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'image': image,
      'category': category,
      'rating': rating,
      'reviewCount': reviewCount,
      'isVeg': isVeg,
      'isSpicy': isSpicy,
      'isBestSeller': isBestSeller,
      'isAvailable': isAvailable,
    };
  }

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'],
      image: json['image'],
      category: json['category'],
      rating: json['rating'] ?? 0.0,
      reviewCount: json['reviewCount'] ?? 0,
      isVeg: json['isVeg'] ?? false,
      isSpicy: json['isSpicy'] ?? false,
      isBestSeller: json['isBestSeller'] ?? false,
      isAvailable: json['isAvailable'] ?? true,
    );
  }
}
