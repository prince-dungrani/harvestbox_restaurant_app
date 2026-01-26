import '../models/food_item.dart';

class MockData {
  static final List<FoodItem> allItems = [
    // Pizza Items
    FoodItem(
      id: 'pizza_1',
      name: 'Margherita',
      description: 'Fresh mozzarella, house-made basil pesto, and organic tomato sauce.',
      price: 12.99,
      image: 'https://images.unsplash.com/photo-1574071318508-1cdbab80d002?w=400',
      category: 'Pizza',
      rating: 4.7,
      reviewCount: 230,
      isVeg: true,
      isBestSeller: false,
    ),
    FoodItem(
      id: 'pizza_2',
      name: 'Double Pepperoni',
      description: 'Spicy Italian pepperoni, mozzarella, and secret herb spice blend.',
      price: 14.99,
      image: 'https://images.unsplash.com/photo-1628840042765-356cda07504e?w=400',
      category: 'Pizza',
      rating: 4.8,
      reviewCount: 312,
      isSpicy: true,
      isBestSeller: true,
    ),
    FoodItem(
      id: 'pizza_3',
      name: 'Garden Veggie',
      description: 'Bell peppers, sweet onions, mushrooms, and Kalamata olives.',
      price: 13.99,
      image: 'https://images.unsplash.com/photo-1571997478779-2adcbbe9ab2f?w=400',
      category: 'Pizza',
      rating: 4.8,
      reviewCount: 189,
      isVeg: true,
    ),
    FoodItem(
      id: 'pizza_4',
      name: 'Spicy Buffalo',
      description: 'Grilled chicken breast, buffalo sauce, and ranch drizzle.',
      price: 15.49,
      image: 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=400',
      category: 'Pizza',
      rating: 4.6,
      reviewCount: 201,
      isSpicy: true,
    ),
    FoodItem(
      id: 'pizza_5',
      name: 'Truffle Shroom',
      description: 'Wild mushrooms, truffle oil, white garlic sauce.',
      price: 16.99,
      image: 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=400',
      category: 'Pizza',
      rating: 4.5,
      reviewCount: 145,
      isVeg: true,
      isAvailable: false,
    ),

    // Burger Items
    FoodItem(
      id: 'burger_1',
      name: 'Harvest Classic Burger',
      description: 'Angus beef, cheddar, harvest sauce, lettuce, tomato.',
      price: 12.00,
      image: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=400',
      category: 'Burgers',
      rating: 4.7,
      reviewCount: 445,
      isBestSeller: true,
    ),
    FoodItem(
      id: 'burger_2',
      name: 'Green Garden Burger',
      description: 'Plant-based patty, avocado, sprouts, vegan mayo.',
      price: 14.00,
      image: 'https://images.unsplash.com/photo-1520072959219-c595dc870360?w=400',
      category: 'Burgers',
      rating: 4.6,
      reviewCount: 298,
      isVeg: true,
    ),
    FoodItem(
      id: 'burger_3',
      name: 'Spicy BBQ Bacon',
      description: 'Smoked bacon, jalapeños, BBQ sauce, crispy onions.',
      price: 15.50,
      image: 'https://images.unsplash.com/photo-1553979459-d2229ba7433b?w=400',
      category: 'Burgers',
      rating: 4.9,
      reviewCount: 523,
      isSpicy: true,
      isBestSeller: true,
    ),
    FoodItem(
      id: 'burger_4',
      name: 'Mushroom Swiss',
      description: 'Sautéed mushrooms, melted swiss, truffle aioli.',
      price: 13.25,
      image: 'https://images.unsplash.com/photo-1572802419224-296b0aeee0d9?w=400',
      category: 'Burgers',
      rating: 4.7,
      reviewCount: 334,
    ),
    FoodItem(
      id: 'burger_5',
      name: 'Sunrise Burger',
      description: 'Fried egg, hash brown, bacon, maple glaze.',
      price: 14.75,
      image: 'https://images.unsplash.com/photo-1550547660-d9450f859349?w=400',
      category: 'Burgers',
      rating: 4.8,
      reviewCount: 412,
    ),
    FoodItem(
      id: 'burger_6',
      name: 'Classic Beef Burger',
      description: 'With cheese & secret sauce.',
      price: 9.50,
      image: 'https://images.unsplash.com/photo-1561758033-d89a9ad46330?w=400',
      category: 'Burgers',
      rating: 4.5,
      reviewCount: 389,
    ),

    // Coffee Items
    FoodItem(
      id: 'coffee_1',
      name: 'Fresh Roast Coffee',
      description: 'Dark roast, Arabica blend.',
      price: 4.25,
      image: 'https://images.unsplash.com/photo-1509042239860-f550ce710b93?w=400',
      category: 'Coffee',
      rating: 4.8,
      reviewCount: 567,
      isBestSeller: true,
    ),
    FoodItem(
      id: 'coffee_2',
      name: 'Caramel Latte',
      description: 'Espresso, steamed milk, caramel drizzle.',
      price: 5.50,
      image: 'https://images.unsplash.com/photo-1461023058943-07fcbe16d735?w=400',
      category: 'Coffee',
      rating: 4.7,
      reviewCount: 434,
    ),
    FoodItem(
      id: 'coffee_3',
      name: 'Iced Mocha',
      description: 'Chocolate, espresso, cold milk, whipped cream.',
      price: 5.75,
      image: 'https://images.unsplash.com/photo-1517487881594-2787fef5ebf7?w=400',
      category: 'Coffee',
      rating: 4.6,
      reviewCount: 321,
    ),

    // Garlic Bread
    FoodItem(
      id: 'garlic_1',
      name: 'Garlic Herb Bread',
      description: 'Toasted with butter & herbs.',
      price: 5.50,
      image: 'https://images.unsplash.com/photo-1573140401552-3fab0b24306f?w=400',
      category: 'Garlic Bread',
      rating: 4.3,
      reviewCount: 178,
      isVeg: true,
    ),
    FoodItem(
      id: 'garlic_2',
      name: 'Cheesy Garlic Bread',
      description: 'Garlic bread topped with melted mozzarella.',
      price: 6.99,
      image: 'https://images.unsplash.com/photo-1619367784096-6ad86ae6a8b6?w=400',
      category: 'Garlic Bread',
      rating: 4.7,
      reviewCount: 256,
      isVeg: true,
      isBestSeller: true,
    ),

    // Salads
    FoodItem(
      id: 'salad_1',
      name: 'Organic Kale Power Bowl',
      description: 'Kale, quinoa, avocado, tahini dressing.',
      price: 14.50,
      image: 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=400',
      category: 'Salads',
      rating: 4.8,
      reviewCount: 120,
      isVeg: true,
      isBestSeller: false,
    ),
    FoodItem(
      id: 'salad_2',
      name: 'Caesar Salad',
      description: 'Romaine, parmesan, croutons, caesar dressing.',
      price: 11.99,
      image: 'https://images.unsplash.com/photo-1546793665-c74683f339c1?w=400',
      category: 'Salads',
      rating: 4.5,
      reviewCount: 203,
      isVeg: true,
    ),

    // Desserts
    FoodItem(
      id: 'dessert_1',
      name: 'Chocolate Donuts',
      description: 'Fresh glazed chocolate donuts.',
      price: 6.99,
      image: 'https://images.unsplash.com/photo-1527515637462-cff94eecc1ac?w=400',
      category: 'Desserts',
      rating: 4.6,
      reviewCount: 289,
      isBestSeller: true,
    ),
    FoodItem(
      id: 'dessert_2',
      name: 'Tiramisu',
      description: 'Classic Italian coffee-flavored dessert.',
      price: 8.50,
      image: 'https://images.unsplash.com/photo-1571877227200-a0d98ea607e9?w=400',
      category: 'Desserts',
      rating: 4.9,
      reviewCount: 412,
    ),
  ];

  static List<FoodItem> getItemsByCategory(String category) {
    if (category == 'Recommended' || category == 'All') {
      return allItems.where((item) => item.isAvailable).toList();
    }
    return allItems.where((item) => item.category == category && item.isAvailable).toList();
  }

  static List<FoodItem> getPopularItems() {
    return allItems
        .where((item) => item.isBestSeller && item.isAvailable)
        .take(4)
        .toList();
  }

  static List<FoodItem> getRecommended() {
    return allItems
        .where((item) => item.rating >= 4.7 && item.isAvailable)
        .take(5)
        .toList();
  }

  static List<String> getCategories() {
    return ['Recommended', 'Pizza', 'Burgers', 'Coffee', 'Garlic Bread', 'Salads', 'Desserts'];
  }

  static List<String> getTrendingCategories() {
    return ['Pizza', 'Burgers', 'Salads', 'Desserts'];
  }
}
