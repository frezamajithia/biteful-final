class RestaurantLite {
  final String id;
  final String name;
  final String heroImage;
  final String eta;
  final String fee;
  final double rating;
  final int ratingCount;
  final String distance;
  final String category;
  final List<MenuItem> appetizers;

  RestaurantLite({
    required this.id,
    required this.name,
    required this.heroImage,
    required this.eta,
    required this.fee,
    required this.rating,
    required this.ratingCount,
    required this.distance,
    required this.appetizers,
    this.category = '',
  });

  factory RestaurantLite.fromJson(Map<String, dynamic> json) {
    final deliveryFee = (json['deliveryFee'] as num?)?.toDouble() ?? 0.99;
    final rating = (json['rating'] as num?)?.toDouble() ?? 0.0;
    return RestaurantLite(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      heroImage: json['image'] ?? '',
      eta: json['deliveryTime'] ?? '20-30 min',
      fee: '\$${deliveryFee.toStringAsFixed(2)} delivery',
      rating: rating.clamp(0, 5),
      ratingCount: json['ratingCount'] ?? 100,
      distance: json['distance'] ?? '1.0 km',
      category: json['category'] ?? '',
      appetizers: (json['menuItems'] as List<dynamic>?)
              ?.map((item) => MenuItem.fromJson(item))
              .toList() ??
          [],
    );
  }
}

class MenuItem {
  final String title;
  final String desc;
  final double price;
  MenuItem({required this.title, required this.desc, required this.price});

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      title: json['title'] ?? '',
      desc: json['desc'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'desc': desc,
      'price': price,
    };
  }
}

final restaurants = <RestaurantLite>[
  // Fast Food
  RestaurantLite(
    id: 'bk',
    name: 'Burger King',
    heroImage: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=800',
    eta: '20–30 min',
    fee: '\$0.99 delivery',
    rating: 4.5,
    ratingCount: 1240,
    distance: '1.2 km',
    category: 'Fast Food',
    appetizers: [
      MenuItem(title: 'Whopper', desc: 'Flame-grilled classic', price: 6.99),
      MenuItem(title: 'Fries', desc: 'Crispy golden fries', price: 2.49),
      MenuItem(title: 'Onion Rings', desc: 'Crispy rings', price: 3.99),
    ],
  ),

  // Japanese
  RestaurantLite(
    id: 'sushi247',
    name: 'Sushi 24/7',
    heroImage: 'https://images.unsplash.com/photo-1579871494447-9811cf80d66c?w=800',
    eta: '30–40 min',
    fee: '\$1.49 delivery',
    rating: 4.8,
    ratingCount: 860,
    distance: '2.4 km',
    category: 'Japanese',
    appetizers: [
      MenuItem(title: 'Salmon Roll', desc: 'Fresh salmon rice roll', price: 8.50),
      MenuItem(title: 'Tuna Nigiri', desc: 'Nigiri with tuna', price: 9.99),
      MenuItem(title: 'Miso Soup', desc: 'Classic miso broth', price: 3.00),
    ],
  ),
  RestaurantLite(
    id: 'tokyo_ramen',
    name: 'Tokyo Ramen House',
    heroImage: 'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?w=800',
    eta: '25–35 min',
    fee: '\$1.29 delivery',
    rating: 4.7,
    ratingCount: 520,
    distance: '1.8 km',
    category: 'Japanese',
    appetizers: [
      MenuItem(title: 'Tonkotsu Ramen', desc: 'Rich pork bone broth', price: 13.99),
      MenuItem(title: 'Karaage', desc: 'Japanese fried chicken', price: 7.50),
      MenuItem(title: 'Edamame', desc: 'Salted soybean pods', price: 4.00),
    ],
  ),
  RestaurantLite(
    id: 'sakura_grill',
    name: 'Sakura Grill',
    heroImage: 'https://images.unsplash.com/photo-1553621042-f6e147245754?w=800',
    eta: '35–45 min',
    fee: '\$1.99 delivery',
    rating: 4.9,
    ratingCount: 380,
    distance: '3.1 km',
    category: 'Japanese',
    appetizers: [
      MenuItem(title: 'Wagyu Steak', desc: 'A5 grade wagyu', price: 45.00),
      MenuItem(title: 'Sashimi Platter', desc: 'Chef selection', price: 28.00),
      MenuItem(title: 'Tempura Set', desc: 'Crispy vegetable & shrimp', price: 14.50),
    ],
  ),

  // Pizza
  RestaurantLite(
    id: 'pizza_palace',
    name: 'Pizza Palace',
    heroImage: 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=800',
    eta: '25–35 min',
    fee: '\$0.99 delivery',
    rating: 4.6,
    ratingCount: 540,
    distance: '1.5 km',
    category: 'Pizza',
    appetizers: [
      MenuItem(title: 'Margherita', desc: 'Tomato, mozzarella, basil', price: 10.99),
      MenuItem(title: 'Pepperoni', desc: 'Crispy pepperoni slices', price: 12.49),
      MenuItem(title: 'Garlic Bread', desc: 'Buttery garlic loaf', price: 4.50),
    ],
  ),
  RestaurantLite(
    id: 'napoli_pizzeria',
    name: 'Napoli Pizzeria',
    heroImage: 'https://images.unsplash.com/photo-1574071318508-1cdbab80d002?w=800',
    eta: '30–40 min',
    fee: '\$1.49 delivery',
    rating: 4.8,
    ratingCount: 890,
    distance: '2.2 km',
    category: 'Pizza',
    appetizers: [
      MenuItem(title: 'Quattro Formaggi', desc: 'Four cheese blend', price: 14.99),
      MenuItem(title: 'Diavola', desc: 'Spicy salami & chili', price: 13.49),
      MenuItem(title: 'Tiramisu', desc: 'Classic Italian dessert', price: 6.99),
    ],
  ),
  RestaurantLite(
    id: 'slice_heaven',
    name: 'Slice of Heaven',
    heroImage: 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=800',
    eta: '20–30 min',
    fee: '\$0.79 delivery',
    rating: 4.4,
    ratingCount: 620,
    distance: '0.8 km',
    category: 'Pizza',
    appetizers: [
      MenuItem(title: 'BBQ Chicken', desc: 'Tangy BBQ sauce & chicken', price: 15.99),
      MenuItem(title: 'Veggie Supreme', desc: 'Loaded vegetable pizza', price: 13.99),
      MenuItem(title: 'Cheesy Breadsticks', desc: 'Mozzarella stuffed', price: 5.99),
    ],
  ),

  // Chinese
  RestaurantLite(
    id: 'noodle_house',
    name: 'Noodle House',
    heroImage: 'https://images.unsplash.com/photo-1585032226651-759b368d7246?w=800',
    eta: '20–30 min',
    fee: '\$1.29 delivery',
    rating: 4.7,
    ratingCount: 980,
    distance: '0.9 km',
    category: 'Chinese',
    appetizers: [
      MenuItem(title: 'Chicken Ramen', desc: 'Savory shoyu broth', price: 11.50),
      MenuItem(title: 'Gyoza', desc: 'Pan-fried dumplings', price: 5.99),
      MenuItem(title: 'Seaweed Salad', desc: 'Umami, sesame dressing', price: 4.25),
    ],
  ),
  RestaurantLite(
    id: 'golden_dragon',
    name: 'Golden Dragon',
    heroImage: 'https://images.unsplash.com/photo-1525755662778-989d0524087e?w=800',
    eta: '25–35 min',
    fee: '\$1.49 delivery',
    rating: 4.5,
    ratingCount: 1120,
    distance: '1.6 km',
    category: 'Chinese',
    appetizers: [
      MenuItem(title: 'Kung Pao Chicken', desc: 'Spicy peanut sauce', price: 12.99),
      MenuItem(title: 'Beef Lo Mein', desc: 'Wok-fried noodles', price: 11.49),
      MenuItem(title: 'Spring Rolls', desc: 'Crispy vegetable rolls', price: 5.50),
    ],
  ),
  RestaurantLite(
    id: 'dim_sum_garden',
    name: 'Dim Sum Garden',
    heroImage: 'https://images.unsplash.com/photo-1496116218417-1a781b1c416c?w=800',
    eta: '30–40 min',
    fee: '\$1.79 delivery',
    rating: 4.8,
    ratingCount: 450,
    distance: '2.5 km',
    category: 'Chinese',
    appetizers: [
      MenuItem(title: 'Har Gow', desc: 'Shrimp dumplings', price: 6.99),
      MenuItem(title: 'Siu Mai', desc: 'Pork & shrimp dumplings', price: 6.49),
      MenuItem(title: 'Char Siu Bao', desc: 'BBQ pork buns', price: 5.99),
    ],
  ),

  // Mexican
  RestaurantLite(
    id: 'taco_town',
    name: 'Taco Town',
    heroImage: 'https://images.unsplash.com/photo-1565299585323-38d6b0865b47?w=800',
    eta: '15–25 min',
    fee: '\$0.79 delivery',
    rating: 4.4,
    ratingCount: 720,
    distance: '2.0 km',
    category: 'Mexican',
    appetizers: [
      MenuItem(title: 'Beef Taco', desc: 'Seasoned beef, pico de gallo', price: 3.50),
      MenuItem(title: 'Chicken Quesadilla', desc: 'Melted cheese, salsa', price: 6.75),
      MenuItem(title: 'Churros', desc: 'Cinnamon sugar sticks', price: 3.25),
    ],
  ),
  RestaurantLite(
    id: 'el_mariachi',
    name: 'El Mariachi',
    heroImage: 'https://images.unsplash.com/photo-1551504734-5ee1c4a1479b?w=800',
    eta: '20–30 min',
    fee: '\$0.99 delivery',
    rating: 4.6,
    ratingCount: 560,
    distance: '1.4 km',
    category: 'Mexican',
    appetizers: [
      MenuItem(title: 'Burrito Bowl', desc: 'Rice, beans, guac', price: 11.99),
      MenuItem(title: 'Nachos Grande', desc: 'Loaded cheese nachos', price: 9.49),
      MenuItem(title: 'Guacamole', desc: 'Fresh avocado dip', price: 4.99),
    ],
  ),

  // Dessert
  RestaurantLite(
    id: 'sweet_treats',
    name: 'Sweet Treats Bakery',
    heroImage: 'https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=800',
    eta: '20–30 min',
    fee: '\$1.29 delivery',
    rating: 4.9,
    ratingCount: 680,
    distance: '1.3 km',
    category: 'Dessert',
    appetizers: [
      MenuItem(title: 'Chocolate Cake', desc: 'Rich dark chocolate', price: 6.99),
      MenuItem(title: 'Macarons', desc: '6 assorted flavors', price: 8.50),
      MenuItem(title: 'Cheesecake', desc: 'New York style', price: 7.49),
    ],
  ),
  RestaurantLite(
    id: 'ice_cream_dreams',
    name: 'Ice Cream Dreams',
    heroImage: 'https://images.unsplash.com/photo-1501443762994-82bd5dace89a?w=800',
    eta: '15–25 min',
    fee: '\$0.99 delivery',
    rating: 4.7,
    ratingCount: 420,
    distance: '0.7 km',
    category: 'Dessert',
    appetizers: [
      MenuItem(title: 'Sundae Supreme', desc: 'Fudge, caramel, nuts', price: 7.99),
      MenuItem(title: 'Waffle Cone', desc: '3 scoops of choice', price: 5.99),
      MenuItem(title: 'Milkshake', desc: 'Creamy thick shake', price: 4.99),
    ],
  ),
  RestaurantLite(
    id: 'donut_delight',
    name: 'Donut Delight',
    heroImage: 'https://images.unsplash.com/photo-1551024601-bec78aea704b?w=800',
    eta: '15–20 min',
    fee: '\$0.79 delivery',
    rating: 4.5,
    ratingCount: 890,
    distance: '0.5 km',
    category: 'Dessert',
    appetizers: [
      MenuItem(title: 'Glazed Dozen', desc: '12 classic glazed', price: 9.99),
      MenuItem(title: 'Boston Cream', desc: 'Custard filled', price: 2.49),
      MenuItem(title: 'Maple Bacon', desc: 'Sweet & savory', price: 2.99),
    ],
  ),

  // Healthy
  RestaurantLite(
    id: 'green_bowl',
    name: 'Green Bowl',
    heroImage: 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=800',
    eta: '18–28 min',
    fee: '\$0.99 delivery',
    rating: 4.9,
    ratingCount: 310,
    distance: '1.0 km',
    category: 'Healthy',
    appetizers: [
      MenuItem(title: 'Quinoa Salad', desc: 'Citrus vinaigrette', price: 7.99),
      MenuItem(title: 'Avocado Toast', desc: 'Sourdough, chili flakes', price: 6.50),
      MenuItem(title: 'Berry Yogurt', desc: 'Granola crunch', price: 4.99),
    ],
  ),
  RestaurantLite(
    id: 'fresh_fit',
    name: 'Fresh & Fit',
    heroImage: 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=800',
    eta: '20–30 min',
    fee: '\$1.29 delivery',
    rating: 4.6,
    ratingCount: 280,
    distance: '1.5 km',
    category: 'Healthy',
    appetizers: [
      MenuItem(title: 'Grilled Chicken Bowl', desc: 'Brown rice, veggies', price: 12.99),
      MenuItem(title: 'Smoothie Bowl', desc: 'Açaí, banana, granola', price: 9.99),
      MenuItem(title: 'Protein Wrap', desc: 'Turkey, spinach, hummus', price: 8.99),
    ],
  ),
];
